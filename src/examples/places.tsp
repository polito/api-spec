import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_geo_location = #{ latitude: 45.064254, longitude: 7.657823 };

const _ex_place_category = #{
  id: "AULA",
  name: "Aula",
  showInMenu: false,
  color: "lightBlue",
  priority: 60,
  highlighted: false,
};

const _ex_place = #{ id: "TO_CIT09_XPTE_088", capacity: 300 };

const _ex_getDepartments_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: "DAUIN",
          name: "Dipartimento di Automatica e Informatica",
          type: "DIP.",
        },
        #{
          id: "DIMEAS",
          name: "Dipartimento di Ingegneria Meccanica e Aerospaziale",
          type: "DIP.",
        }
      ],
    },
  },
};
