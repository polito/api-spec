import "@typespec/http";
import "@typespec/openapi3";

import "../common.tsp";
import "../examples/student.tsp";

using Http;

namespace PolitoAPI;

model Deadline {
  id?: numeric;

  @example("Termine per l'iscrizione e pagamento della prima rata")
  name: string;

  @example("Iscrizioni e pagamento tasse")
  type: string;

  url: string | null;

  @example(plainDate.fromISO("2022-10-11"))
  date: plainDate;
}

model ProvisionalGrade {
  @example(654632)
  id: numeric;

  @example(887981)
  examId: numeric;

  @example("01NYHOV")
  courseShortcode: string;

  @example("System and device programming")
  courseName: string;

  @example(2893)
  teacherId: integer;

  @example(10)
  credits: numeric;

  @example("30")
  grade: string;

  @example(plainDate.fromISO("2022-07-15"))
  date: plainDate;

  @example("published")
  state: "published" | "confirmed" | "rejected";

  @example("Pubblicata")
  stateDescription: string;

  teacherMessage: string | null;

  @example(false)
  isWithdrawn: boolean;

  @example(false)
  isFailure: boolean;

  @example(true)
  canBeAccepted: boolean;

  @example(true)
  canBeRejected: boolean;

  confirmedAt: plainDate | null;
  rejectedAt: utcDateTime | null;

  @example(utcDateTime.fromISO("2022-07-31T23:59:59Z"))
  rejectingExpiresAt: utcDateTime;
}

model ProvisionalGradeState {
  @example("published")
  id: string;

  @example("Pubblicata")
  name: string;

  @example("La valutazione è stata pubblicata dal docente")
  description: string;
}

model ExamGrade {
  @example("System and device programming")
  courseName: string;

  @example(10)
  credits: numeric;

  @example("30L")
  grade: string;

  @example(plainDate.fromISO("2022-07-15"))
  date: plainDate;

  @example(2893)
  teacherId: integer | null;

  /** Points for "on-time" exams - null the student is not eligible for on-time exams or the exam does not grant on-time points */
  @example(2)
  onTimeExamPoints: numeric | null;

  @example("01NYHOV")
  shortcode: string;

  @example(2021)
  academicYear: integer;

  /** Defines whether the credits from the exam count toward the total required for graduation */
  @example(true)
  creditsCountTowardsDegree: boolean;
}

model EmailBadge {
  @example("99+")
  unreadEmails: string;
}

@example(MessageType.secretariat)
enum MessageType {
  emergency,
  event,
  personal,
  teacher,
  secretariat,
  exams,
  mfa,
}

model Message {
  @example(123)
  id: numeric;

  @example("Nuovo avviso da System and device programming")
  title: string;

  @example("Ricordati di...")
  message: string | null;

  @example(MessageType.teacher)
  type: MessageType;

  @example(2893)
  senderId: numeric | null;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  sentAt: utcDateTime;

  @example(false)
  isRead: boolean;
}

model Notification {
  @example(123)
  id: numeric;

  @example("Nuovo avviso da System and device programming")
  title: string;

  @example("Ricordati di...")
  message: string | null;

  /** An array representing the hierarchical path to the object this notification is related to (replicates the navigation/modules structure) */
  @example(#["courses", "258674", "notices"])
  scope?: string[];

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  sentAt: utcDateTime;

  @example(false)
  isRead: boolean;
}

model NotificationPreferences {
  @example(true)
  notices: boolean;

  @example(true)
  files: boolean;

  @example(true)
  lectures: boolean;

  @example(true)
  bookings: boolean;

  @example(true)
  tickets: boolean;
}

model UpdateNotificationPreferencesRequest {
  data: {
    @example(true)
    notices?: boolean;

    @example(true)
    files?: boolean;

    @example(true)
    lectures?: boolean;

    @example(true)
    bookings?: boolean;

    @example(true)
    tickets?: boolean;
  };
}

model GuideField {
  label: string;
  value: string;
  isCopyEnabled?: boolean;
}

model Guide {
  id: string;
  listTitle: string;
  title: string;
  intro: string;
  fields: GuideField[];
  sections: GuideSection[];
}

model EmergencyHour {
  @example("Monday")
  day: string;

  @example("09:00")
  open: string;

  @example("18:00")
  close: string;
}

model EmergencySite {
  places: PlaceRef[];

  @example("+39 011 090 1234")
  phoneNumber: string;

  hours: EmergencyHour[];

  @example(true)
  backup: boolean;
}

model EmergencyCta {
  @example("Emergenza 112")
  text: string;

  action: EmergencySite;

  @example("fa-phone")
  icon?: string;

  @example("#E11D48")
  color: string;

  @example(true)
  primary: boolean;
}

model EmergencyContent {
  @example("Emergency Title")
  title?: string;

  @example("Important information regarding the emergency.")
  content: string;

  cta: EmergencyCta;
}

model EmergencyResponse {
  @example("fa-warning")
  icon: string;

  @example("Emergency Name")
  name: string;

  content: EmergencyContent[];
  cta: EmergencyCta[];
}

model Student {
  @example("s290683")
  username: string;

  @example("Luca")
  firstName: string;

  @example("Pezzolla")
  lastName: string;

  @example("active")
  status: "active" | "closed" | "cancelled" | "graduated" | "career_closed";

  /** All the ids related to this student */
  @example(#["290683", "213956"])
  allCareerIds: string[];

  @example("81-6")
  degreeId: string;

  @example("LM-32")
  degreeCode: string;

  @example("Corso di Laurea Magistrale in")
  degreeLevel: string;

  @example("INGEGNERIA INFORMATICA (COMPUTER ENGINEERING)")
  degreeName: string;

  @example(2021)
  firstEnrollmentYear: integer;

  @example(2022)
  lastEnrollmentYear: integer;

  @example(false)
  isCurrentlyEnrolled: boolean;

  @example(27.5)
  averageGrade: numeric | null;

  @example(105)
  estimatedFinalGrade: numeric | null;

  /** Purged grade is only available for bachelor degree students */
  averageGradePurged: numeric | null;

  /** Purged grade is only available for bachelor degree students */
  estimatedFinalGradePurged: numeric | null;

  /** Specify whether to use purgedAverageFinalGrade or averageFinalGrade as the graduation grade shown */
  usePurgedAverageFinalGrade: boolean;

  /** Master's admission grade is only available for bachelor degree students */
  mastersAdmissionAverageGrade: numeric | null;

  /** Total points for "on-time" exams - null if "on-time" exams are not applicable for the student's position (max value = maxOnTimeExamPoints) */
  totalOnTimeExamPoints: numeric | null;

  /** Maximum points for "on-time" exams */
  maxOnTimeExamPoints: numeric;

  /** Credits excluded from calculating the purged grade */
  excludedCreditsNumber: numeric | null;

  totalCredits: integer;
  totalAttendedCredits: integer;
  totalAcquiredCredits: integer;
  enrollmentCredits: integer;
  enrollmentAttendedCredits: integer;
  enrollmentAcquiredCredits: integer;
  smartCardPicture: string | null;
  europeanStudentCard: EuropeanStudentCard;
}

@tag("Student")
interface StudentNs {
  @route("/me")
  @get
  @summary("Retrieve student profile | Recupera il profilo studente")
  getStudent(): OkDataResponse<Student> | BaseErrors;

  @route("/deadlines")
  @get
  @summary("List deadlines | Elenca scadenze")
  @opExample(_ex_getDeadlines_resp)
  getDeadlines(
    /** First day - defaults to 7 days before today */
    @query fromDate?: plainDate,

    /** Last day - defaults to 7 days after today */
    @query toDate?: plainDate,
  ): OkDataResponse<Deadline[]> | BaseErrors;

  @route("/grades")
  @get
  @summary("Retrieve student grades | Recupera i voti dello studente")
  getStudentGrades(): OkDataResponse<ExamGrade[]> | BaseErrors;

  @route("/unreadEmails")
  @get
  @summary("Retrieve student's unread emails number | Recupera il numero di email non lette dello studente")
  getUnreadEmailsNumber(): OkDataResponse<EmailBadge> | BaseErrors;

  @route("/preferences")
  @patch(#{ implicitOptionality: true })
  @summary("Update device preferences | Aggiorna preferenze del dispositivo")
  updateDevicePreferences(
    @body body: UpdatePreferencesRequest,
  ): NoContentResponse | BaseErrors;

  @route("/guides")
  @get
  @summary("Get guides | Mostra guide")
  getGuides(): OkDataResponse<Guide[]> | BaseErrors;

  @route("/emergencecies")
  @get
  @summary("Show emergencecies text and number | Mostra testi e numeri di emergenza")
  getEmergencies(): EmergencyResponse | BaseErrors;
}

@tag("Student")
@route("/messages")
interface Messages {
  @get
  @summary("List messages | Elenca messaggi")
  getMessages(): OkDataResponse<Message[]> | BaseErrors;

  @route("/{messageId}")
  @delete
  @summary("Delete a message | Cancella un messaggio")
  deleteMessage(@path messageId: integer): NoContentResponse | BaseErrors;

  @route("/{messageId}/read")
  @put
  @summary("Mark a message as read | Segna un messaggio come letto")
  markMessageAsRead(@path messageId: integer): NoContentResponse | BaseErrors;
}

@tag("Student")
@route("/notifications")
interface Notifications {
  @get
  @summary("List notifications | Elenca notifiche")
  getNotifications(): OkDataResponse<Notification[]> | BaseErrors;

  @route("/preferences")
  @get
  @summary("Get notification preferences | Ottieni preferenze notifiche")
  getNotificationPreferences(
  ): OkDataResponse<NotificationPreferences> | BaseErrors;

  @route("/preferences")
  @patch(#{ implicitOptionality: true })
  @summary("Update notification preferences | Aggiorna preferenze notifiche")
  updateNotificationPreferences(
    @body body: UpdateNotificationPreferencesRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{notificationId}")
  @delete
  @summary("Delete a notification | Cancella una notifica")
  deleteNotification(
    @path notificationId: integer,
  ): NoContentResponse | BaseErrors;

  @route("/{notificationId}/read")
  @put
  @summary("Mark a notification as read | Segna una notifica come letta")
  markNotificationAsRead(
    @path notificationId: integer,
  ): NoContentResponse | BaseErrors;
}

@tag("Student")
@route("/provisional-grades")
interface ProvisionalGrades {
  @get
  @summary("Retrieve student provisional grades | Recupera le valutazioni provvisorie dello studente")
  getStudentProvisionalGrades(): OkResponse<{
    data: ProvisionalGrade[];
    states: ProvisionalGradeState[];
  }> | BaseErrors;

  @route("/{provisionalGradeId}/accept")
  @post
  @summary("Accept provisional grade | Accetta valutazione provvisoria")
  acceptProvisionalGrade(
    @path provisionalGradeId: integer,
  ): NoContentResponse | BaseErrors;

  @route("/{provisionalGradeId}/reject")
  @post
  @summary("Reject provisional grade | Rifiuta valutazione provvisoria")
  rejectProvisionalGrade(
    @path provisionalGradeId: integer,
  ): NoContentResponse | BaseErrors;
}
