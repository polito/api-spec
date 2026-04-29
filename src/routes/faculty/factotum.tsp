import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/faculty/factotum.tsp";
import "../common/factotum.tsp";

namespace PolitoAPI;

using Http;

/**
 * Allegato di una segnalazione. Da chiarire se può essere solo una foto
 * oppure qualunque tipo di file.
 */
@example(_ex_incident_attachment)
model IncidentAttachment {
  id: numeric;
  filename: string;
  mimeType: string;
  sizeInKiloBytes: integer;
}

/**
 * Segnalazione completa lato faculty: estende `IncidentOverview` con
 * descrizione, stato, locale, eventuale attrezzatura e allegati.
 */
@example(_ex_incident)
model Incident extends IncidentOverview {
  description: string;
  status: IncidentStatus;
  place: PlaceRef;
  equipment: Equipment | null;
  attachments: IncidentAttachment[];
}

@tag("Factotum")
@route("/incidents")
interface FacultyFactotum {
  /**
   * Elenca le segnalazioni create dall'utente autenticato, con tutti i
   * dettagli (descrizione, stato, allegati).
   */
  @get
  @summary("List incidents | Elenca segnalazioni")
  @opExample(_ex_faculty_listIncidents_resp)
  listIncidents(): OkDataResponse<IncidentOverview[]> | BaseErrors;

  /**
   * Restituisce la singola segnalazione identificata da `incidentId`,
   * con tutti i dettagli.
   */
  @get
  @route("/{incidentId}")
  @summary("Get incident | Mostra segnalazione")
  @opExample(_ex_faculty_getIncident_resp)
  getIncident(
    @path incidentId: string,
  ): OkDataResponse<Incident> | NotFoundResponse | BaseErrors;

  /**
   * Elimina una segnalazione esistente.
   */
  @route("/{incidentId}")
  @delete
  @summary("Delete incident | Elimina segnalazione")
  deleteIncident(
    @path incidentId: string,
  ): NoContentResponse | NotFoundResponse | BaseErrors;

  /**
   * Scarica il contenuto binario di un allegato di una segnalazione.
   * Può rispondere con il file inline oppure con un redirect a una URL
   * di download temporanea.
   */
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
