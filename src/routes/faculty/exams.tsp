import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../routes/common/exams.tsp";
import "../../examples/faculty/exams.tsp";

using Http;

namespace PolitoAPI;

model Student {
  @example("290683")
  studentId: string;

  @example("Mario")
  name: string;

  @example("Rossi")
  surname: string;

  /** Whether the student is entitled to extra time (DSA/BES) */
  @example(true)
  needsExtraTime: boolean;

  /** Whether the student is marked as present at the exam */
  @example(false)
  isPresent: boolean;

  /** Whether the student is about to graduate */
  @example(false)
  isGraduating: boolean;

  /** Additional notes about the student for this exam */
  @example(#["Necessita di supporto per la lettura"])
  notes: string[];
}

model ExamStudentsSummary {
  /** Students with attendance debt (debito di frequenza) */
  @example(10)
  attendanceDebtCount: integer;

  /** Students attending the course for the first time */
  @example(70)
  firstAttendanceCount: integer;

  /** Students entitled to extra time (DSA/BES) */
  @example(19)
  extraTimeCount: integer;

  /** Students about to graduate */
  @example(2)
  graduatingCount: integer;
}

model ExamStudents {
  summary: ExamStudentsSummary;
  students: Student[];
}

model CheckAttendanceRequest {
  /** Student IDs of the students marked as present */
  @example(#["290683", "291045"])
  studentIds: string[];
}

union NotificationChannel {
  email: "email",
  notification: "notification",
}

model ExamNotificationRequest {
  /** Subject of the message. Null when sending a notification only */
  @example("Importante: modifica orario esame")
  subject: string | null;

  /** Body of the message */
  @example("Si comunica che l'orario dell'esame è stato spostato alle ore 14:00.")
  message: string;

  /** Delivery channels for the message */
  @example(#[NotificationChannel.email, NotificationChannel.notification])
  channels: NotificationChannel[];

  /**
   * Student ID numbers (matricole) of the recipients.
   * If omitted, the message is sent to all students booked for the exam
   */
  @example(#[290683, 291045])
  recipientPersonIds?: integer[];
}

model EnrollmentCheckResult {
  /** Whether the student can be enrolled to the exam */
  @example(true)
  checkPassed: boolean;

  /** Outcome message of the enrollment check */
  @example("Lo studente può essere iscritto all'appello")
  message: string;
}

model AcceptedData {
  @example("accepted")
  status: string;

  @example("track-abc-123")
  trackingId: string;
}

@tag("Faculty - Exams")
@route("/exams")
interface FacultyExams extends Exams<Exam> {
  @route("/{examId}/students")
  @get
  @summary("List students in exam | Elenca studenti nell'esame")
  @doc("Restituisce la lista degli studenti iscritti a un appello specifico, preceduta da un riepilogo con i contatori.")
  @opExample(_ex_listStudentsInExam_resp)
  listStudentsInExam(@path examId: integer):
    | OkDataResponse<ExamStudents>
    | NotAuthorized
    | NotFound
    | ServerError;

  @route("/{examId}/attendance")
  @post
  @summary("Check exam attendance | Verifica presenze all'esame")
  @doc("Registra le presenze passando l'array delle matricole presenti. Restituisce lo stato aggiornato delle presenze.")
  @opExample(_ex_checkAttendance_resp)
  checkAttendance(@path examId: integer, @body body: CheckAttendanceRequest):
    | OkDataResponse<Student[]>
    | NotAuthorized
    | NotFound
    | ServerError;

  @route("/{examId}/notify")
  @post
  @summary("Notify exam subscribers | Invia comunicazione agli iscritti all'esame")
  @doc("Invia un messaggio/avviso agli studenti iscritti a un appello specifico, permettendo l'invio sia all'intera lista sia a un sottoinsieme selezionato.")
  @opExample(_ex_notifyExamSubscribers_resp)
  notifyExamSubscribers(
    @path examId: integer,
    @body body: ExamNotificationRequest,
  ): AcceptedResponse<{
    data: AcceptedData;
  }> | NotAuthorized | BaseErrors;

  @route("/{examId}/students/{studentId}")
  @get
  @summary("Check if student registration for the exam is possible | Verifica se possibile l'iscrizione studente all'esame")
  @opExample(_ex_checkStudentEnrollment_resp)
  checkStudentEnrollment(@path examId: integer, @path studentId: integer):
    | OkDataResponse<EnrollmentCheckResult>
    | NotAuthorized
    | NotFound
    | ServerError;

  @route("/{examId}/students/{studentId}")
  @post
  @summary("Enroll student to exam | Iscrivi studente all'esame")
  @doc("Iscrive uno studente a un appello specifico. Operazione")
  @opExample(_ex_enrollStudentToExam_resp)
  enrollStudentToExam(@path examId: integer, @path studentId: integer):
    | NoContentResponse
    | NotAuthorized
    | NotFound
    | ServerError;
}

@@opExample(FacultyExams.getExams, _ex_getExams_resp);
