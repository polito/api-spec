import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/faculty/exams.tsp";

using Http;

namespace PolitoAPI;

model ExamEnrollment {
  @example("290683")
  personId: string;

  @example("Mario Rossi")
  name: string;

  @example("Ingegneria Informatica")
  degree: string | null;

  @example("mario.rossi@studenti.polito.it")
  email: string | null;
}

model FacultyExam {
  @example(888122)
  id: integer;

  @example(262147)
  courseId: integer;

  @example("02JSKOV")
  courseShortcode: string;

  @example("Human Computer Interaction")
  courseName: string;

  @example(2154)
  teacherId: integer;

  @example("Esami scritti a risposta aperta o chiusa tramite PC")
  type: string;

  places: PlaceRef[];

  @example("available")
  status: string;

  @example(utcDateTime.fromISO("2026-03-04T11:07:28.541Z"))
  bookingStartsAt: utcDateTime;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  bookingEndsAt: utcDateTime;

  @example(utcDateTime.fromISO("2022-09-02T14:00:00Z"))
  examStartsAt: utcDateTime;

  @example(utcDateTime.fromISO("2022-09-02T17:00:00Z"))
  examEndsAt: utcDateTime;

  @example(42)
  bookedCount: integer;

  @example(8)
  availableCount: integer;

  question: string | null;
  feedback: string | null;

  @example(false)
  isReschedulable: boolean;

  notes: string | null;

  @example(1)
  moduleNumber: integer;

  requestReason: string | null;
  requestDetails: string | null;

  enrolled: ExamEnrollment[];
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
@route("/faculty/exams")
interface FacultyExams {
  @get
  @summary("List faculty exams | Elenco appelli del docente")
  @doc("Elenca gli appelli d'esame del docente con filtri opzionali.")
  @opExample(_ex_listFacultyExams_resp)
  listFacultyExams(
    @query courseId?: string,
    @query dateFrom?: plainDate,
    @query dateTo?: plainDate,
    @query page?: integer = 1,
    @query pageSize?: integer = 20,
  ): OkDataResponse<FacultyExam[]> | NotAuthorized | ServerError;

  @route("/{examId}")
  @get
  @summary("Get faculty exam details | Dettaglio appello con iscritti")
  @doc("Restituisce i dettagli dell'appello, inclusa la lista degli studenti iscritti.")
  @opExample(_ex_getFacultyExam_resp)
  getFacultyExam(@path examId: integer):
    | OkDataResponse<FacultyExam>
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
  ): AcceptedResponse<{ data: AcceptedData }> | NotAuthorized | BaseErrors;

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
}
