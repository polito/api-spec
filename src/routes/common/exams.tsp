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

  /**
   * Instance number assigned to this course.
   * Corresponds to the internal "num_cor" value.
   */
  @example(0)
  courseInstanceId?: integer | null;

  /**
   * Alphabetical surname range assigned to this course instance.
   * Format: "<letters>-<letters>".
   */
  @example("AAA-ZZZ")
  surnameRange?: string | null;

  @example(CourseEnrollmentRole.student)
  enrollmentRole?: CourseEnrollmentRole;

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

  /**
   * Permanent module identifier within the parent course.
   * Stable across academic years and associated with the course shortcode.
   */
  @example(1)
  modulePermanentId?: integer;

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
