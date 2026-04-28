import "@typespec/http";
import "../common/factotum.tsp";

using Http;

namespace PolitoAPI;

const _ex_student_incident_overview = #{
  id: "INC-2026-0042",
  date: utcDateTime.fromISO("2026-04-20T18:30:00Z"),
  issueCategory: _ex_issue_category,
};

const _ex_student_roomIncidents_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        _ex_student_incident_overview,
        #{
          id: "INC-2026-0039",
          date: utcDateTime.fromISO("2026-01-25T15:09:00Z"),
          issueCategory: #{
            id: "ELETTRICO",
            name: "Elettrico",
            description: "Problemi elettrici",
          },
        }
      ],
    },
  },
};

const _ex_student_getIncidentFormData_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        place: #[_ex_place_ref],
        issueCategories: _ex_issue_categories_list,
      },
    },
  },
};

const _ex_student_createIncident_resp = #{
  returnType: #{
    statusCode: 201,
    body: #{ data: _ex_student_incident_overview },
  },
};
