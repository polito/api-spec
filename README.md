# PoliTO API Spec
The OpenAPI specification for the REST API of Politecnico di Torino.

## Project Structure

This specification is organized as a multi-file structure for better maintainability:

- **`openapi.yaml`** - Bundled specification (auto-generated from `src/`)
- **`src/`** - Source files organized by domain:
  - `src/index.yaml` - Main specification file with references
  - `src/paths/` - API endpoints split by domain (common, students, faculty)
  - `src/components/` - Reusable schemas, parameters, responses

**Note:** The `openapi.yaml` file is automatically generated via GitHub Actions. Always edit files in the `src/` directory.

## Development Workflow

### Making Changes to the API Specification

1. **Edit source files** in the `src/` directory:
   ```bash
   # Example: Add a new faculty endpoint
   vim src/paths/faculty/exams.yaml
   ```

2. **Commit and push your changes**:
   ```bash
   git add src/
   git commit -m "feat: add batch exam enrollment endpoint"
   git push
   ```

3. **Automatic bundling** (via GitHub Actions):
   - When you push changes to `src/`, a GitHub Action automatically bundles the specification
   - The bundled `openapi.yaml` is committed back to your branch
   - You'll see a commit from `github-actions[bot]` with message `chore: auto-bundle OpenAPI spec [skip ci]`

4. **Create a Pull Request**:
   - When you create a PR to `master`, validation workflows run automatically
   - The validation checks that:
     - The spec can be bundled without errors
     - Both `swagger-cli` and `openapi-generator` can validate it
     - The `openapi.yaml` is in sync with `src/`
   - PRs cannot be merged if validation fails

### Manual Bundling (Optional)

If you prefer to bundle locally before pushing:

```bash
# Install swagger-cli (one-time setup)
npm install -g swagger-cli

# Bundle the specification
swagger-cli bundle src/index.yaml -o openapi.yaml -t yaml

# Validate the bundled file
swagger-cli validate openapi.yaml

# Commit both source and bundled files
git add src/ openapi.yaml
git commit -m "feat: add new endpoint"
```

**Note:** Manual bundling is optional. The GitHub Action will bundle automatically when you push to `src/`.

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
