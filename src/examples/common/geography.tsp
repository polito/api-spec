import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_getCountries_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[#{ id: "IT", name: "Italia" }, #{ id: "FR", name: "Francia" }],
    },
  },
};

const _ex_getItalianMunicipalities_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: "004130",
          name: "Mondovì",
          province: #{ id: "CN", name: "Cuneo" },
        }
      ],
    },
  },
};
