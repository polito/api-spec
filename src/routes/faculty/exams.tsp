import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../routes/common/exams.tsp";
import "../../examples/faculty/exams.tsp";

using Http;

namespace PolitoAPI;

model ExamEnrollment {
  @example("290683")
  username: string;

  @example("Mario")
  name: string;

  @example("Rossi")
  surname: string;
}

model ExamAttendee extends ExamEnrollment {
  /** Se lo studente ha diritto a tempo aggiuntivo (DSA/BES) */
  @example(true)
  needsExtraTime: boolean;

  /** Minuti aggiuntivi concessi, null se non applicabile */
  @example(30)
  extraTimeMinutes: integer | null;

  /** Se lo studente risulta presente all'esame */
  @example(false)
  isPresent: boolean;
}

model CheckAttendanceRequest {
  /** Matricole degli studenti risultati presenti */
  @example(#["290683", "291045"])
  presentUsernames: string[];
}

model ExamNotificationRequest {
  @example("Importante: modifica orario esame")
  subject: string;

  @example("Si comunica che l'orario dell'esame è stato spostato alle ore 14:00.")
  message: string;

  @example(#["email", "sms"])
  channels: string[];

  @example(#["290683", "291045"])
  recipientPersonIds?: string[];
}

model AcceptedData {
  @example("accepted")
  status: string;

  @example("track-abc-123")
  trackingId: string;
}

@tag("Faculty - Exams")
@route("/exams")
interface FacultyExams {
  @get
  @summary("List exams | Elenca esami")
  @opExample(_ex_getExams_resp)
  getExams(): OkDataResponse<ExamBase[]> | BaseErrors;

  @route("/{examId}/students")
  @get
  @summary("List students in exam | Elenca studenti nell'esame")
  @doc("Restituisce la lista degli studenti iscritti a un appello specifico.")
  @opExample(_ex_listStudentsInExam_resp)
  listStudentsInExam(@path examId: integer):
    | OkDataResponse<ExamAttendee[]>
    | NotAuthorized
    | NotFound
    | ServerError;

  @route("/{examId}/attendance")
  @post
  @summary("Check exam attendance | Verifica presenze all'esame")
  @doc("Registra le presenze passando l'array delle matricole presenti. Restituisce lo stato aggiornato delle presenze.")
  @opExample(_ex_checkAttendance_resp)
  checkAttendance(
    @path examId: integer,
    @body body: CheckAttendanceRequest,
  ):
    | OkDataResponse<ExamAttendee[]>
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
  @put
  @summary("Add student to exam | Aggiungi studente all'esame")
  @doc("Inserisce manualmente uno studente tra gli iscritti a un appello (casi eccezionali). Operazione idempotente.")
  @opExample(_ex_addStudentToExam_resp)
  addStudentToExam(@path examId: integer, @path studentId: integer):
    | OkDataResponse<ExamEnrollment>
    | OkDataCreatedResponse<ExamEnrollment>
    | NotAuthorized
    | NotFound
    | ServerError;

  @route("/{examId}/students/{studentId}")
  @get
  @summary("Check if student registration for the exam is possible | Verifica se possibile l'iscrizione studente all'esame")
  @opExample(_ex_enrollStudentToExam_resp)
  checkStudentEnrollment(@path examId: integer, @path studentId: integer):
    | NoContentResponse
    | ErrorResponse
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
