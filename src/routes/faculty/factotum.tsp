import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/faculty/factotum.tsp";
import "../common/factotum.tsp";

namespace PolitoAPI;

using Http;

@example(_ex_equipment)
model Equipment {
  id: string;
  name: string;
  description: string;
}

// chiarire se l'attachment è solo foto, oppure può essere qualunque tipo di file
@example(_ex_incident_attachment)
model IncidentAttachment {
  id: numeric;
  filename: string;
  mimeType: string;
  sizeInKiloBytes: integer;
}

@example(_ex_incident_report)
model IncidentReport {
  id: string;
  description: string;
  date: utcDateTime;
  status: IncidentStatus;
  place: PlaceRef;
  issueCategory: IssueCategory;
  equipment: Equipment | null;
  attachments: IncidentAttachment[];
}

model FacultyIncidentFormData {
  place: PlaceRef | null;
  issueCategories: IssueCategory[];
  equipments: Equipment[];
  predefinedDescriptions: string[];
}

model CreateFacultyIncidentRequest {
  place: HttpPart<PlaceRef>;
  idIssueCategory: HttpPart<string>;
  description: HttpPart<string>;
  idEquipment?: HttpPart<string>;
  attachment?: HttpPart<bytes>;
}

model UpdateIncidentRequest {
  description?: string;
  idIssueCategory?: string;
  idEquipment?: string;
  status?: IncidentStatus;
}

@tag("Factotum")
@route("/incidents")
interface FacultyFactotum {
  @get
  @route("/form-data")
  @summary("Get incident form data | Dati per form segnalazione")
  @opExample(_ex_faculty_getIncidentFormData_resp)
  getIncidentFormData(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<FacultyIncidentFormData> | BaseErrors;

  @get
  @summary("List my incidents | Elenca le mie segnalazioni")
  @opExample(_ex_faculty_getIncidents_resp)
  getIncidents(): OkDataResponse<IncidentReport[]> | BaseErrors;

  @get
  @route("/by-place")
  @summary("List incidents at a place | Elenca segnalazioni del locale")
  @opExample(_ex_faculty_getIncidentsByPlace_resp)
  getIncidentsByPlace(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<IncidentReport[]> | BaseErrors;

  @post
  @summary("Create incident | Crea segnalazione")
  @opExample(_ex_faculty_createIncident_resp)
  createIncident(
    @header contentType: "multipart/form-data",
    @multipartBody body: CreateFacultyIncidentRequest,
  ): OkDataCreatedResponse<IncidentReport> | BaseErrors;

  @get
  @route("/{incidentId}")
  @summary("Show incident | Mostra segnalazione")
  @opExample(_ex_getIncident_resp)
  getIncident(
    @path incidentId: string,
  ): OkDataResponse<IncidentReport> | BaseErrors;

  @route("/{incidentId}")
  @put
  @summary("Update incident | Modifica segnalazione")
  @opExample(_ex_updateIncident_resp)
  updateIncident(
    @path incidentId: string,
    @body body: UpdateIncidentRequest,
  ): OkDataResponse<IncidentReport> | NotFoundResponse | BaseErrors;

  @get
  @route("/{incidentId}/attachments/{attachmentId}")
  @summary("Download incident attachment | Scarica allegato segnalazione")
  getIncidentAttachment(@path incidentId: string, @path attachmentId: integer):
    | {
        @header contentType: "application/octet-stream";
        @body body: bytes;
      }
    | RedirectResponse
    | NotFoundResponse
    | BaseErrors;
}
