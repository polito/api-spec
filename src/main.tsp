import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "./common.tsp";

import "./routes/auth.tsp";
import "./routes/student.tsp";
import "./routes/bookings.tsp";
import "./routes/courses.tsp";
import "./routes/exams.tsp";
import "./routes/esc.tsp";
import "./routes/news.tsp";
import "./routes/people.tsp";
import "./routes/places.tsp";
import "./routes/tickets.tsp";
import "./routes/job-offers.tsp";
import "./routes/offering.tsp";
import "./routes/surveys.tsp";

import "./version.tsp";

using Http;
using OpenAPI;

@service(#{ title: "Polito Students API" })
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
namespace PolitoAPI;
