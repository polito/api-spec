import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
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

model Collaborator {
  @example("p002")
  personId: string;

  @example("Luigi Verdi")
  name: string;

  @example("Tutor")
  role: string;

  sections?: string[];
  permissions: CollaboratorPermission[];
}

enum CollaboratorPermission {
  CAN_READ,
  CAN_EDIT,
  CAN_DELETE,
}

model CollaboratorUpsertRequest {
  @example("Tutor")
  role?: string;

  sections: string[];
  permissions: CollaboratorPermission[];
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

// Response aliases with descriptions

@doc("Studente già iscritto")
model StudentAlreadyEnrolledResponse {
  ...OkDataResponse<FacultyCourseStudent>;
}

@doc("Updated collaborator")
model CollaboratorUpdatedResponse {
  ...OkDataResponse<Collaborator>;
}

@doc("Created collaborator")
model CollaboratorCreatedResponse {
  ...OkDataCreatedResponse<Collaborator>;
}

@doc("Removed collaborator")
model CollaboratorRemovedResponse {
  ...NoContentResponse;
}

@doc("Accepted (sending)")
model CourseMessageAcceptedResponse {
  ...AcceptedResponse;
}

@tag("Faculty - Courses")
@route("/faculty/courses/{courseId}")
interface FacultyCourses {
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

  @get
  @route("/collaborators")
  @summary("Elenca collaboratori assegnati al corso")
  listAssignmentCollaborators(@path courseId: integer):
    | OkDataResponse<Collaborator[]>
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @put
  @route("/collaborators/{collaboratorId}")
  @summary("Aggiungi o aggiorna collaboratore")
  @doc("Operazione idempotente per creare o aggiornare un collaboratore sul corso. Se il collaboratore esiste già, i suoi attributi vengono aggiornati.")
  upsertAssignmentCollaborator(
    @path courseId: integer,
    @path collaboratorId: string,
    @body body: CollaboratorUpsertRequest,
  ):
    | CollaboratorUpdatedResponse
    | CollaboratorCreatedResponse
    | BadRequest
    | NotAuthorized
    | NotFound
    | BaseErrors;

  @delete
  @route("/collaborators/{collaboratorId}")
  @summary("Rimuovi collaboratore da un incarico")
  removeAssignmentCollaborator(
    @path courseId: integer,
    @path collaboratorId: string,
  ): CollaboratorRemovedResponse | NotAuthorized | NotFound | BaseErrors;

  @post
  @route("/message")
  @summary("Invia comunicazione agli iscritti al corso")
  messageCourseSubscribers(
    @path courseId: integer,
    @body body: CourseMessageRequest,
  ): CourseMessageAcceptedResponse | NotAuthorized | BadRequest | BaseErrors;
}
