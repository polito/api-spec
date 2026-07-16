import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";

using Http;

namespace PolitoAPI;

union ExamStatus {
  available: "available",
  booked: "booked",
  requestable: "requestable",
  requested: "requested",
  requestAccepted: "requestAccepted",
  requestRejected: "requestRejected",
  unavailable: "unavailable",
}

model Exam {
  id: integer;
  courseId: numeric;
  courseShortcode: string;
  courseName: string;
  teacherId: integer;
  type: string;
  places?: PlaceRef[];
  bookingStartsAt: utcDateTime | null;
  bookingEndsAt: utcDateTime;
  examStartsAt: utcDateTime | null;
  examEndsAt: utcDateTime | null;
  bookedCount: integer;
  availableCount: integer;
  feedback: string | null;
  notes: string | null;

  /** The module number, if this is a module */
  moduleNumber: integer;

  /** Not returned for faculty calls */
  status?: ExamStatus;

  /** Not returned for faculty calls */
  question?: {
    id: integer;
    statement: string;
    options: string[];
  } | null;

  /**
   * If true, the student can ask the professor to reschedule the exam.
   * Not returned for faculty calls
   */
  isReschedulable?: boolean;

  /** Not returned for faculty calls */
  requestReason?: string | null;

  /** Not returned for faculty calls */
  requestDetails?: string | null;
}

/** Shared exam operations, extended by student and faculty interfaces */
interface Exams<TExam> {
  @get
  @summary("List exams | Elenca esami")
  getExams(): OkDataResponse<TExam[]> | BaseErrors;
}
