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
  /** The exam call (appello) identifier */
  id: integer;

  /** Corresponds to the internal "id_inc" value */
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

  /** Not returned for faculty calls */
  @example(CourseEnrollmentRole.student)
  enrollmentRole?: CourseEnrollmentRole;

  /** The teacher's ID number (matricola) */
  teacherId: integer;

  type: string;
  places?: PlaceRef[];
  bookingStartsAt: utcDateTime | null;
  bookingEndsAt: utcDateTime;
  examStartsAt: utcDateTime | null;
  examEndsAt: utcDateTime | null;

  /** Number of students booked for this exam call */
  bookedCount: integer;

  /** Corresponds to the internal "max_pren" value */
  availableCount: integer;

  /**
   * Message returned by the booking system about the exam status
   * (e.g. why a booking is not possible). Not returned for faculty calls
   */
  feedback?: string | null;

  /** Free-text notes attached to the exam call. Not returned for faculty calls */
  notes?: string | null;

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
