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
