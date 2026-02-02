import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/people.tsp";

namespace PolitoAPI;

using Http;

@example(_ex_person_course)
model PersonCourse {
  /** The identifier for this course */
  @example(258674)
  id: integer;

  /** The shortcode for this course */
  @example("01NYHOV")
  shortcode?: string;

  /** The name of the course */
  @example("Computer sciences")
  name: string;

  /** The role of the person in this course */
  @example("Collaboratore")
  role: string;

  /** The year this course was given in */
  @example(2021)
  year: numeric;
}

@example(_ex_person_overview)
model PersonOverview {
  @example(2154)
  id: numeric;

  @example("Fulvio")
  firstName: string;

  @example("Corno")
  lastName: string;

  @example("https://www.swas.polito.it/_library/image_pub.asp?matricola=002154")
  picture: string | null;

  @example("Docente")
  role: string;
}

@example(_ex_phone_number)
model PhoneNumber {
  @example("0110907053")
  full: string;

  @example("7053")
  internal: string;
}

@example(_ex_person)
model Person extends PersonOverview {
  @example("fulvio.corno@polito.it")
  email: string;

  phoneNumbers: PhoneNumber[];

  @example("DAUIN")
  facilityShortName: string | null;

  @example("https://www.dauin.polito.it/personale/scheda/(matricola)/002154")
  profileUrl: string;

  courses: PersonCourse[] | null;
}

@tag("People")
@route("/people")
interface People {
  @get
  @summary("Search people | Cerca persone")
  getPeople(
    /** Filter people containing 'search' in their full name */
    @query search: string,
  ): OkDataResponse<PersonOverview[]> | BaseErrors;

  @get
  @route("/{personId}")
  @summary("Show person | Mostra persona")
  getPerson(@path personId: numeric): OkDataResponse<Person> | BaseErrors;
}
