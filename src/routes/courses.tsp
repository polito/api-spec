import "@typespec/http";
import "@typespec/openapi3";

import "../common.tsp";

import "../examples/courses.tsp";

using Http;
using OpenAPI;

namespace PolitoAPI;

model CourseModuleEdition {
  @example("2021")
  year: string;

  @example(244577)
  id: integer;
}

@example(_ex_course_module)
model CourseModule {
  /** The identifier for the current instance of this course.
   * If null this is not a teaching (such as thesis), it won't have a course page */
  @example(258674)
  id: integer | null;

  @example("System and device programming")
  name: string;

  /** The semester(s) this course belongs to */
  @example("2-2")
  teachingPeriod: string;

  @example(2893)
  teacherId: integer | null;

  @example("Mario Rossi")
  teacherName: string | null;

  /** Previous editions of this course that were part of the student's PSP */
  @example(#[#{ id: 244577, year: "2021" }])
  previousEditions: CourseModuleEdition[];

  @example(false)
  isOverBooking: boolean;

  /** Included in the PSP | Incluso nel carico didattico */
  @example(true)
  isInPersonalStudyPlan: boolean;

  @example("2022")
  year: string;
}

model CourseOverview extends CourseModule {
  @example(10)
  cfu: integer;

  @example("01NYHOV")
  shortcode: string;

  modules: CourseModule[] | null;
}

model Course {
  /** The identifier for the current instance of this course. If null this is not a teaching (such as thesis), it won't have a course page */
  @example(258674)
  id: integer | null;

  @example("System and device programming")
  name: string;

  @example("01NYHOV")
  shortcode: string;

  @example(10)
  cfu: integer;

  /** The semester(s) this course belongs to */
  @example("2-2")
  teachingPeriod: string;

  @example(2893)
  teacherId: integer | null;

  @example(false)
  isOverBooking: boolean;

  /** Included in the PSP | Incluso nel carico didattico */
  @example(true)
  isInPersonalStudyPlan: boolean;

  @example("2022")
  year: string;

  links: {
    @example("https://docs.google.com/document/d/13hpWEDQxziSkhSU0PuqxMXntqZYp3ffDKZ2-umQ7Ywo/edit?usp=sharing")
    url: string;

    @example("Calendario settimanale dei contenuti del corso")
    description?: string;
  }[];
  moodleCourses: {
    @example("Analisi Matematica I")
    name?: string;

    @example("645376")
    id?: string;
  }[] | null;

  @example(#[#{ id: 244577, year: "2021" }])
  vcPreviousYears: CourseModuleEdition[];

  /** Other editions/courses to be included in virtual classrooms */
  vcOtherCourses: {
    ...CourseModuleEdition;

    @example("Fisica II")
    name: string;
  }[];

  notifications: {
    @example(true)
    notices: boolean;

    @example(true)
    files: boolean;

    @example(true)
    lectures: boolean;
  };
  staff: {
    role: string;

    @example(244577)
    id: numeric;
  }[];
}

@example(_ex_course_directory)
model CourseDirectory {
  id: string;
  name: string;
  files: CourseDirectoryContent;
  type: "directory";
}

@example(_ex_course_file_overview)
model CourseFileOverview {
  @example("33352562")
  id: string;

  @example("Laboratori")
  name: string;

  @example(305)
  sizeInKiloBytes: integer;

  @example("application/x-zip-compressed")
  mimeType: string;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  createdAt: utcDateTime;

  type: "file";

  @example("deadbeefcafebabe0000000000000000")
  checksum: string;
}

@oneOf
@discriminated(#{ envelope: "none", discriminatorPropertyName: "type" })
union CourseDirectoryEntry {
  directory: CourseDirectory,
  file: CourseFileOverview,
}

model CourseDirectoryContent is CourseDirectoryEntry[];

model VideoLecture {
  id: integer;
  title: string;
  teacherId: integer;
  abstract: string;
  coverUrl: string;
  videoUrl: string;
  audioUrl: string;
  createdAt: utcDateTime;
  duration: string;
}

model VirtualClassroomBase {
  id: integer;
  title: string;
  createdAt: utcDateTime;
  teacherId: integer;
}

model VirtualClassroomRecording extends VirtualClassroomBase {
  coverUrl: string | null;
  videoUrl: string;
  duration: string;
  type: "recording";
}

model VirtualClassroomLive extends VirtualClassroomBase {
  meetingId?: string;
  type: "live";
}

@discriminated(#{ envelope: "none", discriminatorPropertyName: "type" })
union VirtualClassroom {
  live: VirtualClassroomLive,
  recording: VirtualClassroomRecording,
}

@route("/v2/courses")
@tag("Courses")
interface CoursesV2 {
  @get
  @summary("List courses | Elenca corsi")
  @opExample(_ex_courses_list)
  getCourses(): OkDataResponse<CourseOverview[]> | BaseErrors;
}

model CourseAssignmentUpload {
  description: HttpPart<string>;
  file: HttpPart<bytes>;
}

model CourseAssignment {
  @example(947503)
  id: integer;

  @example("laboratorio 3")
  description: string;

  @example("application/x-zip-compressed")
  mimeType: string;

  @example("lab_03.zip")
  filename: string;

  @example(utcDateTime.fromISO("2022-09-02T14:00:00Z"))
  uploadedAt: utcDateTime;

  deletedAt: utcDateTime | null;

  @example("https://file.didattica.polito.it/down/ELABORATI_PRE/1003948/S290683/6791f0016c78599138828211522fa84d/62cebc94")
  url: string;

  @example(305)
  sizeInKiloBytes: integer;
}

model CourseNotices {
  @example(360724)
  id: integer;

  @example(utcDateTime.fromISO("2022-07-03T14:00:00Z"))
  publishedAt: utcDateTime;

  expiresAt: utcDateTime | null;

  @example("<p>Conferma spostamento orario esame:</p><p><b>Ore 15</b></p>")
  content: string;
}

model CoursePreferencesRequest {
  notifications?: {
    @example(true)
    notices?: boolean;

    @example(true)
    files?: boolean;

    @example(true)
    lectures?: boolean;
  };
}

model UpdateAssignmentRequest {
  delivery?: boolean;
  state?: "submitted" | "uploaded";
}

@tag("Courses")
@route("/courses")
interface Courses {
  @route("/{courseId}")
  @get
  @summary("Show course | Mostra corso")
  getCourse(@path courseId: integer): OkDataResponse<Course> | BaseErrors;

  @route("/{courseId}/files")
  @get
  @summary("List files | Elenca file")
  @opExample(_ex_getCourseFiles_resp)
  getCourseFiles(
    @path courseId: integer,
  ): OkDataResponse<CourseDirectoryContent> | BaseErrors;

  @route("/{courseId}/files/{fileId}")
  @get
  @summary("Download file | Scarica file")
  getCourseFile(@path courseId: integer, @path fileId: string):
    | OkResponse
    | RedirectResponse
    | NotFoundResponse
    | BaseErrors;

  @route("/{courseId}/assignments")
  @get
  @summary("List assignments | Elenca elaborati")
  @opExample(_ex_getCourseAssignments_resp)
  getCourseAssignments(
    @path courseId: integer,
  ): OkDataResponse<CourseAssignment[]> | BaseErrors;

  @route("/{courseId}/assignments")
  @post
  @summary("Upload assignment | Carica elaborato")
  uploadCourseAssignment(
    @path courseId: integer,
    @header contentType: "multipart/form-data",
    @multipartBody body: CourseAssignmentUpload,
  ): NoContentResponse | BaseErrors;

  @route("/{courseId}/assignments/{assignmentId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update assignment | Aggiorna elaborato")
  updateAssignment(
    @path courseId: integer,
    @path assignmentId: integer,
    @body body: UpdateAssignmentRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{courseId}/guide")
  @get
  @summary("Show guide | Mostra guida")
  @opExample(_ex_getCourseGuide_resp)
  getCourseGuide(
    @path courseId: integer,
  ): OkDataResponse<GuideSection[]> | BaseErrors;

  @route("/{courseId}/notices")
  @get
  @summary("List notices | Elenca avvisi")
  @opExample(_ex_getCourseNotices_resp)
  getCourseNotices(
    @path courseId: integer,
  ): OkDataResponse<CourseNotices[]> | BaseErrors;

  @route("/{courseId}/virtual-classrooms")
  @get
  @summary("List virtual classrooms | Elenca virtual classroom")
  @opExample(_ex_getCourseVirtualClassrooms_resp)
  getCourseVirtualClassrooms(
    @path courseId: integer,

    /** Filter virtual classrooms by their live status */
    @query live?: boolean,
  ): OkDataResponse<VirtualClassroom[]> | BaseErrors;

  @route("/{courseId}/videolectures")
  @get
  @summary("List videolectures | Elenca videolezioni")
  getCourseVideolectures(
    @path courseId: integer,
  ): OkDataResponse<VideoLecture[]> | BaseErrors;

  @route("/{courseId}/nextLecture")
  @get
  @summary("Get next lecture | Ottieni prossima lezione")
  @opExample(_ex_getNextLecture_resp)
  getNextLecture(@path courseId: integer): OkDataResponse<Lecture> | BaseErrors;

  @route("/{courseId}/preferences")
  @patch(#{ implicitOptionality: false })
  @summary("Update course preferences | Aggiorna preferenze del corso")
  updateCoursePreferences(
    @path courseId: integer,
    @body body: CoursePreferencesRequest,
  ): NoContentResponse | BaseErrors;
}

@tag("Lectures")
@route("/lectures")
interface Lectures {
  @get
  @summary("List lectures | Elenca lezioni")
  @opExample(_ex_getLectures_resp)
  getLectures(
    /** First day - defaults to 7 days before today */
    @query fromDate?: plainDate,

    /** Last day - defaults to 7 days after today */
    @query toDate?: plainDate,

    /** Only include lectures belonging to these courses */
    @query(#{ explode: true }) `courseIds[]`?: numeric[],
  ): OkDataResponse<Lecture[]> | BaseErrors;
}
