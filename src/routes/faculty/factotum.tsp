import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/faculty/factotum.tsp";
import "../common/factotum.tsp";

namespace PolitoAPI;

using Http;

/**
 * Attachment of an incident. To be clarified whether it can be only a photo
 * or any type of file.
 */
@example(_ex_incident_attachment)
model IncidentAttachment {
  id: numeric;
  filename: string;
  mimeType: string;
  sizeInKiloBytes: integer;
}

/**
 * Full incident on the faculty side: extends `IncidentOverview` with
 * description, status and attachments. Category details are retrieved
 * from the relevant endpoint.
 */
@example(_ex_incident)
model Incident extends IncidentOverview {
  description: string;
  status: IncidentStatus;
  attachments: IncidentAttachment[];
}

@tag("Factotum")
@route("/incidents/reports")
interface FacultyFactotum {
  /**
   * Returns the single incident identified by `incidentId`,
   * with all the details.
   */
  @get
  @route("/{incidentId}")
  @summary("Get incident (faculty) | Mostra segnalazione (faculty)")
  @opExample(_ex_faculty_getIncident_resp)
  getIncident(
    @path incidentId: string,
  ): OkDataResponse<Incident> | NotFoundResponse | BaseErrors;

  /**
   * Cancels an existing incident.
   */
  @route("/{incidentId}")
  @delete
  @summary("Delete incident (faculty) | Annulla segnalazione (faculty)")
  deleteIncident(
    @path incidentId: string,
  ): NoContentResponse | NotFoundResponse | BaseErrors;

  /**
   * Downloads the binary content of an incident attachment.
   * May respond with the file inline or with a redirect to a temporary
   * download URL.
   */
  @get
  @route("/{incidentId}/attachments/{attachmentId}")
  @summary("Download incident attachment (faculty) | Scarica allegato segnalazione (faculty)")
  getIncidentAttachment(@path incidentId: string, @path attachmentId: integer):
    | {
        @header contentType: "application/octet-stream";
        @body body: bytes;
      }
    | RedirectResponse
    | NotFoundResponse
    | BaseErrors;
}
