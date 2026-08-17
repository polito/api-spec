import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../common.tsp";

import "../../routes/common/auth.tsp";

import "./version.tsp";

using Http;
using OpenAPI;

@service(#{ title: "Polito Auth API" })
@info(#{
  version: version,
  license: #{
    name: "CC BY-NC 4.0",
    url: "https://creativecommons.org/licenses/by-nc/4.0/",
  },
})
@server(
  "https://app.didattica.polito.it/mock/api",
  "Mock server (uses example data)"
)
@server(
  // Decorators are processed in reverse order, so this is the default
  "https://app.didattica.polito.it/api",
  "Production server"
)
@useAuth(BearerAuth)
namespace PolitoAPI;
