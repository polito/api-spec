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
 * Intervention priority associated with an issue category.
 * Determines the urgency with which the incident is handled.
 */
enum IncidentPriority {
  low: "low",
  medium: "medium",
  high: "high",
  urgent: "urgent",
}

/** Related to the type of issue */
@example(_ex_issue_category)
model IssueCategory {
  id: string;
  name: string;
  description: string;

  /** Priorities selectable when opening an incident of this category. */
  priority: IncidentPriority[];
}

/**
 * Minimal view of an incident: id, date, place and issue category id.
 * Category details are retrieved from `/incidents/categories`. Faculty
 * extends this model with the full details.
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
  priority: HttpPart<IncidentPriority>;
  description: HttpPart<string>;
  attachment?: HttpPart<bytes>;
}

@tag("Factotum")
@route("/incidents")
interface Factotum {
  /**
   * Lists the available issue categories. Categories are global
   * and do not depend on the place.
   */
  @get
  @route("/categories")
  @summary("List issue categories | Elenca categorie di problema")
  @opExample(_ex_getIssueCategories_resp)
  getIssueCategories(): OkDataResponse<IssueCategory[]> | BaseErrors;

  /**
   * Lists incidents in minimal view (id, date, issue category id). If the
   * place filters are specified, returns only the incidents associated with
   * that place (useful for consulting the history before opening a new one);
   * without filters it returns all the incidents of the authenticated user.
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
   * Creates a new fault/anomaly incident. The request is
   * multipart/form-data to allow the optional upload of an attachment
   * (e.g. photo of the problem). The place reference, the category, the
   * priority and the description are mandatory.
   */
  @post
  @route("/reports")
  @summary("Create incident | Crea segnalazione")
  createIncident(
    @header contentType: "multipart/form-data",
    @multipartBody body: IncidentRequest,
  ): OkDataResponse<{
    insertedId: integer;
  }> | BaseErrors;
}
