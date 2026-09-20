import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";

using Http;
using OpenAPI;

namespace PolitoAPI;

model Event {
  @example("graduation-2026-01")
  id: string;

  @example("Lauree")
  contextName: string;

  @example("LAUREE")
  contextId: string;

  @example("Cerimonia di proclamazione")
  title: string;

  @example(utcDateTime.fromISO("2026-07-20T09:00:00Z"))
  eventStartsAt: utcDateTime;

  @example(utcDateTime.fromISO("2026-07-20T12:00:00Z"))
  eventEndsAt: utcDateTime;

  @example("La invitiamo a presentarsi mezz’ora prima dell’orario previsto")
  accessInfo: string;

  @example("Cerimonia di proclamazione e consegna dei diplomi")
  description?: string;

  @example("TO_CEN03_XPTE_000")
  place: string | null;

  @example("Aula Magna")
  placeName: string | null;

  @example(15)
  totalAdmissions: integer;

  @example(8)
  remainingAdmissions: integer;
}

@tag("Event Admissions")
@route("/event-admissions")
interface EventAdmission {
  @get
  @summary("Get upcoming events user is admitted to | Ottieni i prossimi eventi a cui l'utente è ammesso")
  getEventAdmissions(): OkDataResponse<Event[]> | BaseErrors;
}
