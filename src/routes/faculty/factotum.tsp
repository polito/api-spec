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
 * Segnalazione completa. Lato faculty descrizione e allegati sono
 * sempre visibili.
 */
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
  place: PlaceRef[] | null;
  issueCategories: IssueCategory[];
  equipments: Equipment[];
}

model CreateFacultyIncidentRequest {
  place: HttpPart<PlaceRef>;
  idIssueCategory: HttpPart<string>;
  description: HttpPart<string>;
  idEquipment?: HttpPart<string>;
  attachments?: HttpPart<bytes>[];
}

@tag("Factotum")
@route("/incidents")
interface FacultyFactotum {
  /**
   * Restituisce i dati necessari a precompilare il form di nuova segnalazione
   * per uno specifico locale: riferimento al posto, categorie di problema
   * disponibili, attrezzature presenti e descrizioni predefinite.
   */
  @get
  @route("/form-data")
  @summary("Get incident form data | Dati per form segnalazione")
  @opExample(_ex_faculty_getIncidentFormData_resp)
  getIncidentFormData(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<FacultyIncidentFormData> | BaseErrors;

  /**
   * Elenca le segnalazioni create dall'utente autenticato, con tutti i
   * dettagli (descrizione, stato, allegati).
   */
  @get
  @route("/myIncidents")
  @summary("List my incidents | Elenca le mie segnalazioni")
  @opExample(_ex_faculty_myIncidents_resp)
  myIncidents(): OkDataResponse<IncidentReport[]> | BaseErrors;

  /**
   * Elenca le segnalazioni associate a uno specifico locale, indipendentemente
   * da chi le ha create. Utile per consultare lo storico dei problemi del
   * locale prima di aprirne una nuova.
   */
  @get
  @route("/roomIncidents")
  @summary("List incidents at a place | Elenca segnalazioni del locale")
  @opExample(_ex_faculty_roomIncidents_resp)
  roomIncidents(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<IncidentReport[]> | BaseErrors;

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

@tag("Factotum")
@route("/incident")
interface FacultyFactotumCreate {
  /**
   * Crea una nuova segnalazione di guasto/anomalia. La richiesta è
   * multipart/form-data per consentire l'upload opzionale di un allegato
   * (es. foto del problema). Il riferimento al locale, la categoria e la
   * descrizione sono obbligatori; l'attrezzatura coinvolta è opzionale.
   */
  @post
  @summary("Create incident | Crea segnalazione")
  @opExample(_ex_faculty_createIncident_resp)
  createIncident(
    @header contentType: "multipart/form-data",
    @multipartBody body: CreateFacultyIncidentRequest,
  ): OkDataCreatedResponse<IncidentReport> | BaseErrors;
}
