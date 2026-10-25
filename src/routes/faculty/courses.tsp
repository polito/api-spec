import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../common/courses.tsp";
import "../../examples/faculty/courses.tsp";

using Http;

namespace PolitoAPI;

// Models

model FacultyCourseStudentOverview {
  @example(123456)
  id: integer;

  @example("Stefania")
  firstName: string;

  @example("Sassi")
  lastName: string;

  @example("s123456")
  username: string;

  @example("s123456@studenti.polito.it")
  email: string;

  picture?: {
    @example("https://example.com/picture.jpg")
    url: url;
  };
}

model FacultyCourseStudentsStats {
  @example(204)
  totalEnrolled: integer;

  @example(10)
  withAttendanceIssues: integer;

  @example(0)
  tookExam: integer;

  @example(42)
  withExamDebts: integer;

  @example(194)
  eligibleForExam: integer;

  @example(152)
  firstTimeInAcademicYear: integer;
}

model FacultyCourseExamResult {
  @example(plainDate.fromISO("2026-02-23"))
  date: plainDate;

  /** Grade obtained (e.g. "30L", "28", "passed"). */
  @example("30L")
  grade: string;
}

model FacultyCourseStudentDetail {
  ...FacultyCourseStudentOverview;
  course: {
    @example("02JSKPD")
    shortcode: string;

    @example(6)
    cfu: integer;
  };

  @example("CINZT3")
  degreeCode: string;

  @example("COMPUTER ENGINEERING")
  degreeName: string;

  examResult: FacultyCourseExamResult | null;

  /** Academic year of subscription. */
  @example("2025/2026")
  subscription: string;

  @example("Italian")
  citizenship: string;

  @example(true)
  hasSpecialNeeds: boolean;
}

model CompensativeMeasuresDocument {
  @example("Reporting procedure handbook")
  name: string;

  @example("https://didattica.polito.it/docs/handbook.pdf")
  url: url;
}

model CompensativeMeasures {
  /** HTML describing the compensatory measures granted to the student. */
  @example("<p>List of compensatory measures granted to Stefania Sassi</p><ul><li><b>Calculator</b> allowed</li></ul>")
  content: string;

  /** Link to the full list of requests for this course. */
  @example("https://didattica.polito.it/special-needs/requests")
  moreDetailsUrl: url;

  /** Reporting procedure handbook document. */
  handbook: CompensativeMeasuresDocument;
}

/** Visibility limits are independent; both null means no time restriction.
 * I limiti di visibilità sono indipendenti; entrambi null indicano nessuna restrizione temporale.
 */
model CourseNoticeRequest {
  @example("Contenuto dell'avviso")
  content: string;

  /** Start of visibility in UTC; null means no lower bound. | Inizio della visibilità in UTC; null indica nessun limite inferiore. */
  @example(utcDateTime.fromISO("2022-07-03T14:00:00Z"))
  visibleFrom: utcDateTime | null;

  /** End of visibility in UTC; null means no upper bound. | Fine della visibilità in UTC; null indica nessun limite superiore. */
  visibleUntil: utcDateTime | null;
}

model CreateCourseNoticeRequest extends CourseNoticeRequest {
  @example(false)
  isDraft: boolean;
}

// File and folder management requests

model CreateCourseFolderRequest {
  @example("Laboratori")
  name: string;

  /** Parent folder ID; null means the root. | ID della cartella padre; null indica la radice. */
  parentId: string | null;
}

model UpdateCourseFolderRequest {
  @example("Laboratori 2024")
  name?: string;

  /** Destination folder ID: omitted keeps the current parent, null moves to the root,
   * and a folder ID moves to that folder.
   * ID della cartella di destinazione: omesso mantiene la cartella padre attuale,
   * null sposta in radice, un ID sposta nella cartella indicata.
   */
  parentId?: string | null;
}

model CourseFileUpload {
  files: HttpPart<bytes>[];

  /** Destination folder. If omitted, files are uploaded to the root. */
  parentId?: HttpPart<string>;
}

model UpdateCourseFileRequest {
  @example("Lecture1.pdf")
  name?: string;

  /** Destination folder ID: omitted keeps the current parent, null moves to the root,
   * and a folder ID moves to that folder.
   * ID della cartella di destinazione: omesso mantiene la cartella padre attuale,
   * null sposta in radice, un ID sposta nella cartella indicata.
   */
  parentId?: string | null;
}

model MoveCourseItemsRequest {
  @example(#["2", "33352562"])
  itemIds: string[];

  destinationFolderId: string | null;
}

model EnrollStudentsRequest {
  @example(#[123456, 234567])
  studentIds: integer[];
}

enum MessageChannel {
  email: "email",
  notify: "notify",
}

model StudentsMessageRequest {
  @example(#[123456, 234567])
  studentIds: integer[];

  channel: MessageChannel;

  @example("Lezione di recupero")
  title?: string;

  @maxLength(4000)
  @example("Si avvisano gli studenti che...")
  message: string;
}

// Assignment management (faculty)

// TODO: verificare sul mockup la distinzione nuovo/letto e la possibilità di
// registrarla e aggiornarla sul server. Se non supportata, eliminare status
// e l'enum, mantenendo solo isRemovalRequested per la richiesta di rimozione.
enum FacultyAssignmentStatus {
  new: "new",
  seen: "seen",
}

model FacultyAssignmentAuthor {
  @example(348759)
  id: integer;

  @example("Giuliana")
  firstName: string;

  @example("Annone")
  lastName: string;
}

model FacultyCourseAssignmentOverview {
  @example(947503)
  id: integer;

  @example("PresentationGroup03.zip")
  filename: string;

  student: FacultyAssignmentAuthor;
  status: FacultyAssignmentStatus;

  /** Whether the student has requested removal of the assignment. | Indica se lo studente ha richiesto la rimozione dell'elaborato. */
  isRemovalRequested: boolean;
}

model FacultyCourseAssignmentDetail {
  ...CourseAssignment;
  student: FacultyAssignmentAuthor;
  status: FacultyAssignmentStatus;

  /** Whether the student has requested removal of the assignment. | Indica se lo studente ha richiesto la rimozione dell'elaborato. */
  isRemovalRequested: boolean;
}

model AssignmentAnswerRequest {
  @maxLength(4000)
  @example("Dear student, I cannot open the file you uploaded. Please try again to upload the folder in another format. Thank you!")
  message: string;
}

@tag("Courses")
@route("/faculty/courses/{courseId}/notices")
interface FacultyCourses {
  @post
  @summary("Create notice | Crea avviso")
  @opExample(_ex_createCourseNotice_req)
  createCourseNotice(
    @path courseId: integer,
    @body body: CreateCourseNoticeRequest,
  ): NoContentResponse | BaseErrors;

  @put
  @route("/{noticeId}")
  @summary("Update notice | Modifica avviso")
  @opExample(_ex_updateCourseNotice_resp)
  updateCourseNotice(
    @path courseId: integer,
    @path noticeId: integer,
    @body body: CourseNoticeRequest,
  ): NoContentResponse | BaseErrors;

  @delete
  @route("/{noticeId}")
  @summary("Delete notice | Elimina avviso")
  @opExample(_ex_deleteCourseNotice_resp)
  deleteCourseNotice(
    @path courseId: integer,
    @path noticeId: integer,
  ): NoContentResponse | BaseErrors;
}

@tag("Courses")
@route("/faculty/courses/{courseId}/students")
interface FacultyCourseStudents {
  @get
  @summary("List students | Elenca studenti iscritti al corso")
  @doc("Returns an overview of students enrolled in the course. | Restituisce la vista overview degli studenti iscritti al corso.")
  @opExample(_ex_listFacultyCourseStudents_resp)
  listFacultyCourseStudents(@path courseId: integer):
    | OkDataResponse<FacultyCourseStudentOverview[]>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @get
  @route("/stats")
  @summary("Students stats | Statistiche studenti")
  @opExample(_ex_getCourseStudentsStats_resp)
  getCourseStudentsStats(@path courseId: integer):
    | OkDataResponse<FacultyCourseStudentsStats>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @get
  @route("/search")
  @summary("Search enrollable students | Cerca studenti da iscrivere")
  @doc("Searches for students to enroll by first name, last name or student number. | Cerca studenti da iscrivere al corso per nome, cognome o matricola.")
  @opExample(_ex_searchEnrollableStudents_resp)
  searchEnrollableStudents(
    @path courseId: integer,

    /** Filter students by name, surname or student number. */
    @query search: string,
  ):
    | OkDataResponse<FacultyCourseStudentOverview[]>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @get
  @route("/{studentId}")
  @summary("Show student | Mostra studente")
  @doc("Returns all details of a student enrolled in the course. | Restituisce tutte le informazioni di un singolo studente iscritto al corso.")
  @opExample(_ex_getFacultyCourseStudent_resp)
  getFacultyCourseStudent(@path courseId: integer, @path studentId: integer):
    | OkDataResponse<FacultyCourseStudentDetail>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @get
  @route("/{studentId}/special-needs")
  @summary("Student compensative measures | Misure compensative studente")
  @opExample(_ex_getCourseStudentSpecialNeeds_resp)
  getCourseStudentSpecialNeeds(
    @path courseId: integer,
    @path studentId: integer,
  ):
    | OkDataResponse<CompensativeMeasures>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @post
  @summary("Add students | Aggiungi studenti al corso")
  @doc("Enrolls one or more students in the course. The operation is idempotent. | Iscrive uno o più studenti al corso. Operazione idempotente.")
  @opExample(_ex_enrollStudents_resp)
  enrollStudentsInCourse(
    @path courseId: integer,
    @body body: EnrollStudentsRequest,
  ): NoContentResponse | NotAuthorized | BadRequest | NotFound | BaseErrors;

  @post
  @route("/messages")
  @summary("Send message to students | Invia messaggio agli studenti")
  @doc("Sends a message to selected students by email or in-app notification. For the `notify` channel, students who have not installed the app receive an SMS. | Invia un messaggio agli studenti selezionati via email o notifica in-app. Per il canale `notify`, agli studenti che non hanno installato l'app viene inviato un SMS.")
  @opExample(_ex_sendStudentsMessage_resp)
  sendStudentsMessage(
    @path courseId: integer,
    @body body: StudentsMessageRequest,
  ): AcceptedResponse | NotAuthorized | BadRequest | NotFound | BaseErrors;
}

@tag("Courses")
@route("/faculty/courses/{courseId}/files")
interface FacultyCourseFiles {
  @post
  @route("/folders")
  @summary("Create folder | Crea cartella")
  @opExample(_ex_createCourseFolder_resp)
  createCourseFolder(
    @path courseId: integer,
    @body body: CreateCourseFolderRequest,
  ): NoContentResponse | NotAuthorized | NotFound | BaseErrors;

  @patch(#{ implicitOptionality: false })
  @route("/folders/{folderId}")
  @summary("Update folder | Modifica cartella")
  @opExample(_ex_updateCourseFolder_resp)
  updateCourseFolder(
    @path courseId: integer,
    @path folderId: string,
    @body body: UpdateCourseFolderRequest,
  ): NoContentResponse | NotAuthorized | NotFound | BaseErrors;

  @delete
  @route("/folders/{folderId}")
  @summary("Delete folder | Elimina cartella")
  @doc("Deletes the folder and all its contents recursively. | Elimina la cartella e ricorsivamente tutto il suo contenuto.")
  deleteCourseFolder(@path courseId: integer, @path folderId: string):
    | NoContentResponse
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @post
  @summary("Upload files | Carica file")
  @doc("Uploads one or more files to the course using a multipart/form-data request. | Carica uno o più file nel corso. La richiesta è multipart/form-data e accetta più file contemporaneamente.")
  uploadCourseFiles(
    @path courseId: integer,
    @header contentType: "multipart/form-data",
    @multipartBody body: CourseFileUpload,
  ): NoContentResponse | NotAuthorized | NotFound | BaseErrors;

  @post
  @route("/move")
  @summary("Move files | Sposta file")
  @doc("Moves one or more files or folders to a destination folder. | Sposta uno o più file e/o cartelle in una cartella di destinazione.")
  @opExample(_ex_moveCourseItems_resp)
  moveCourseItems(@path courseId: integer, @body body: MoveCourseItemsRequest):
    | NoContentResponse
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @patch(#{ implicitOptionality: false })
  @route("/{fileId}")
  @summary("Update file | Modifica file")
  @opExample(_ex_updateCourseFile_resp)
  updateCourseFile(
    @path courseId: integer,
    @path fileId: string,
    @body body: UpdateCourseFileRequest,
  ): NoContentResponse | NotAuthorized | NotFound | BaseErrors;

  @delete
  @route("/{fileId}")
  @summary("Delete file | Elimina file")
  deleteCourseFile(@path courseId: integer, @path fileId: string):
    | NoContentResponse
    | NotAuthorized
    | NotFound
    | BaseErrors;
}

@tag("Courses")
@route("/faculty/courses/{courseId}/assignments")
interface FacultyCourseAssignments {
  @get
  @summary("List assignments | Elenca elaborati")
  @doc("Returns the assignments submitted by students for the course. | Restituisce gli elaborati consegnati dagli studenti per il corso.")
  @opExample(_ex_listFacultyCourseAssignments_resp)
  listFacultyCourseAssignments(@path courseId: integer):
    | OkDataResponse<FacultyCourseAssignmentOverview[]>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @get
  @route("/{assignmentId}")
  @summary("Show assignment | Mostra elaborato")
  @opExample(_ex_getFacultyCourseAssignment_resp)
  getFacultyCourseAssignment(
    @path courseId: integer,
    @path assignmentId: integer,
  ):
    | OkDataResponse<FacultyCourseAssignmentDetail>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @delete
  @route("/{assignmentId}")
  @summary("Delete assignment | Elimina elaborato")
  deleteCourseAssignment(@path courseId: integer, @path assignmentId: integer):
    | NoContentResponse
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @post
  @route("/{assignmentId}/answer")
  @summary("Answer assignment | Rispondi all'elaborato")
  @doc("Sends a reply to the student about their assignment. | Invia una risposta allo studente riguardo al suo elaborato.")
  @opExample(_ex_answerCourseAssignment_resp)
  answerCourseAssignment(
    @path courseId: integer,
    @path assignmentId: integer,
    @body body: AssignmentAnswerRequest,
  ): AcceptedResponse | NotAuthorized | BadRequest | NotFound | BaseErrors;
}
