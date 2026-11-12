import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/emergencies.tsp";

namespace PolitoAPI;

using Http;

enum EmergencyCtaType {
  /** Calls `phoneNumber` directly */
  call,

  /** Opens `url` */
  link,

  /** Opens the site picker built from `EmergencyData.sites` */
  sites,
}

@example(_ex_emergency_hour)
model EmergencyHour {
  day: string;
  open: string;
  close: string;
}

@example(_ex_emergency_site)
model EmergencySite {
  /** Matches `Site.id`: clients use its coordinates to find the nearest site */
  siteId: string;

  name: string;

  /** Places where the emergency service is located */
  places: PlaceRef[];

  phoneNumber: string;
  hours: EmergencyHour[];
  backup: boolean;
}

@example(_ex_emergency_cta_112)
model EmergencyCta {
  text: string;
  type: EmergencyCtaType;

  /** Set when `type` is `call` */
  phoneNumber?: string;

  /** Set when `type` is `link` */
  url?: url;

  /** Font Awesome icon name shown in the button */
  icon?: string;

  primary: boolean;
}

@example(_ex_emergency_content)
model EmergencyContent {
  /** Card title, omitted when the emergency has a single card */
  title?: string;

  htmlContent: string;
  cta: EmergencyCta[];
}

@example(_ex_emergency)
model Emergency {
  id: string;
  name: string;
  title: string;
  icon: string;
  content: EmergencyContent[];
  cta: EmergencyCta[];
}

@example(_ex_emergency_data)
model EmergencyData {
  /** Content depends on the authenticated user's role */
  emergencies: Emergency[];

  sites: EmergencySite[];

  /** Actions shown on the emergencies list */
  cta: EmergencyCta[];
}

@tag("Emergencies")
@route("/emergencies")
interface Emergencies {
  @get
  @summary("Show emergency procedures and contacts | Mostra procedure e contatti di emergenza")
  getEmergencies(): OkDataResponse<EmergencyData> | BaseErrors;
}
