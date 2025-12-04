import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_person_overview = #{
  id: 2154,
  firstName: "Fulvio",
  lastName: "Corno",
  picture: "https://www.swas.polito.it/_library/image_pub.asp?matricola=002154",
  role: "Docente",
};

const _ex_phone_number = #{ full: "0110907053", internal: "7053" };

const _ex_person_course = #{
  id: 258674,
  shortcode: "01NYHOV",
  name: "Computer sciences",
  role: "Collaboratore",
  year: 2021,
};

const _ex_person = #{
  id: 2154,
  firstName: "Fulvio",
  lastName: "Corno",
  picture: "https://www.swas.polito.it/_library/image_pub.asp?matricola=002154",
  role: "Docente",
  email: "fulvio.corno@polito.it",
  phoneNumbers: #[#{ full: "0110907053", internal: "7053" }],
  facilityShortName: "DAUIN",
  profileUrl: "https://www.dauin.polito.it/personale/scheda/(matricola)/002154",
  courses: #[
    #{
      id: 258674,
      shortcode: "01NYHOV",
      name: "Computer sciences",
      role: "Collaboratore",
      year: 2021,
    }
  ],
};
