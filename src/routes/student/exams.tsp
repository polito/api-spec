import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/exams.tsp";

using Http;

namespace PolitoAPI;

model Exam {
  id: integer;
  courseId: numeric;
  courseShortcode: string;
  courseName: string;
  teacherId: integer;
  type: string;
  places?: PlaceRef[];
  status:
    | "available"
    | "booked"
    | "requestable"
    | "requested"
    | "requestAccepted"
    | "requestRejected"
    | "unavailable";
  bookingStartsAt: utcDateTime | null;
  bookingEndsAt: utcDateTime;
  examStartsAt: utcDateTime | null;
  examEndsAt: utcDateTime | null;
  bookedCount: integer;
  availableCount: integer;
  question: {
    id: integer;
    statement: string;
    options: string[];
  } | null;
  feedback: string | null;

  /** If true, the student can ask the professor to reschedule the exam */
  isReschedulable: boolean;

  notes: string | null;

  /** The module number, if this is a module */
  moduleNumber: integer;

  requestReason: string | null;
  requestDetails: string | null;
}

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
interface Exams {
  @get
  @summary("List exams | Elenca esami")
  @opExample(_ex_getExams_resp)
  getExams(): OkDataResponse<Exam[]> | BaseErrors;

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
