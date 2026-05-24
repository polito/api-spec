import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_issue_category = #{
  id: "IDRAULICO",
  name: "Idraulico",
  description: "Problemi idraulici: rubinetti, scarichi, perdite",
};

const _ex_place_id = #{
  siteId: "TO_CIT",
  buildingId: "TO_CIT11",
  floorId: "XP02",
  roomId: "017",
};

const _ex_issue_categories_list = #[
  #{ id: "ELETTRICO", name: "Elettrico", description: "Problemi elettrici" },
  #{ id: "IDRAULICO", name: "Idraulico", description: "Problemi idraulici" },
  #{ id: "ARREDI", name: "Arredi", description: "Arredi danneggiati" },
  #{
    id: "CLIMA",
    name: "Condizionamento e Riscaldamento",
    description: "Problemi climatizzazione",
  }
];

const _ex_predefined_descriptions = #[
  "Flusso di lavoro",
  "Risposta necessaria entro 1 Settimana",
  "Completamento necessario entro 1 Mesi",
  "Nessuna procedura necessaria"
];

const _ex_incident_overview = #{
  id: "INC-2026-0042",
  date: utcDateTime.fromISO("2026-04-20T18:30:00Z"),
  issueCategoryId: "IDRAULICO",
  place: _ex_place_id,
};

const _ex_listIncidents_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        _ex_incident_overview,
        #{
          id: "INC-2026-0039",
          date: utcDateTime.fromISO("2026-01-25T15:09:00Z"),
          issueCategoryId: "ELETTRICO",
          place: _ex_place_id,
        }
      ],
    },
  },
};

const _ex_getIssueCategories_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{ data: _ex_issue_categories_list },
  },
};

