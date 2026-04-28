import "@typespec/http";
import "../common/factotum.tsp";

using Http;

namespace PolitoAPI;

const _ex_equipment = #{
  id: "EQ-00123",
  name: "Proiettore aula",
  description: "Proiettore a soffitto Epson EB-992F",
};

const _ex_incident_attachment = #{
  id: 0,
  filename: "foto.jpg",
  mimeType: "image/jpeg",
  sizeInKiloBytes: 512,
};

const _ex_incident_report = #{
  id: "INC-2026-0042",
  description: "Rubinetto del bagno donne che perde da ieri sera",
  date: utcDateTime.fromISO("2026-04-20T18:30:00Z"),
  status: IncidentStatus.new,
  place: _ex_place_ref,
  issueCategory: _ex_issue_category,
  equipment: null,
  attachments: #[_ex_incident_attachment],
};

const _ex_faculty_myIncidents_resp = #{
  returnType: #{ statusCode: 200, body: #{ data: #[_ex_incident_report] } },
};

const _ex_faculty_roomIncidents_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        _ex_incident_report,
        #{
          id: "INC-2026-0040",
          description: "Banco rotto",
          date: utcDateTime.fromISO("2026-01-19T16:28:00Z"),
          status: IncidentStatus.resolved,
          place: _ex_place_ref,
          issueCategory: #{
            id: "ARREDI",
            name: "Arredi",
            description: "Arredi danneggiati",
          },
          equipment: null,
          attachments: #[],
        }
      ],
    },
  },
};

const _ex_faculty_getIncidentFormData_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        place: #[_ex_place_ref],
        issueCategories: _ex_issue_categories_list,
        equipments: #[_ex_equipment],
      },
    },
  },
};

const _ex_faculty_createIncident_resp = #{
  returnType: #{ statusCode: 201, body: #{ data: _ex_incident_report } },
};

