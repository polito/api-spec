# PoliTO API Spec
The OpenAPI specification for the REST API of Politecnico di Torino.

## Project Structure

The specification is maintained as a multi-file tree for readability:

- `src/index.yaml` — entry point referenced by tooling
- `src/paths/` — HTTP endpoints grouped by consumer
- `src/components/` — shared schemas, responses, parameters
- `openapi.yaml` — generated bundle (ignored by Git; recreate locally when needed)

Always edit files under `src/`. The bundled file exists only for tooling and publishing workflows.

## Prerequisites

- Node.js 18 (match the CI environment)
- npm (ships with Node.js)
- Optional: Docker and Prism for documentation and mocking

Install dependencies once per clone:

```bash
npm ci
```

## Development Workflow

1. Edit the spec under `src/`.
2. Bundle and validate locally:
   ```bash
   npm run bundle:verify
   ```
   This runs `swagger-cli bundle` and `swagger-cli validate` via the scripts defined in `package.json`. The command regenerates `openapi.yaml` in-place for local tooling and client generation.
3. Commit only the source changes:
   ```bash
   git add src/
   git commit -m "feat: add emergency endpoints"
   ```
   The generated `openapi.yaml` is ignored by Git; keep it unstaged.
4. Open a pull request. The **Validate OpenAPI Specification** workflow runs `npm ci`, `npm run bundle`, `npm run validate`, and validates the bundled spec with `openapi-generator-cli`. The PR must pass this workflow before merging.

### Useful npm scripts

| Command               | Description                                      |
|-----------------------|--------------------------------------------------|
| `npm run bundle`      | Produces `openapi.yaml` from the multi-file spec |
| `npm run validate`    | Validates the current `openapi.yaml` bundle      |
| `npm run bundle:verify` | Bundles then validates in a single step         |

## How to obtain a human-readable interface
If you are accustomed to using Postman, you can just import the .yaml file containing the specification.

Alternatively, you can start a Docker container of swagger-ui directly on your computer by running: 
```bash
docker-compose up
``` 
By default, the web interface will start on port 8080.

## About OpenAPI
These definitions provide a single point of truth that can be used end-to-end:

- **Planning** Shared during product discussions for planning API functionality
- **Implementation** Inform engineering during development
- **Testing** As the basis for testing or mocking API endpoints
- **Documentation** For producing thorough and interactive documentation
- **Tooling** To generate server stubs and client SDKs.

## Running a mock API
We suggest using [Prism](https://github.com/stoplightio/prism) to run a mock version of this API.

After installing it, you can start a mock server with the following command:
```bash
prism mock -h YOUR-LOCAL-IP ./openapi.yaml
```
You only need to specify your IP if you want them to be accessible from other devices in the same network (e.g. while working on [@polito/students-app](https://github.com/polito/students-app), since it will typically run on a distinct device).

## Resources

- [OAS3 Specification](http://spec.openapis.org/oas/v3.0.3)
- [OAS3 Examples](https://github.com/OAI/OpenAPI-Specification/tree/master/examples/v3.0)
