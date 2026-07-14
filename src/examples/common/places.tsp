import "@typespec/http";

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

const _ex_geo_json_point = #{
  type: "Point",
  coordinates: #[45.064254, 7.657823],
};

const _ex_geo_json_feature_geometry = #{
  type: "Feature",
  geometry: #{
    type: "LineString",
    coordinates: #[#[7.657823, 45.064254], #[7.658123, 45.064754]],
  },
  properties: #{ bl_id: "B1", fn_fl_id: "F1" },
};

const _ex_navigation_response_feature = #{
  type: "FeatureCollection",
  startPoint: _ex_geo_json_point,
  endPoint: #{ type: "Point", coordinates: #[7.658123, 45.064754] },
  segmentId: 1,
  isPrivate: false,
  features: _ex_geo_json_feature_geometry,
};

const _ex_navigation_response = #{
  type: "FeatureCollection",
  totDistance: 1240,
  stairsCount: 2,
  elevatorsCount: 1,
  stepsCount: 18,
  features: #[_ex_navigation_response_feature],
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
