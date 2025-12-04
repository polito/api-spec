import "@typespec/http";
import "@typespec/openapi3";

import "../common.tsp";
import "../examples/surveys.tsp";

namespace PolitoAPI;

using Http;

@example(_ex_survey_course_ref)
model SurveyCourseRef {
  @example(1)
  id: numeric;

  @example("Course name")
  name: string;

  @example("01NYHOV")
  shortcode: string;
}

@example(_ex_survey_taxonomy)
model SurveyTaxonomy {
  @example("CPD")
  id: string;

  @example("CPD")
  name: string;
}

@example(_ex_survey)
model Survey {
  @example(1)
  id: numeric;

  @example("Survey title")
  title: string;

  @example("Survey subtitle")
  subtitle: string | null;

  category: SurveyTaxonomy;
  type: SurveyTaxonomy;

  @example(2)
  period: numeric;

  @example("2024")
  year: string;

  @example(true)
  isMandatory: boolean;

  @example(false)
  isCompiled: boolean;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  compileDate: utcDateTime | null;

  @example("https://")
  url: string;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  startsAt: utcDateTime;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  endsAt: utcDateTime;

  course?: SurveyCourseRef | null;
}

@tag("Surveys")
@route("/surveys")
interface Surveys {
  @get
  @summary("Get surveys | Mostra survey")
  getSurveys(): OkDataResponse<Survey[]> | BaseErrors;
}
