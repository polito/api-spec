import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/offering.tsp";

namespace PolitoAPI;

using Http;

@example(_ex_degree_overview)
model DegreeOverview {
  @example("81-6")
  id: string;

  @example("Design e comunicazione")
  name: string;
}

@example(_ex_offering_class)
model OfferingClass {
  @example("Disegno industriale")
  name: string;

  @example("L-4")
  code: string;

  degrees: DegreeOverview[];
}

@example(_ex_track)
model Track {
  @example(2060)
  id: numeric;

  @example("Design per la comunicazione")
  name: string;

  courses: OfferingCourseOverview[];
}

model Degree {
  ...DegreeOverview;
  level: string;
  department: {
    name: string;
  };
  faculty: {
    id?: string;
    name?: string;
  };
  location: string;
  duration: string;
  class: {
    code: string;
    name: string;
  };
  year: numeric;

  /** All the available editions of this degree */
  editions: string[];

  @example(#["Corso tenuto in italiano"])
  notes: string[];

  objectives: {
    @example("Obiettivi formativi")
    title: string;

    content: string;
  };
  jobOpportunities: {
    title: string;
    content: string;
  };
  tracks: Track[];
}

@example(_ex_offering_course_overview)
model OfferingCourseOverview {
  @example("System and device programming")
  name: string;

  @example("01NYHOV")
  shortcode: string;

  @example(10)
  cfu: integer;

  /** The year this course belongs to in this degree */
  @example(1)
  teachingYear: integer;

  @example("en")
  language: "it" | "en";

  @example("Insegnamento a scelta 1")
  group: string | null;
}

model OfferingCourseStaff {
  role: string;
  id: numeric;
  courseId: numeric;
}

model CourseHours {
  lecture?: integer;
  tutoring?: integer;
  classroomExercise?: integer;
  labExercise?: integer;
}

model OfferingCourse {
  name: string;
  shortcode: string;
  cfu: integer;

  /** The semester(s) this course belongs to */
  teachingPeriod: string;

  languages: ("it" | "en")[];
  year: string;
  hours: CourseHours;

  /** All the available editions of this course */
  editions: string[];

  staff: OfferingCourseStaff[];
  guide: GuideSection[];
}

model Teacher {
  id: integer;
  firstName: string;
  lastName: string;
}

model GradeCount {
  grade:
    | "18"
    | "19"
    | "20"
    | "21"
    | "22"
    | "23"
    | "24"
    | "25"
    | "26"
    | "27"
    | "28"
    | "29"
    | "30"
    | "30L";
  count: integer;
}

model YearStatistics {
  succeeded: integer;
  failed: integer;
  grades: GradeCount[];
  averageGrade: numeric | null;
}

model PreviousYearsToCompare {
  year: integer;
  succeeded: integer;
  failed: integer;
}

model CourseStatistics {
  shortcode: string;
  year: integer;
  teacher: Teacher;
  totalEnrolled: integer;
  totalSucceeded: integer;
  totalFailed: integer;
  firstYear: YearStatistics;
  otherYears: YearStatistics;
  previousYearsToCompare: PreviousYearsToCompare[];
  years: integer[];
  teachers: Teacher[];
}

model OfferingResponse {
  bachelor?: OfferingClass[];
  master?: OfferingClass[];
}

@tag("Offering")
@route("/offering")
interface Offering {
  @get
  @summary("Get offering | Mostra offerta formativa")
  getOffering(): OkDataResponse<OfferingResponse> | BaseErrors;

  @route("/degrees/{degreeId}")
  @get
  @summary("Show a degree | Mostra un corso di laurea")
  getOfferingDegree(
    @path degreeId: string,
    @query year?: string,
  ): OkDataResponse<Degree> | BaseErrors;

  @route("/courses/{courseShortcode}")
  @get
  @summary("Show offering course | Mostra corso dell'offerta formativa")
  getOfferingCourse(
    @path courseShortcode: string,
    @query year?: string,
  ): OkDataResponse<OfferingCourse> | BaseErrors;

  @route("/courses/{courseShortcode}/statistics")
  @get
  @summary("Retrieve course statistics | Recupera le statistiche dell'insegnamento")
  getCourseStatistics(
    @path courseShortcode: string,
    @query year?: string,
    @query teacherId?: string,
  ): OkDataResponse<CourseStatistics> | BaseErrors;
}
