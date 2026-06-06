import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../common/courses.tsp";
import "../../examples/faculty/courses.tsp";

using Http;

namespace PolitoAPI;

// Models

model FacultyCourseStudent {
  @example("s123456")
  id: string;

  @example("Mario")
  firstName: string;

  @example("Rossi")
  lastName: string;

  @example("s123456")
  username: string;

  picture?: {
    @example("https://example.com/picture.jpg")
    url: url;
  };
}

model CourseMessageRequest {
  @example("Avviso importante")
  subject: string;

  @example("Messaggio importante")
  message: string;

  channels: string[];
  audience: {
    groups: string[];
    personIds: string[];
  };
}

model CourseNoticeRequest {
  @example("Contenuto dell'avviso")
  content: string;

  @example(utcDateTime.fromISO("2022-07-03T14:00:00Z"))
  publishedDate: utcDateTime;

  expiresAt: utcDateTime | null;

  @example(true)
  isAlwaysVisible: boolean;
}

// Response aliases with descriptions

@doc("Studente già iscritto")
model StudentAlreadyEnrolledResponse {
  ...OkDataResponse<FacultyCourseStudent>;
}

@doc("Accepted (sending)")
model CourseMessageAcceptedResponse {
  ...AcceptedResponse;
}

@tag("Faculty - Courses")
@route("/faculty/courses/{courseId}")
interface FacultyCourses {
  @post
  @route("/notices")
  @summary("Publish notices | Pubblica avvisi")
  @opExample(_ex_publishCourseNotice_req)
  publishCourseNotice(
    @path courseId: integer,
    @path isDraft: boolean,
    @body body: CourseNoticeRequest,
  ): NoContentResponse | BaseErrors;

  @put
  @route("/notices/{noticeId}")
  @summary("Update notice | Modifica avviso")
  @opExample(_ex_updateCourseNotice_resp)
  updateCourseNotice(
    @path courseId: integer,
    @path noticeId: integer,
    @body body: CourseNoticeRequest,
  ): NoContentResponse | BaseErrors;

  @delete
  @route("/notices/{noticeId}")
  @summary("Delete notice | Elimina avviso")
  @opExample(_ex_deleteCourseNotice_resp)
  deleteCourseNotice(
    @path courseId: integer,
    @path noticeId: integer,
  ): NoContentResponse | BaseErrors;

  @get
  @route("/students")
  @summary("Elenca studenti iscritti al corso")
  @opExample(_ex_listFacultyCourseStudents_resp)
  listFacultyCourseStudents(@path courseId: integer):
    | OkDataResponse<FacultyCourseStudent[]>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @put
  @route("/students/{studentId}")
  @summary("Aggiungi studente al corso")
  @doc("Operazione idempotente per iscrivere uno studente al corso.")
  enrollStudentInCourse(@path courseId: integer, @path studentId: string):
    | OkDataResponse<FacultyCourseStudent>
    | OkDataCreatedResponse<FacultyCourseStudent>
    | NotAuthorized
    | BadRequest
    | NotFound
    | BaseErrors;

  @post
  @route("/message")
  @summary("Invia comunicazione agli iscritti al corso")
  messageCourseSubscribers(
    @path courseId: integer,
    @body body: CourseMessageRequest,
  ): CourseMessageAcceptedResponse | NotAuthorized | BadRequest | BaseErrors;
}
