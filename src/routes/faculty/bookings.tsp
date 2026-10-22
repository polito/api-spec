import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/faculty/bookings.tsp";

namespace PolitoAPI;

using Http;

model DepartmentalSpaceRef {
  // TODO: confermare il valore stabile dell'ID (Nome nell'elenco, NomeSpazio nel calendario)
  // e la mappatura distinta di name e description: il calendario espone DescSpazio.
  /** Space identifier; corresponds to NomeSpazio in calendar and booking requests. */
  @example("sala riunioni ISAD")
  id: string;

  @example("Sala riunioni ISAD")
  name: string;

  @example("Saletta ISIAD")
  description: string;
}

model DepartmentalSpace extends DepartmentalSpaceRef {
  @example(120)
  numSeats: integer;

  @example(#{ id: "S", label: "Sale Riunioni" })
  type: IdLabel;

  @example("L")
  size: string;

  /** Place identifier used by /v2/places/{placeId}.
   * Format: buildingId_floorId_roomId (Fabbricato_Piano_Locale).
   */
  @example("TO_CIT11_XP01_03XC")
  placeId: string;

  /** User permission level | Livello di abilitazione dell'utente:
   * - 1: view the calendar | visualizzazione del calendario
   * - 2: manage events for which the user is the requester | scrittura individuale
   * - 3: manage all events | gestione
   * Modification and deletion always require isCreatedByDepartment = true,
   * including for permission level 3.
   */
  @example(1)
  permissionLevel: 1 | 2 | 3;
}

/** Departmental spaces grouped under a named site. */
model DepartmentalSpaceSite {
  @example("Sede Centrale")
  name: string;

  spaces: DepartmentalSpace[];
}

/** Sites grouped under a named city. */
model DepartmentalSpaceCity {
  @example("Torino")
  name: string;

  sites: DepartmentalSpaceSite[];
}

model DepartmentalSpaceEventBase {
  /** Calendar event identifier; corresponds to IdEventoCalendario. */
  @example(9183864)
  id: integer;

  /** Whether the event was created through the departmental spaces application
   * (FlagInsertedFromDip). If false, the event cannot be modified or deleted,
   * even with permission level 3. If true, the user's permission level still applies.
   */
  @example(true)
  isCreatedByDepartment: boolean;

  /** Whether the event is publicly visible. | Indica se l'evento è visibile pubblicamente. */
  // DIFFERENZA: richiedere isPubliclyVisible nella risposta del calendario.
  @example(false)
  isPubliclyVisible: boolean;

  /** Bookable space; NomeSpazio maps to space.id and DescSpazio to space.description. */
  space: DepartmentalSpaceRef;

  /** Place identifier used by /v2/places/{placeId}.
   * Format: buildingId_floorId_roomId (Fabbricato_Piano_Locale).
   */
  @example("TO_CIT11_XP01_03XC")
  placeId: string;

  /** Number of occupied seats; corresponds to NumPostiOccupati. */
  @example(10)
  seatsOccupied: integer;

  /** Event type identifier and display name (DescTipologiaEvento). */
  // TODO: the supplied calendar payload only includes the type description.
  // Request that the webservice supplies its identifier alongside the label.
  // Example ID 1 is fictitious; the actual code for Riunione is not yet known.
  @example(#{ id: 1, label: "Riunione" })
  type: IdLabel<integer>;

  @example("Prepararsi in anticipo secondo documentazione inviata")
  note: string;

  /** Identifier of the recurrence series. Always present; null for non-recurring events.
   */
  @example(456)
  recurrenceId: integer | null;

  // DIFFERENZA: richiedere datetime UTC al webservice, con conversione da Europe/Rome.
  /** Event start in UTC. | Inizio dell'evento in UTC. */
  @example(utcDateTime.fromISO("2026-02-15T10:00:00Z"))
  startsAt: utcDateTime;

  /** Event end in UTC. | Fine dell'evento in UTC. */
  @example(utcDateTime.fromISO("2026-02-15T12:00:00Z"))
  endsAt: utcDateTime;
}

/** Teaching event details (FlagDidattico = true). */
model DepartmentalSpaceTeachingEventDetails {
  /** Academic year; corresponds to AnnoAccademico, as year in courses. */
  @example("2026")
  year: string;

  /** Teaching period; corresponds to Pd. */
  @example("1-1")
  teachingPeriod: string;

  /** Module title; corresponds to TitoloModulo. */
  @example("Programming Module A")
  moduleName: string;

  /** Alphabetical surname range; corresponds to Alfabetica. */
  @example("AAA-ZZZ")
  surnameRange: string;

  /** Corresponds to TitoloMateria. */
  @example("System and device programming")
  courseName: string;

  /** Course holder's ID; corresponds to MatricolaTitolare. */
  @example(2893)
  teacherId: integer;

  /** Course holder's name; corresponds to NominativoTitolare. */
  @example("Mario Rossi")
  teacherName: string;

  /** Classroom teacher's ID; corresponds to MatricolaDocenteAula. */
  classroomTeacherId: integer;

  /** Classroom teacher's name; corresponds to NominativoDocenteAula. */
  classroomTeacherName: string;

  // TODO: IdImt is NOT id_inc/courseId. Confirm its meaning, final name,
  // type and whether it should remain exposed. The supplied payload shows a string.
  idImt: string;

  /** Corresponds to CodIns. */
  @example("01NYHOV")
  courseShortcode: string;

  /** Course instance identifier; corresponds to NumCor. */
  @example(0)
  courseInstanceId: integer;
}

/** Department event details (FlagDidattico = false). */
model DepartmentalSpaceDepartmentEventDetails {
  /** Department event description; corresponds to DescEvento. | Descrizione dell'evento dipartimentale. */
  @example("Riunione di dipartimento")
  description: string;

  /** Person for whom the booking is made; also used for permission level 2 checks. */
  requestedBy: {
    /** Requester's ID (matricola), without the user-type prefix. */
    id: string;

    /** Corresponds to NominativoRichiedente. */
    @example("Mario Rossi")
    name: string;
  };

  /** Person who entered the booking; corresponds to MatricolaInsert. */
  bookedBy: {
    /** Booking author's ID (matricola), without the user-type prefix. */
    id: string;
  };
}

model DepartmentalSpaceTeachingEvent extends DepartmentalSpaceEventBase {
  /** Corresponds to FlagDidattico = true. */
  isTeachingEvent: true;

  details: DepartmentalSpaceTeachingEventDetails;
}

model DepartmentalSpaceDepartmentEvent extends DepartmentalSpaceEventBase {
  /** Corresponds to FlagDidattico = false. */
  isTeachingEvent: false;

  details: DepartmentalSpaceDepartmentEventDetails;
}

@OpenAPI.oneOf
union DepartmentalSpaceEvent {
  teaching: DepartmentalSpaceTeachingEvent,
  department: DepartmentalSpaceDepartmentEvent,
}

enum DayOfWeek {
  sunday: 0,
  monday: 1,
  tuesday: 2,
  wednesday: 3,
  thursday: 4,
  friday: 5,
  saturday: 6,
}

/** Fields that can be updated on both a single event and a recurrence. */
// TODO: verificare il supporto all'omissione dei campi facoltativi non valorizzati
// nei payload, senza inviare null o stringhe vuote (es. requestedById).
// Verificare insieme l'elenco completo dei campi facoltativi e la loro obbligatorietà
// per ciascuna operazione, inclusa la semantica dell'omissione negli aggiornamenti.
model UpdateSpaceRecurrenceRequest {
  // TODO: chiarire il richiedente effettivo quando requestedById è omesso,
  // anche ai fini dei controlli con permissionLevel = 2.
  /** ID (matricola), without the user-type prefix, of the person for whom the space is requested;
   * corresponds to MatRichiedente. Optional; this may differ from the authenticated caller.
   */
  @example("028889")
  requestedById?: string;

  /** Identifier returned by /event-types; corresponds to IdTipologiaEvento. */
  // Example ID 1 is fictitious; the actual code for Riunione is not yet known.
  @example(1)
  typeId: integer;

  @example("Riunione di dipartimento")
  eventDescription: string;

  @example("Prepararsi in anticipo secondo documentazione inviata")
  notes: string;

  @example(false)
  isPubliclyVisible: boolean;
}

@example(_ex_createSpaceEvent_req_body)
model CreateSpaceEventRequest extends UpdateSpaceRecurrenceRequest {
  /** Space identifier; corresponds to NomeSpazio. */
  @example("sala riunioni ISAD")
  spaceId: string;

  // DIFFERENZA: inviare al webservice datetime UTC, non data e orari locali separati.
  /** Event start in UTC. | Inizio dell'evento in UTC. */
  @example(utcDateTime.fromISO("2026-10-20T08:00:00Z"))
  startsAt: utcDateTime;

  /** Event end in UTC. | Fine dell'evento in UTC. */
  @example(utcDateTime.fromISO("2026-10-20T09:30:00Z"))
  endsAt: utcDateTime;

  /** Number of seats requested; corresponds to NumPostiOccupati. */
  @example(10)
  seatsToAllocate: integer;
}

@example(_ex_createSpaceRecurrence_req_body)
model CreateSpaceRecurrenceRequest extends UpdateSpaceRecurrenceRequest {
  /** Space identifier; corresponds to NomeSpazio. */
  @example("sala riunioni ISAD")
  spaceId: string;

  /** Start date of the recurrence period (DataInizio). */
  @example(plainDate.fromISO("2026-10-20"))
  fromDate: plainDate;

  /** End date of the recurrence period (DataFine). */
  @example(plainDate.fromISO("2026-10-29"))
  toDate: plainDate;

  /** Start time of each occurrence, local to Europe/Rome (OraInizio). */
  @example(plainTime.fromISO("10:00:00"))
  startsAt: plainTime;

  /** End time of each occurrence, local to Europe/Rome (OraFine). */
  @example(plainTime.fromISO("11:30:00"))
  endsAt: plainTime;

  /** Number of seats requested; corresponds to NumPostiOccupati. */
  @example(10)
  seatsToAllocate: integer;

  /** Weekdays on which the event repeats (GiorniRicorrenza):
   * 0 = Sunday, 1 = Monday, 2 = Tuesday, 3 = Wednesday,
   * 4 = Thursday, 5 = Friday, 6 = Saturday.
   * Each occurrence uses the same Europe/Rome local times, including across
   * daylight-saving transitions.
   */
  @example(#[DayOfWeek.tuesday, DayOfWeek.thursday])
  recurrenceDays: DayOfWeek[];

  // TODO: verify whether the upstream recurrence end date is inclusive.
}

model SpaceEventResult {
  /** Identifier of the created or updated event. */
  @example(9183888)
  id: integer;
}

model SpaceRecurrenceResult {
  /** Identifier of the created or updated recurrence. */
  @example(12960)
  id: integer;

  /** Dates on which the operation failed, including occupied dates.
   * Always present: empty on complete success, non-empty on partial success.
   * Dates use ISO format (YYYY-MM-DD).
   */
  @example(#[])
  failed_dates: plainDate[];
}

model DepartmentalSpaceCalendarRequest {
  /** Space identifier; corresponds to NomeSpazio. */
  @example("sala riunioni ISAD")
  spaceId: string;

  @example(plainDate.fromISO("2026-10-20"))
  fromDate: plainDate;

  @example(plainDate.fromISO("2026-10-26"))
  toDate: plainDate;
}

@error
model DepartmentalSpaceErrorResponse {
  message: string;
}

@doc(TDescription)
model DepartmentalSpaceError<
  TStatus extends integer,
  TDescription extends valueof string
> {
  @statusCode statusCode: TStatus;
  @body body: DepartmentalSpaceErrorResponse;
}

// Errori documentati e integrazioni approvate: 500 su tutte le operazioni, 404 anche nelle modifiche.
// DIFFERENZA da richiedere al webservice: 403 invece di 401 per permessi insufficienti;
// 409 invece di 500 per spazio occupato; 404 invece di 400 per evento/ricorrenza inesistente.
// TODO: il documento mostra messaggi come stringhe JSON; verificare il supporto
// alla struttura { message } adottata dalla specifica.
alias DepartmentalSpaceBaseErrors = DepartmentalSpaceError<
  400,
  "Invalid input. | Dati di input non validi."
> | DepartmentalSpaceError<
  500,
  "The operation failed because of an internal error. | Operazione fallita per un errore interno."
>;

alias DepartmentalSpaceErrors = DepartmentalSpaceBaseErrors | DepartmentalSpaceError<
  403,
  "Insufficient permissions for this operation. | Permessi insufficienti per questa operazione."
>;

alias DepartmentalSpaceModificationErrors = DepartmentalSpaceBaseErrors | DepartmentalSpaceError<
  403,
  "The user lacks the required permission level, or the event was not created through the departmental application. | Il livello di abilitazione dell'utente è insufficiente oppure l'evento non è stato creato tramite l'applicazione degli spazi dipartimentali."
>;

alias DepartmentalSpaceEventNotFound = DepartmentalSpaceError<
  404,
  "The event does not exist. | L'evento non esiste."
>;
alias DepartmentalSpaceRecurrenceNotFound = DepartmentalSpaceError<
  404,
  "The recurrence does not exist. | La ricorrenza non esiste."
>;
alias DepartmentalSpaceOccupied = DepartmentalSpaceError<
  409,
  "The space is already occupied in the requested interval. | Lo spazio è già occupato nell'intervallo richiesto."
>;
alias DepartmentalSpaceRecurrenceConflict = DepartmentalSpaceError<
  409,
  "No occurrences were created because the space is occupied on all requested dates. | Nessuna occorrenza creata perché lo spazio è occupato in tutte le date richieste."
>;

@doc(TDescription)
model DepartmentalSpaceDataResponse<T, TDescription extends valueof string> {
  @statusCode statusCode: 200;
  @body body: {
    data: T;
  };
}

alias DepartmentalSpaceEventResponse = DepartmentalSpaceDataResponse<
  SpaceEventResult,
  "Operation completed; returns the event identifier. | Operazione completata; restituisce l'identificativo dell'evento."
>;
alias DepartmentalSpaceRecurrenceResponse = DepartmentalSpaceDataResponse<
  SpaceRecurrenceResult,
  "Complete or partial success. Returns the recurrence identifier and failed_dates, always present and empty on complete success. | Successo completo o parziale. Restituisce l'identificativo della ricorrenza e failed_dates, sempre presente e vuoto in caso di successo completo."
>;

@doc("Deletion completed; no response body. | Eliminazione completata; nessun body di risposta.")
model DepartmentalSpaceDeletedResponse {
  @statusCode statusCode: 204;
}

@tag("Departmental Spaces")
@route("/bookings/departmental-spaces")
interface DepartmentalSpacesService {
  @get
  @summary("List departmental spaces | Elenca gli spazi dipartimentali")
  @opExample(_ex_getDepartmentalSpaces_resp)
  @doc("List departmental spaces grouped by city and site. | Elenca gli spazi dipartimentali raggruppati per città e sede.")
  getDepartmentalSpaces(
  ): OkDataResponse<DepartmentalSpaceCity[]> | ServerError;

  // TODO REST: GET con body non ha semantica generalmente definita e può essere
  // ignorato o rifiutato dai client/intermediari; valutare query string o POST di ricerca.
  @route("/events")
  @get
  @summary("List events for a departmental space in a date range | Elenca gli eventi di uno spazio dipartimentale in un intervallo di date")
  @opExample(_ex_getDepartmentalSpaceEvents_resp)
  @opExample(_ex_getDepartmentalSpaceEvents_403_resp)
  @doc("List calendar events for a space in a date range. | Elenca gli eventi del calendario di uno spazio in un intervallo di date.")
  getDepartmentalSpaceEvents(
    @body body: DepartmentalSpaceCalendarRequest,
  ): OkDataResponse<DepartmentalSpaceEvent[]> | ServerError | DepartmentalSpaceError<
    403,
    "The user is not enabled for the requested space. | L’utente non è abilitato sullo spazio richiesto."
  >;

  @route("/event-types")
  @get
  @summary("List event types | Elenca le tipologie di evento")
  @opExample(_ex_getDepartmentalSpaceEventTypes_resp)
  @doc("List event types. | Elenca le tipologie di evento.")
  getDepartmentalSpaceEventTypes(
  ): OkDataResponse<IdLabel<integer>[]> | ServerError;

  @route("/events")
  @post
  @summary("Create an event in a departmental space | Crea un evento in uno spazio dipartimentale")
  @opExample(_ex_createSpaceEvent_resp)
  @opExample(_ex_createSpaceEvent_400_resp)
  @opExample(_ex_createSpaceEvent_403_resp)
  @opExample(_ex_createSpaceEvent_409_resp)
  @doc("Create a single event in a departmental space. | Crea un evento singolo in uno spazio dipartimentale.")
  createSpaceEvent(
    @body body: CreateSpaceEventRequest,
  ): DepartmentalSpaceEventResponse | DepartmentalSpaceErrors | DepartmentalSpaceOccupied;
  @route("/events/{eventId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update an event in a departmental space | Modifica un evento in uno spazio dipartimentale")
  @opExample(_ex_updateSpaceEvent_req)
  @opExample(_ex_updateSpaceEvent_resp)
  @opExample(_ex_updateSpaceEvent_403_resp)
  @doc("Update a single event in a departmental space. | Modifica un evento singolo in uno spazio dipartimentale.")
  updateSpaceEvent(
    @path eventId: integer,
    @body body: CreateSpaceEventRequest,
  ): DepartmentalSpaceEventResponse | DepartmentalSpaceModificationErrors | DepartmentalSpaceEventNotFound;

  // TODO: verificare il supporto alla risposta 204 senza body per le eliminazioni.
  @route("/events/{eventId}")
  @delete
  @summary("Delete an event in a departmental space | Elimina un evento da uno spazio dipartimentale")
  @opExample(_ex_deleteSpaceEvent_404_resp)
  @opExample(_ex_deleteSpaceEvent_403_resp)
  @doc("Delete a single event from a departmental space. | Elimina un evento singolo da uno spazio dipartimentale.")
  deleteSpaceEvent(
    @path eventId: integer,
  ): DepartmentalSpaceDeletedResponse | DepartmentalSpaceModificationErrors | DepartmentalSpaceEventNotFound;

  @route("/recurrences")
  @post
  @summary("Create a recurrence | Crea una ricorrenza")
  @opExample(_ex_createSpaceRecurrence_full_resp)
  @opExample(_ex_createSpaceRecurrence_resp)
  @opExample(_ex_createSpaceRecurrence_403_resp)
  @opExample(_ex_createSpaceRecurrence_409_resp)
  @doc("Create a recurrence on the selected weekdays within a date range. | Crea una ricorrenza nei giorni della settimana selezionati in un intervallo di date.")
  createSpaceRecurrence(
    @body body: CreateSpaceRecurrenceRequest,
  ): DepartmentalSpaceRecurrenceResponse | DepartmentalSpaceErrors | DepartmentalSpaceRecurrenceConflict;

  @route("/recurrences/{recurrenceId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update a recurrence | Modifica una ricorrenza")
  // TODO REST: se più occorrenze costituiscono un'unica risorsa ricorrenza,
  // il successo parziale di PATCH richiede una revisione rispetto all'atomicità (RFC 5789).
  // TODO: verificare il supporto all'aggiornamento parziale della ricorrenza
  // con risposta 200 contenente id e failed_dates, obbligatorio anche se vuoto.
  @opExample(_ex_updateSpaceRecurrence_full_resp)
  @opExample(_ex_updateSpaceRecurrence_partial_resp)
  @opExample(_ex_updateSpaceRecurrence_req)
  @opExample(_ex_updateSpaceRecurrence_403_resp)
  @doc("Update the requester, type, description, notes and visibility of a recurrence. | Modifica richiedente, tipologia, descrizione, note e visibilità di una ricorrenza.")
  updateSpaceRecurrence(
    @path recurrenceId: integer,
    @body body: UpdateSpaceRecurrenceRequest,
  ): DepartmentalSpaceRecurrenceResponse | DepartmentalSpaceModificationErrors | DepartmentalSpaceRecurrenceNotFound;

  @route("/recurrences/{recurrenceId}")
  @delete
  @summary("Delete a recurrence | Elimina una ricorrenza")
  @opExample(_ex_deleteSpaceRecurrence_404_resp)
  @opExample(_ex_deleteSpaceRecurrence_403_resp)
  @doc("Delete a recurrence. | Elimina una ricorrenza.")
  deleteSpaceRecurrence(
    @path recurrenceId: integer,
  ): DepartmentalSpaceDeletedResponse | DepartmentalSpaceModificationErrors | DepartmentalSpaceRecurrenceNotFound;
}
