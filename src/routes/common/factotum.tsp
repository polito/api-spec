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

/**
 * Priorità di intervento associata a una categoria di problema.
 * Determina l'urgenza con cui la segnalazione viene gestita.
 */
enum IncidentPriority {
  low: "low",
  medium: "medium",
  high: "high",
  urgent: "urgent",
}

/** Relativo al tipo di problema */
@example(_ex_issue_category)
model IssueCategory {
  id: string;
  name: string;
  description: string;

  /** Priorità selezionabili all'apertura di una segnalazione di questa categoria. */
  priority: IncidentPriority[];
}

/**
 * Vista minimale di una segnalazione: id, data, locale e id della
 * categoria di problema. I dettagli della categoria si recuperano da
 * `/incidents/categories`. Faculty estende questo modello con i
 * dettagli completi.
 */
@example(_ex_incident_overview)
model IncidentOverview {
  id: string;
  date: utcDateTime;
  issueCategoryId: string;
  place: PlaceIds;
}

model IncidentRequest {
  place: HttpPart<PlaceIds>;
  issueCategoryId: HttpPart<string>;
  description: HttpPart<string>;

  /**
   * Lista di allegati. Si è ipotizzato l'upload di immagini, da verificare.
   * Numero massimo di allegati: 4.
   */
  attachments?: HttpPart<bytes>[];
}

@tag("Factotum")
@route("/incidents")
interface Factotum {
  /**
   * Elenca le categorie di problema disponibili. Le categorie sono globali
   * e non dipendono dal locale.
   */
  @get
  @route("/categories")
  @summary("List issue categories | Elenca categorie di problema")
  @opExample(_ex_getIssueCategories_resp)
  getIssueCategories(): OkDataResponse<IssueCategory[]> | BaseErrors;

  /**
   * Elenca le segnalazioni in vista minimale (id, data, id categoria di
   * problema). Se i filtri di locale sono specificati, restituisce solo le
   * segnalazioni associate a quel locale (utile per consultare lo storico
   * prima di aprirne una nuova); senza filtri restituisce tutte le
   * segnalazioni dell'utente autenticato.
   */
  @get
  @route("/reports")
  @summary("List incidents | Elenca segnalazioni")
  @opExample(_ex_listIncidents_resp)
  listIncidents(
    @query buildingId?: string,
    @query floorId?: string,
    @query roomId?: string,
  ): OkDataResponse<IncidentOverview[]> | BaseErrors;

  /**
   * Crea una nuova segnalazione di guasto/anomalia. La richiesta è
   * multipart/form-data per consentire l'upload opzionale di allegati
   * (es. foto del problema). Il riferimento al locale, la categoria e la
   * descrizione sono obbligatori.
   */
  @post
  @route("/reports")
  @summary("Create incident | Crea segnalazione")
  createIncident(
    @header contentType: "multipart/form-data",
    @multipartBody body: IncidentRequest,
  ): OkResponse | BaseErrors;
}
