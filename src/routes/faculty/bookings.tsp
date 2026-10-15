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

/** Physical room identifiers. buildingId already identifies the site. */
model RoomRef {
  buildingId: string;
  floorId: string;
  roomId: string;
}

model DepartmentalSpace extends DepartmentalSpaceRef {
  @example(120)
  numSeats: integer;

  @example(#{ id: "S", label: "Sale Riunioni" })
  type: IdLabel;

  @example("L")
  size: string;

  /** The location of the room. Upstream Locale maps to place.roomId,
   * Fabbricato to place.buildingId, and Piano to place.floorId.
   */
  place: RoomRef;

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

/** Maps site names (e.g. Sede Centrale) to their rooms. */
model DepartmentalSpaceSites is Record<DepartmentalSpace[]>;

/** Maps city names (e.g. Torino, Mondovì) to site maps. */
model DepartmentalSpaceFilter is Record<DepartmentalSpaceSites>;

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

  /** Bookable space; NomeSpazio maps to space.id and DescSpazio to space.description. */
  space: DepartmentalSpaceRef;

  /** Physical location: Fabbricato, Piano and Locale. */
  place: RoomRef;

  /** Number of occupied seats; corresponds to NumPostiOccupati. */
  @example(10)
  seatsOccupied: integer;

  /** TODO: verify whether a description is returned for teaching events too.
   * If it is only returned for department events, move this field to
   * DepartmentalSpaceDepartmentEventDetails.
   */
  @example("Riunione di dipartimento")
  description: string;

  /** Event type identifier and display name (DescTipologiaEvento). */
  // TODO: the supplied calendar payload only includes the type description.
  // Confirm how the upstream service or middleware supplies its identifier.
  // Example ID 1 is fictitious; the actual code for Riunione is not yet known.
  @example(#{ id: 1, label: "Riunione" })
  type: IdLabel<integer>;

  @example("Prepararsi in anticipo secondo documentazione inviata")
  note: string;

  /** Identifier of the recurrence series; present only for recurring events.
   * Middleware omits the field when upstream IdRicorrenza is empty.
   */
  @example(456)
  recurrenceId?: integer;

  // TODO: upstream timestamps are Italian local times (Europe/Rome).
  // Verify middleware conversion to/from UTC, including daylight-saving transitions.
  @example(utcDateTime.fromISO("2026-02-15T10:00:00Z"))
  startsAt: utcDateTime;

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

  // TODO: verificare la disponibilità e i valori vuoti/null dei dati didattici,
  // inclusi docente in aula, modulo, fascia alfabetica e courseId (id_inc non documentato).

  /** Corresponds to CodIns. */
  @example("01NYHOV")
  courseShortcode?: string;

  /** Corresponds to the internal "id_inc" value. */
  @example(258674)
  courseId?: numeric;

  /** Course instance identifier; corresponds to the internal "num_cor" value. */
  @example(0)
  courseInstanceId: integer;
}

/** Department event details (FlagDidattico = false). */
model DepartmentalSpaceDepartmentEventDetails {
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
  // TODO: verificare la possibilità di includere la visibilità nella lettura del calendario,
  // oppure chiarire come recuperarla per compilare il payload di aggiornamento.
}

@example(_ex_createSpaceEvent_req_body)
model CreateSpaceEventRequest extends UpdateSpaceRecurrenceRequest {
  /** Space identifier; corresponds to NomeSpazio. */
  @example("sala riunioni ISAD")
  spaceId: string;

  // TODO: upstream dates/times are local to Europe/Rome. Verify middleware
  // conversion to/from UTC, including daylight-saving transitions.
  @example(utcDateTime.fromISO("2026-10-20T08:00:00Z"))
  startsAt: utcDateTime;

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
  // TODO: clarify whether occurrences may cross midnight and how they are represented.
}

model UpdateSpaceRecurrenceResult {
  /** Dates on which the update failed. Present only on partial success. */
  @minItems(1)
  @example(#[plainDate.fromISO("2026-10-22")])
  failedDates: plainDate[];
}

model CreateSpaceRecurrenceResult {
  /** Identifier of the newly created recurrence. */
  @example(12960)
  id: integer;

  /** Dates on which creation failed, including occupied dates.
   * Present in the 200 response for partial success and always non-empty.
   * The webservice must return ISO dates (YYYY-MM-DD).
   */
  @minItems(1)
  @example(#[plainDate.fromISO("2026-10-22")])
  failedDates: plainDate[];
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

alias DepartmentalSpaceUnauthorized = {
  @statusCode statusCode: 401;
  @body body: ErrorResponse;
};

// TODO: definire codici applicativi stabili per i diversi errori
// e la relativa corrispondenza con status HTTP e messaggi, senza interpretare il testo.
// Il webservice mostra messaggi testuali; la nostra API usa ErrorResponse { code, message }.
// Verificare quando code e message debbano essere obbligatori: oggi sono entrambi opzionali.
// Includere spazio occupato, richiedente inesistente, evento/ricorrenza inesistente,
// permessi insufficienti e fallimento totale della creazione di una ricorrenza.
alias DepartmentalSpaceErrors = BaseErrors | DepartmentalSpaceUnauthorized;

@tag("Departmental Spaces")
@route("/bookings/departmental-spaces")
interface DepartmentalSpacesService {
  @get
  @summary("Get the list of departmental spaces")
  @opExample(_ex_getDepartmentalSpaces_resp)
  getDepartmentalSpaces(): OkDataResponse<DepartmentalSpaceFilter> | BaseErrors;

  @route("/events")
  @get
  @summary("List events for a departmental space in a date range | Elenca gli eventi di uno spazio dipartimentale in un intervallo di date")
  @opExample(_ex_getDepartmentalSpaceEvents_resp)
  getDepartmentalSpaceEvents(
    @body body: DepartmentalSpaceCalendarRequest,
  ): OkDataResponse<DepartmentalSpaceEvent[]> | DepartmentalSpaceErrors;

  @route("/event-types")
  @get
  @summary("List event types | Elenca le tipologie di evento")
  @opExample(_ex_getDepartmentalSpaceEventTypes_resp)
  getDepartmentalSpaceEventTypes(
  ): OkDataResponse<IdLabel<integer>[]> | BaseErrors;

  @route("/events")
  @post
  // TODO: verificare il supporto alla creazione del singolo evento con risposta 204
  // senza body. Il frontend invalida la query del calendario per rileggere gli eventi.
  @summary("Create an event in a departmental space | Crea un evento in uno spazio dipartimentale")
  @doc("Creates a single event. The body field spaceId corresponds to NomeSpazio; caller identity and application are supplied by middleware.")
  createSpaceEvent(
    @body body: CreateSpaceEventRequest,
  ): NoContentResponse | DepartmentalSpaceErrors;

  // TODO: verificare il supporto alla risposta 204 senza body per modifica ed eliminazione
  // di eventi e ricorrenze, anziché 200 con un messaggio di successo.
  @route("/events/{eventId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update an event in a departmental space | Modifica un evento in uno spazio dipartimentale")
  @doc("Updates a single event. Modification requires isCreatedByDepartment = true and the appropriate user permission level.")
  @opExample(_ex_updateSpaceEvent_req)
  updateSpaceEvent(
    @path eventId: integer,
    @body body: CreateSpaceEventRequest,
  ): NoContentResponse | DepartmentalSpaceErrors;

  @route("/events/{eventId}")
  @delete
  @summary("Delete an event in a departmental space | Elimina un evento da uno spazio dipartimentale")
  @doc("Deletes a single event. Deletion requires isCreatedByDepartment = true and the appropriate user permission level.")
  deleteSpaceEvent(
    @path eventId: integer,
  ): NoContentResponse | DepartmentalSpaceErrors;

  @route("/recurrences")
  @post
  @summary("Create a recurrence | Crea una ricorrenza")
  @doc("Creates events on the requested weekdays within the date range. Returns 204 without a body when all occurrences are created. Returns 200 with the recurrence ID and a non-empty failedDates array on partial success. If no occurrences can be created, returns 500. The frontend refreshes the calendar after either success response and displays failed dates on partial success.")
  // TODO: verificare il supporto alla risposta 204 senza body per il successo completo
  // e 200 con le date fallite per il successo parziale della creazione ricorrenza.
  @opExample(#{ returnType: #{ statusCode: 204 } })
  @opExample(_ex_createSpaceRecurrence_resp)
  createSpaceRecurrence(
    @body body: CreateSpaceRecurrenceRequest,
  ): NoContentResponse | OkDataResponse<CreateSpaceRecurrenceResult> | DepartmentalSpaceErrors;

  @route("/recurrences/{recurrenceId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update a recurrence | Modifica una ricorrenza")
  @doc("Updates the requester, type, description, notes and visibility of a recurrence. Returns 204 without a body when all occurrences are updated, or 200 with a non-empty failedDates array on partial success. Requires creation through the departmental application and the appropriate user permission level. Dates, times, space and seat count are not changed by this operation.")
  // TODO: verificare il supporto all'aggiornamento parziale della ricorrenza:
  // 204 senza body per il successo completo, 200 con le date fallite per quello parziale.
  @opExample(#{ returnType: #{ statusCode: 204 } })
  @opExample(_ex_updateSpaceRecurrence_partial_resp)
  @opExample(_ex_updateSpaceRecurrence_req)
  updateSpaceRecurrence(
    @path recurrenceId: integer,
    @body body: UpdateSpaceRecurrenceRequest,
  ): NoContentResponse | OkDataResponse<UpdateSpaceRecurrenceResult> | DepartmentalSpaceErrors;

  @route("/recurrences/{recurrenceId}")
  @delete
  @summary("Delete a recurrence | Elimina una ricorrenza")
  @doc("Deletes the recurrence. Requires creation through the departmental application and the appropriate user permission level.")
  deleteSpaceRecurrence(
    @path recurrenceId: integer,
  ): NoContentResponse | DepartmentalSpaceErrors;
}
