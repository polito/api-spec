import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_survey_course_ref = #{
  id: 1,
  name: "Course name",
  shortcode: "01NYHOV",
};

const _ex_survey_taxonomy = #{ id: "CPD", name: "CPD" };

const _ex_survey = #{
  id: 1,
  title: "Survey title",
  subtitle: "Survey subtitle",
  category: #{ id: "CPD", name: "CPD" },
  type: #{ id: "CPD", name: "CPD" },
  period: 2,
  year: "2024",
  isMandatory: true,
  isCompiled: false,
  compileDate: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
  url: "https://",
  startsAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
  endsAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
  course: #{ id: 1, name: "Course name", shortcode: "01NYHOV" },
};
