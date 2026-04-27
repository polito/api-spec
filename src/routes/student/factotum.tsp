import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/factotum.tsp";
import "../common/factotum.tsp";

namespace PolitoAPI;

using Http;

/** Vista minimale per gli studenti: solo tipo di problema e data */
@example(_ex_student_incident_overview)
model StudentIncidentOverview {
  id: string;
  date: utcDateTime;
  issueCategory: IssueCategory;
}

model StudentIncidentFormData {
  place: PlaceRef | null;
  issueCategories: IssueCategory[];
  predefinedDescriptions: string[];
}

model CreateStudentIncidentRequest {
  place: HttpPart<PlaceRef>;
  idIssueCategory: HttpPart<string>;
  description: HttpPart<string>;
  attachment?: HttpPart<bytes>;
}

@tag("Factotum")
@route("/incidents")
interface StudentFactotum {
  @get
  @route("/form-data")
  @summary("Get incident form data | Dati per form segnalazione")
  @opExample(_ex_student_getIncidentFormData_resp)
  getIncidentFormData(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<StudentIncidentFormData> | BaseErrors;

  @get
  @summary("List my incidents | Elenca le mie segnalazioni")
  @opExample(_ex_student_getIncidents_resp)
  getIncidents(): OkDataResponse<StudentIncidentOverview[]> | BaseErrors;

  @post
  @summary("Create incident | Crea segnalazione")
  @opExample(_ex_student_createIncident_resp)
  createIncident(
    @header contentType: "multipart/form-data",
    @multipartBody body: CreateStudentIncidentRequest,
  ): OkDataCreatedResponse<StudentIncidentOverview> | BaseErrors;
}
