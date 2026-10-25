import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../common.tsp";
import "../common/courses.tsp";
import "../../examples/student/courses.tsp";

using Http;
using OpenAPI;

namespace PolitoAPI;

model CourseAssignmentUpload {
  description: HttpPart<string>;
  file: HttpPart<bytes>;
}

model UpdateAssignmentRequest {
  /** Set to a date to withdraw the assignment, null to restore it. | Impostare una data per ritirare l'elaborato, null per ripristinarlo. */
  @example(utcDateTime.fromISO("2022-09-03T10:00:00Z"))
  deletedAt: utcDateTime | null;
}

@tag("Courses")
@route("/courses")
interface StudentCourseAssignments {
  @route("/{courseId}/assignments")
  @get
  @summary("List assignments | Elenca elaborati")
  @opExample(_ex_getCourseAssignments_resp)
  @operationId("Courses_getCourseAssignments")
  getCourseAssignments(
    @path courseId: integer,
  ): OkDataResponse<CourseAssignment[]> | BaseErrors;

  @route("/{courseId}/assignments")
  @post
  @summary("Upload assignment | Carica elaborato")
  @operationId("Courses_uploadCourseAssignment")
  uploadCourseAssignment(
    @path courseId: integer,
    @header contentType: "multipart/form-data",
    @multipartBody body: CourseAssignmentUpload,
  ): NoContentResponse | BaseErrors;

  @route("/{courseId}/assignments/{assignmentId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update assignment | Aggiorna elaborato")
  @doc("Withdraws the assignment when deletedAt is set to a date; restores it when null. | Ritira l’elaborato se deletedAt è una data; lo ripristina se null.")
  @operationId("Courses_updateAssignment")
  updateAssignment(
    @path courseId: integer,
    @path assignmentId: integer,
    @body body: UpdateAssignmentRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{courseId}/assignments/{assignmentId}/removal-request")
  @post
  @summary("Request assignment removal | Richiedi rimozione elaborato")
  @doc("The student asks the teacher to remove their assignment. | Lo studente richiede al docente la rimozione del proprio elaborato.")
  @operationId("Courses_requestAssignmentRemoval")
  requestAssignmentRemoval(
    @path courseId: integer,
    @path assignmentId: integer,
  ): NoContentResponse | BaseErrors;
}
