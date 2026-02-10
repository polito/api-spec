import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_degree_overview = #{ id: "81-6", name: "Design e comunicazione" };

const _ex_offering_class = #{
  name: "Disegno industriale",
  code: "L-4",
  degrees: #[#{ id: "81-6", name: "Design e comunicazione" }],
};

const _ex_offering_course_overview = #{
  name: "System and device programming",
  shortcode: "01NYHOV",
  cfu: 10,
  teachingYear: 1,
  language: "en",
  group: "Insegnamento a scelta 1",
};

const _ex_track = #{
  id: 2060,
  name: "Design per la comunicazione",
  courses: #[
    #{
      name: "System and device programming",
      shortcode: "01NYHOV",
      cfu: 10,
      teachingYear: 1,
      language: "en",
      group: "Insegnamento a scelta 1",
    }
  ],
};
