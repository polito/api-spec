import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../routes/common/exams.tsp";
import "../../examples/student/exams.tsp";

using Http;

namespace PolitoAPI;

model RescheduleExamRequest {
  @example("01UDROV")
  courseShortcode: string;

  requestReason: string;
  requestDetails: string;
}

model BookExamRequest {
  @example("01UDROV")
  courseShortcode: string;

  questionId?: integer;
  questionOption?: integer;
  requestReason?: string;
}

@tag("Exams")
@route("/exams")
interface StudentExams extends Exams<Exam> {
  @route("/{examId}/booking")
  @delete
  @summary("Delete exam booking | Annulla prenotazione esame")
  deleteExamBookingById(@path examId: integer): NoContentResponse | BaseErrors;

  @route("/{examId}/booking")
  @post
  @summary("Book exam | Prenota esame")
  bookExam(
    @path examId: integer,
    @body body: BookExamRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{examId}/rescheduleRequest")
  @post
  @summary("Ask to reschedule an exam | Chiedi di spostare un esame")
  rescheduleExam(
    @path examId: integer,
    @body body: RescheduleExamRequest,
  ): NoContentResponse | BaseErrors;
}

@@opExample(StudentExams.getExams, _ex_getExams_resp);
