import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/factotum.tsp";

namespace PolitoAPI;

using Http;

enum IncidentStatus {
  new: "new",
  inProgress: "in_progress",
  resolved: "resolved",
  closed: "closed",
}

/** Relativo al tipo di problema */
@example(_ex_issue_category)
model IssueCategory {
  id: string;
  name: string;
  description: string;
}

@example(_ex_equipment)
model Equipment {
  id: string;
  name: string;
  description: string;
}

/**
 * Vista minimale di una segnalazione: id, data e categoria di problema.
 * Faculty estende questo modello con i dettagli completi.
 */
@example(_ex_incident_overview)
model IncidentOverview {
  id: string;
  date: utcDateTime;
  issueCategory: IssueCategory;
}

/**
 * Dati per precompilare il form di nuova segnalazione: riferimento al
 * locale, categorie di problema disponibili ed eventuali attrezzature.
 * `equipments` è null per gli utenti che non gestiscono attrezzature.
 */
model IncidentFormData {
  place: PlaceRef;
  issueCategories: IssueCategory[];
  equipments: Equipment[] | null;
}

model IncidentRequest {
  place: HttpPart<PlaceRef>;
  idIssueCategory: HttpPart<string>;
  description: HttpPart<string>;
  idEquipment?: HttpPart<string>;

  /** Lista di allegati. Si è ipotizzato l'upload di immagini, da verificare. */
  attachments?: HttpPart<bytes>[];
}

@tag("Factotum")
@route("/incidents")
interface Factotum {
  /**
   * Restituisce i dati necessari a precompilare il form di nuova segnalazione
   * per uno specifico locale: riferimento al posto, categorie di problema
   * disponibili e attrezzature eventualmente presenti.
   */
  @get
  @route("/form-data")
  @summary("Get incident form data | Dati per form segnalazione")
  @opExample(_ex_getIncidentFormData_resp)
  getIncidentFormData(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<IncidentFormData> | BaseErrors;

  /**
   * Elenca le segnalazioni associate a uno specifico locale in vista
   * minimale (id, data, categoria di problema). Utile per consultare lo
   * storico dei problemi di un locale prima di aprirne una nuova.
   */
  @get
  @route("/by-place")
  @summary("List incidents at a place | Elenca segnalazioni del locale")
  @opExample(_ex_roomIncidents_resp)
  roomIncidents(
    @query buildingId: string,
    @query floorId: string,
    @query roomId: string,
  ): OkDataResponse<IncidentOverview[]> | BaseErrors;

  /**
   * Crea una nuova segnalazione di guasto/anomalia. La richiesta è
   * multipart/form-data per consentire l'upload opzionale di allegati
   * (es. foto del problema). Il riferimento al locale, la categoria e la
   * descrizione sono obbligatori; l'attrezzatura coinvolta è opzionale.
   */
  @post
  @summary("Create incident | Crea segnalazione")
  createIncident(
    @header contentType: "multipart/form-data",
    @multipartBody body: IncidentRequest,
  ): OkResponse | BaseErrors;
}
