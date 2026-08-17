import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/auth.tsp";

using Http;
using OpenAPI;

namespace PolitoAPI;

@example(_ex_switchCareer_req)
model SwitchCareerRequest {
  @example("s290683")
  username: string;

  client?: Client;
  device?: Device;
}

@tag("Student Auth")
@route("/auth")
interface StudentAuth {
  @post
  @route("/switch-career")
  @summary("Switch career | Cambia carriera")
  switchCareer(
    @body body: SwitchCareerRequest,
  ): OkDataResponse<Identity> | BaseErrors;
}
