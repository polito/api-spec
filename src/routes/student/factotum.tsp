import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/factotum.tsp";
import "../common/factotum.tsp";

namespace PolitoAPI;

using Http;

/**
 * Vista minimale per gli studenti: solo tipo di problema e data.
 * Da capire se mostrare anche description e attachment, o se sono
 * visibili solo al personale di facoltà.
 */
@example(_ex_student_incident_overview)
model StudentIncidentOverview {
  id: string;
  date: utcDateTime;
  issueCategory: IssueCategory;
}

model StudentIncidentFormData {
  place: PlaceRef[] | null;
  issueCategories: IssueCategory[];
}
model CreateStudentIncidentRequest {
  place: HttpPart<PlaceRef>;
  idIssueCategory: HttpPart<string>;
  description: HttpPart<string>;

  /** Lista di allegati. Si è ipotizzato l'upload di immagini, da verificare. */
  attachments?: HttpPart<bytes>[];
}

@tag("Factotum")
@route("/incidents")
interface StudentFactotum {
  /**
   * Restituisce i dati necessari a precompilare il form di nuova segnalazione
   * per uno specifico locale: riferimento al posto, categorie di problema
   * disponibili e descrizioni predefinite.
   */
  @get
  @route("/form-data")
  @summary("Get incident form data | Dati per form segnalazione")
  @opExample(_ex_student_getIncidentFormData_resp)
  getIncidentFormData(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<StudentIncidentFormData> | BaseErrors;

  /**
   * Elenca le segnalazioni associate a uno specifico locale in vista
   * minimale (id, data, categoria di problema). Lo studente non ha accesso
   * all'elenco delle proprie segnalazioni: può solo consultare lo storico
   * dei problemi di un locale prima di aprirne una nuova.
   */
  @get
  @route("/roomIncidents")
  @summary("List incidents at a place | Elenca segnalazioni del locale")
  @opExample(_ex_student_roomIncidents_resp)
  roomIncidents(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<StudentIncidentOverview[]> | BaseErrors;
}

@tag("Factotum")
@route("/incident")
interface StudentFactotumCreate {
  /**
   * Crea una nuova segnalazione di guasto/anomalia. La richiesta è
   * multipart/form-data per consentire l'upload opzionale di un allegato
   * (es. foto del problema). Il riferimento al locale, la categoria e la
   * descrizione sono obbligatori.
   */
  @post
  @summary("Create incident | Crea segnalazione")
  @opExample(_ex_student_createIncident_resp)
  createIncident(
    @header contentType: "multipart/form-data",
    @multipartBody body: CreateStudentIncidentRequest,
  ): OkDataCreatedResponse<StudentIncidentOverview> | BaseErrors;
}
