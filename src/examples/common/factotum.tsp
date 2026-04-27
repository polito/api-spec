import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_issue_category = #{
  id: "IDRAULICO",
  name: "Idraulico",
  description: "Problemi idraulici: rubinetti, scarichi, perdite",
};

const _ex_place_ref = #{
  siteId: "TO_CIT",
  buildingId: "TO_CIT11",
  floorId: "XP02",
  roomId: "017",
  name: "Aula 1P",
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
