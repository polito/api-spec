import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../common.tsp";

// Common routes
import "../../routes/common/announcements.tsp";
import "../../routes/common/auth.tsp";
import "../../routes/common/bookings.tsp";
import "../../routes/common/courses.tsp";
import "../../routes/common/news.tsp";
import "../../routes/common/people.tsp";
import "../../routes/common/places.tsp";

// Student routes
import "../../routes/student/esc.tsp";
import "../../routes/student/exams.tsp";
import "../../routes/student/job-offers.tsp";
import "../../routes/student/offering.tsp";
import "../../routes/student/student.tsp";
import "../../routes/student/surveys.tsp";
import "../../routes/student/tickets.tsp";

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
@useAuth(BearerAuth)
namespace PolitoAPI;
