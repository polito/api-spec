import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_emergency_hour = #{ day: "Monday", open: "09:00", close: "18:00" };

const _ex_emergency_site = #{
  siteId: "TO_CEN",
  name: "Torino - Sede Centrale",
  places: #[
    #{
      buildingId: "TO_CEN01",
      floorId: "XP00",
      roomId: "TO_CEN01_XP00_001",
      siteId: "TO_CEN",
      name: "Portineria",
    }
  ],
  phoneNumber: "+39 011 090 1234",
  hours: #[_ex_emergency_hour],
  backup: false,
};

const _ex_emergency_cta_112 = #{
  text: "Emergenza 112",
  type: EmergencyCtaType.call,
  phoneNumber: "112",
  icon: "faPhone",
  primary: false,
};

const _ex_emergency_cta_sites = #{
  text: "Chiama Soccorsi PoliTo",
  type: EmergencyCtaType.sites,
  icon: "faPhone",
  primary: true,
};

const _ex_emergency_content = #{
  htmlContent: "<ul><li>Non utilizzare gli <b>ascensori</b>.</li></ul>",
  cta: #[],
};

const _ex_emergency = #{
  id: "fire",
  name: "Incendio",
  title: "Come comportarsi in caso di incendio",
  icon: "faHouseFire",
  content: #[_ex_emergency_content],
  cta: #[_ex_emergency_cta_sites],
};

const _ex_emergency_data = #{
  emergencies: #[_ex_emergency],
  sites: #[_ex_emergency_site],
  cta: #[_ex_emergency_cta_sites, _ex_emergency_cta_112],
};
