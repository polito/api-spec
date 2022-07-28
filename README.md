# PoliTO API Spec
The OpenAPI specification for the REST APIs of Politecnico di Torino.

## How to obtain an human-readable interface
You can start a Docker container of swagger-ui directly on your computer by running: 
```bash
$ docker-compose up
``` 
By default, the web interface will start on port 8080.

Alternatively, you can import the .yaml file on https://editor.swagger.io.

## About OpenAPI
These definitions provide a single point of truth that can be used end-to-end:

- **Planning** Shared during product discussions for planning API functionality
- **Implementation** Inform engineering during development
- **Testing** As the basis for testing or mocking API endpoints
- **Documentation** For producing thorough and interactive documentation
- **Tooling** To generate server stubs and client SDKs.

## Resources

- [OAS3 Specification](http://spec.openapis.org/oas/v3.0.3)
- [OAS3 Examples](https://github.com/OAI/OpenAPI-Specification/tree/master/examples/v3.0)
