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

// File and folder management requests

model CreateCourseFolderRequest {
  @example("Laboratori")
  name: string;

  /** Parent folder. If omitted, the folder is created in the root. */
  parentId?: string | null;
}

model UpdateCourseFolderRequest {
  @example("Laboratori 2024")
  name?: string;

  /** New parent folder to move the folder to. */
  parentId?: string | null;
}

model CourseFileUpload {
  /** Files to upload. Multiple files can be uploaded at once. */
  files: HttpPart<bytes>[];

  /** Destination folder. If omitted, files are uploaded to the root. */
  parentId?: HttpPart<string>;
}

model UpdateCourseFileRequest {
  @example("Lecture1.pdf")
  name?: string;

  /** New parent folder to move the file to. */
  parentId?: string | null;
}

model MoveCourseItemsRequest {
  /** IDs of files and/or folders to move. */
  @example(#["2", "33352562"])
  itemIds: string[];

  /** Destination folder. `null` moves to the root. */
  destinationFolderId: string | null;
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

@tag("Faculty - Course Files")
@route("/faculty/courses/{courseId}/files")
interface FacultyCourseFiles {
  @post
  @route("/folders")
  @summary("Create folder | Crea cartella")
  @opExample(_ex_createCourseFolder_resp)
  createCourseFolder(
    @path courseId: integer,
    @body body: CreateCourseFolderRequest,
  ): OkDataCreatedResponse<CourseDirectory> | NotAuthorized | NotFound | BaseErrors;

  @patch(#{ implicitOptionality: false })
  @route("/folders/{folderId}")
  @summary("Update folder | Modifica cartella")
  @opExample(_ex_updateCourseFolder_resp)
  updateCourseFolder(
    @path courseId: integer,
    @path folderId: string,
    @body body: UpdateCourseFolderRequest,
  ): OkDataResponse<CourseDirectory> | NotAuthorized | NotFound | BaseErrors;

  @delete
  @route("/folders/{folderId}")
  @summary("Delete folder | Elimina cartella")
  @doc("Elimina la cartella e ricorsivamente tutto il suo contenuto.")
  deleteCourseFolder(
    @path courseId: integer,
    @path folderId: string,
  ): NoContentResponse | NotAuthorized | NotFound | BaseErrors;

  @post
  @summary("Upload files | Carica file")
  @doc("Carica uno o più file nel corso. La richiesta è multipart/form-data e accetta più file contemporaneamente.")
  uploadCourseFiles(
    @path courseId: integer,
    @header contentType: "multipart/form-data",
    @multipartBody body: CourseFileUpload,
  ): OkDataCreatedResponse<CourseFileOverview[]> | NotAuthorized | NotFound | BaseErrors;

  @post
  @route("/move")
  @summary("Move files | Sposta file")
  @doc("Sposta uno o più file e/o cartelle in una cartella di destinazione.")
  @opExample(_ex_moveCourseItems_resp)
  moveCourseItems(
    @path courseId: integer,
    @body body: MoveCourseItemsRequest,
  ): NoContentResponse | NotAuthorized | NotFound | BaseErrors;

  @patch(#{ implicitOptionality: false })
  @route("/{fileId}")
  @summary("Update file | Modifica file")
  @opExample(_ex_updateCourseFile_resp)
  updateCourseFile(
    @path courseId: integer,
    @path fileId: string,
    @body body: UpdateCourseFileRequest,
  ): OkDataResponse<CourseFileOverview> | NotAuthorized | NotFound | BaseErrors;

  @delete
  @route("/{fileId}")
  @summary("Delete file | Elimina file")
  deleteCourseFile(
    @path courseId: integer,
    @path fileId: string,
  ): NoContentResponse | NotAuthorized | NotFound | BaseErrors;
}
