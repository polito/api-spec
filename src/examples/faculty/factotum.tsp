import "@typespec/http";
import "../common/factotum.tsp";

using Http;

namespace PolitoAPI;

const _ex_incident_attachment = #{
  id: 0,
  filename: "foto.jpg",
  mimeType: "image/jpeg",
  sizeInKiloBytes: 512,
};

const _ex_incident = #{
  id: "INC-2026-0042",
  description: "Rubinetto del bagno donne che perde da ieri sera",
  date: utcDateTime.fromISO("2026-04-20T18:30:00Z"),
  status: IncidentStatus.new,
  place: _ex_place_id,
  issueCategoryId: "IDRAULICO",
  attachments: #[_ex_incident_attachment],
};

const _ex_faculty_getIncident_resp = #{
  returnType: #{ statusCode: 200, body: #{ data: _ex_incident } },
};
