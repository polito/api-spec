# Copilot Instructions for Polito API Spec

## Project Overview

This is a **TypeSpec-based REST API specification** for the Politecnico di Torino students portal. TypeSpec (`.tsp`) files define the API schema and OpenAPI 3.0 output, replacing hand-written `openapi.yaml`.

**Key Build Flow:**
- `npm run compile` → TypeSpec compiler outputs `dist/openapi.yaml`
- `npm run generate` → OpenAPI generator creates TypeScript client SDK in `dist/client`
- `npm run build` → Runs both compile + generate
- `npm run watch` → Watches for changes and auto-compiles

**Key Files:**
- [src/main.tsp](src/main.tsp) - Service definition, imports all routes
- [src/common.tsp](src/common.tsp) - Shared models (response aliases, common types like `Lecture`, `PlaceRef`)
- [src/routes/](src/routes/) - Feature-specific route definitions (auth, courses, exams, etc.)
- [src/examples/](src/examples/) - Example data constants (paired 1:1 with routes)

---

## Architecture Patterns

### 1. Response Wrapper Pattern

All API responses use standardized aliases from `common.tsp`:

```typespec
// Single object
alias OkResponse<T = null> = { @statusCode statusCode: 200; @body body: T; };

// Data envelope (most common for lists/resources)
alias OkDataResponse<T> = OkResponse<{ data: T; }>;

// Error response
alias ErrorResponse = { code?: string; message?: string; };
```

**Usage in routes:**
```typespec
interface Courses {
  @get list(): OkDataResponse<Course[]> | BadRequest | ServerError;
}
```

The `OkDataResponse<T>` pattern wraps results in `{ data: [...] }` - this is the standard envelope for all resource lists and single objects.

### 2. Route Organization

Each feature has:
- **Route file** (`src/routes/courses.tsp`) - Models + `interface` with HTTP operations
- **Example file** (`src/examples/courses.tsp`) - Example constants for that route
- Routes import their paired example file

Operations use `@get`, `@post`, `@put`, `@patch`, `@delete` decorators with paths like `@route("/courses/{id}")`.

### 3. Bilingual Documentation

Operations include dual-language summaries:
```typespec
@summary("List courses | Elenca corsi")
```

Follow this pattern for all new endpoints.

---

## Examples Pattern

Examples are organized into two categories based on their scope:

### 1. Field-Level Examples (Single Values)

Individual field examples are defined directly on model properties using the `@example` decorator.

**Location:** In model definitions within `src/routes/*.tsp`

**Example:**
```typespec
model Course {
  @example(258674)
  id: integer | null;

  @example("System and device programming")
  name: string;

  @example(10)
  cfu: integer;

  @example("01NYHOV")
  shortcode: string;
}
```

**Usage:** Use this for:
- Scalar values (strings, numbers, booleans, dates)
- Simple inline examples for individual properties
- Field-level documentation

### 2. Complex Examples (Models & Operations)

Complete model instances and operation response examples are defined as constants in dedicated example files, then referenced in route definitions.

#### File Organization

```
src/
├── routes/
│   ├── courses.tsp       ← Route definitions (with @opExample references)
│   ├── lectures.tsp
│   └── ...
├── examples/
│   ├── courses.tsp       ← Example constants (matching routes/courses.tsp)
│   ├── lectures.tsp
│   └── ...
└── common.tsp
```

#### Naming Convention

- Example file: `src/examples/courses.tsp` corresponds to `src/routes/courses.tsp`
- Example constant: `_ex_{operationName}_{context}` OR `_ex_{modelName}` for complex models
  - Examples: `_ex_getLectures_resp`, `_ex_course_module`, `_ex_courses_list`
  - Contexts: `resp` (response), `req` (request), or resource type
  - Use snake_case for readability

#### Defining Examples

In `src/examples/courses.tsp`:

```typespec
const _ex_course_module = #{
  id: 251008,
  name: "Programming Module A",
  teachingPeriod: "2-2",
  teacherId: 3001,
  teacherName: "Mario Rossi",
  previousEditions: #[#{ id: 251005, year: "2024" }],
  isOverBooking: false,
  isInPersonalStudyPlan: true,
  year: "2025",
};

const _ex_getLectures_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: 5001,
          title: "Introduction to Programming",
          date: utcDateTime.fromISO("2025-02-15T10:00:00Z"),
          courseId: 258674,
        },
      ],
    },
  },
};
```

#### Referencing Examples in Routes

In `src/routes/courses.tsp`:

```typespec
import "../examples/courses.tsp";

@example(_ex_course_module)
model CourseModule {
  // ... model definition
}

interface Lectures {
  @get
  @summary("List lectures | Elenca lezioni")
  @opExample(_ex_getLectures_resp)
  getLectures(
    @query fromDate?: plainDate,
    @query toDate?: plainDate,
    @query(#{ explode: true }) `courseIds[]`?: numeric[],
  ): OkDataResponse<Lecture[]> | BaseErrors;
}
```

---

## Best Practices

1. **Keep it organized:** Examples that are specific to a route file live in a corresponding example file
2. **Use utcDateTime.fromISO() for dates:** Wrap ISO timestamp strings with `utcDateTime.fromISO()` for type safety and consistency
3. **Field examples first:** Add `@example` to model properties when defining the model
4. **Complex examples separate:** When a model has a full representative example, define it as a constant in the examples file
5. **Operation examples explicit:** Use `@opExample(constant_name)` on operations that need full request/response examples
6. **Real data when possible:** Use realistic example data that matches actual API behavior (see [src/examples/courses.tsp](src/examples/courses.tsp) for reference)
7. **Remove duplicates from OpenAPI:** When migrating examples from `openapi.yaml` to TypeSpec, remove the inline examples to maintain single source of truth
8. **Wrap arrays with `#[...]`:** TypeSpec array literals use hash-bracket syntax: `#[{ id: 1 }, { id: 2 }]`
9. **Use object shorthand `#{...}`:** For TypeSpec object literals, use hash-brace syntax: `#{ id: 1, name: "test" }`

---

## Example: Complete Workflow

When adding a new endpoint with examples:

1. **Define the model** in `src/routes/myfeature.tsp` with field-level `@example` decorators
2. **Create example data** in `src/examples/myfeature.tsp` for:
   - Complex model instances (if needed)
   - Full operation request/response payloads
3. **Reference the examples** in the route using:
   - `@example(_ex_my_model_example)` on model definitions
   - `@opExample(_ex_my_operation_resp_example)` on operation methods

This keeps the code organized, maintainable, and ensures examples are centralized and reusable.
