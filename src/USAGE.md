# Using the Split OpenAPI Files

This directory contains the split OpenAPI specification files. Here's how to reference and use them.

## Directory Structure

```
src/
├── components/          # Reusable components
│   ├── parameters.yaml           # Query/path parameters
│   ├── responses.yaml            # Common response definitions
│   ├── security-schemes.yaml     # Authentication schemes
│   └── schemas/                  # Data models
│       ├── common.yaml           # Shared schemas
│       ├── students.yaml         # Student-specific schemas
│       └── faculty.yaml          # Faculty-specific schemas
└── paths/              # API endpoints
    ├── common/         # Shared endpoints (9 files)
    ├── students/       # Student endpoints (9 files)
    └── faculty/        # Faculty endpoints (5 files)
```

## Creating a Main OpenAPI File

To create a main OpenAPI specification that references these files, use YAML anchors or external references:

### Option 1: Using External References (Recommended for tooling)

```yaml
openapi: 3.1.1
info:
  title: Polito Students API
  version: 2.2.3
servers:
  - url: https://app.didattica.polito.it/api

security:
  - bearerAuth: []

# Import all paths
paths:
  # Common paths
  /auth/login:
    $ref: './src/paths/common/auth.yaml#/~1auth~1login'
  # ... more references

components:
  parameters:
    courseIdParam:
      $ref: './src/components/parameters.yaml#/courseIdParam'

  responses:
    ErrorResponse:
      $ref: './src/components/responses.yaml#/ErrorResponse'

  schemas:
    Identity:
      $ref: './src/components/schemas/common.yaml#/Identity'

  securitySchemes:
    bearerAuth:
      $ref: './src/components/security-schemes.yaml#/bearerAuth'
```

### Option 2: Using a Build Tool

Use a tool like `swagger-cli` or `redocly` to bundle the files:

```bash
# Install redocly CLI
npm install -g @redocly/cli

# Bundle the split files into a single file
redocly bundle main-openapi.yaml -o bundled-openapi.yaml
```

### Option 3: Manual Import in Code

Many OpenAPI libraries support multi-file specs. For example, with Node.js:

```javascript
const SwaggerParser = require('@apidevtools/swagger-parser');

// This will automatically resolve all $ref references
SwaggerParser.bundle('openapi.yaml')
  .then(api => {
    console.log('API bundled successfully');
  });
```

## File Format Details

### Path Files

Each path file contains path items without the `paths:` key:

```yaml
"/auth/login":
  post:
    tags:
      - Common - Auth
    summary: Login
    # ...

"/auth/logout":
  delete:
    tags:
      - Common - Auth
    summary: Logout
    # ...
```

### Schema Files

Each schema file contains schema definitions without the `schemas:` key:

```yaml
Identity:
  type: object
  properties:
    id:
      type: string
    # ...

Student:
  type: object
  properties:
    # ...
```

### Component Files

Parameters, responses, and security schemes follow the same pattern:

```yaml
# parameters.yaml
courseIdParam:
  name: courseId
  in: path
  required: true
  # ...

# responses.yaml
ErrorResponse:
  description: Server error
  content:
    # ...

# security-schemes.yaml
bearerAuth:
  type: http
  scheme: bearer
```

## References Between Files

All `$ref` references are preserved as-is:

```yaml
# In a path file
schema:
  $ref: "#/components/schemas/Identity"

# In a schema file
properties:
  teacher:
    $ref: "#/components/schemas/Teacher"
```

When bundling, ensure your tool resolves these references correctly.

## Recommended Tools

### Validation
- **Redocly CLI**: Validates and bundles OpenAPI specs
  ```bash
  redocly lint openapi.yaml
  ```

### Documentation
- **Redoc**: Beautiful API documentation
  ```bash
  redocly build-docs openapi.yaml
  ```

### Code Generation
- **OpenAPI Generator**: Generate client/server code
  ```bash
  openapi-generator-cli generate -i openapi.yaml -g java
  ```

## File Categorization

### Common Schemas (75 schemas)
Entities used across all user types:
- Authentication & profiles
- Messages & notifications
- News, places, maps
- Emergency contacts, faults
- People directory
- Bookings
- Course information (shared)
- Common errors

### Students Schemas (41 schemas)
Student-specific entities:
- Student profiles & deadlines
- Exam grades & provisional grades
- European Student Card
- Video lectures & virtual classrooms
- Support tickets
- Job offers
- Degree programs & offering
- Surveys & statistics

### Faculty Schemas (29 schemas)
Faculty-specific entities:
- Faculty profiles
- Exam management & enrollments
- Course management & collaborators
- Course notices & messages
- Room bookings
- Digital signatures
- Calendar & events

## Tips

1. **Keep the structure**: Don't move files without updating references
2. **Use consistent indentation**: All files use 2-space indentation
3. **Preserve comments**: Original comments are kept for documentation
4. **Test after changes**: Always validate after modifying any file
5. **Version control**: Track changes to individual files for better diffs

## Example: Adding a New Endpoint

To add a new endpoint to the Common - Auth section:

1. Open `src/paths/common/auth.yaml`
2. Add your path at the end:
   ```yaml
   "/auth/new-endpoint":
     post:
       tags:
         - Common - Auth
       summary: New endpoint
       # ...
   ```
3. If you need a new schema, add it to the appropriate schema file
4. Validate the changes:
   ```bash
   redocly lint openapi.yaml
   ```

## Example: Adding a New Schema

To add a new student-related schema:

1. Open `src/components/schemas/students.yaml`
2. Add your schema alphabetically:
   ```yaml
   NewStudentEntity:
     type: object
     properties:
       # ...
   ```
3. Reference it from your path file:
   ```yaml
   schema:
     $ref: "#/components/schemas/NewStudentEntity"
   ```

---

For questions or issues, refer to the `EXTRACTION_REPORT.md` for details about the split process.
