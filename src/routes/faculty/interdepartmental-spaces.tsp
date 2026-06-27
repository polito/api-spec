import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";

namespace PolitoAPI;

using Http;

model InterdepartmentalSpaceFilter {
  @example(#["Sede Centrale", "Cittadella del Design"])
  locations: string[];

  @example(#["Torino", "Mondovì"])
  sites: string[];

  rooms: {
    @example("DAUIN-A1")
    id: string;

    @example("Aula A1")
    name: string;

    /** The number of seats in the room */
    @example(120)
    numSeats: numeric;

    /** The type of the room */
    @example("classroom")
    type: string;

    /** The location of the room */
    @example("Sede Centrale")
    location: string;

    /** The site of the room */
    @example("Torino")
    site: string;
  }[];
}

model InterdepartmentalSpace {
  @example("DAUIN-A1")
  id: string;

  @example("Aula A1")
  name: string;

  /** The number of seats in the room */
  @example(120)
  numSeats: numeric;

  /** The type of the room */
  @example("classroom")
  type: string;

  /** The location of the room */
  place: PlaceRef;

  slotsOccupied: Slot[];
}

model Slot {
  @example("slot-001")
  id: string;

  @example(utcDateTime.fromISO("2026-02-15T10:00:00Z"))
  startAt: utcDateTime;

  @example(utcDateTime.fromISO("2026-02-15T12:00:00Z"))
  endAt: utcDateTime;

  @example("DAUIN-A1")
  idLocations: string;

  bookedBy: Booker;

  @example("Tesi di laurea")
  description: string;

  @example("exam")
  type: string;

  @example("Portare documento")
  note: string;
}

model Booker {
  @example("s290683")
  username: string;

  @example("Mario")
  name: string;

  @example("Rossi")
  surname: string;

  @example("s290683@polito.it")
  email: string;
}

model Types {
  @example("classroom")
  id: string;

  @example("Aula")
  name: string;
}

enum DayOfWeek {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

model CreateSpaceEventRequest {
  /** Set for a single-date event; omit when the event is recurring */
  @example(plainDate.fromISO("2026-02-15"))
  eventDate?: plainDate;

  @example(plainTime.fromISO("10:00:00"))
  startsAt: plainTime;

  @example(plainTime.fromISO("12:00:00"))
  endsAt: plainTime;

  /** Start of the recurrence period; set together with recurrenceEndsAt for a recurring event */
  @example(utcDateTime.fromISO("2026-02-15T00:00:00Z"))
  recurrenceStartsAt?: utcDateTime;

  /** End of the recurrence period; set together with recurrenceStartsAt for a recurring event */
  @example(utcDateTime.fromISO("2026-06-15T00:00:00Z"))
  recurrenceEndsAt?: utcDateTime;

  @example(#[DayOfWeek.monday, DayOfWeek.wednesday])
  recurrenceDays?: DayOfWeek[];

  @example("exam")
  type: string;

  @example("Esame di Analisi Matematica")
  eventDescription: string;

  @example(50)
  seatsToAllocate?: integer;

  @example("Portare documento di identità")
  notes: string;

  @example(true)
  isPubliclyVisible: boolean;
}

@tag("Interdepartmental Spaces")
@route("/interdepartmental-spaces")
interface InterdepartmentalSpacesService {
  @get
  @summary("Get the list of interdepartmental spaces")
  getInterdepartmentalSpaces(
  ): OkDataResponse<InterdepartmentalSpaceFilter> | BaseErrors;

  @route("/{id}")
  @get
  @summary("Get a specific interdepartmental space")
  getInterdepartmentalSpace(
    @path id: string,
  ): OkDataResponse<InterdepartmentalSpace> | BaseErrors;

  @route("/types")
  @get
  @summary("Get the list of interdepartmental space types")
  getInterdepartmentalSpaceTypes(): OkDataResponse<Types[]> | BaseErrors;

  @route("/{id}/events")
  @post
  @summary("Create an event in an interdepartmental space")
  createSpaceEvent(
    @path id: string,
    @body body: CreateSpaceEventRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{id}/events/{eventId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update an event in an interdepartmental space")
  updateSpaceEvent(
    @path id: string,
    @path eventId: string,
    @body body: CreateSpaceEventRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{id}/events/{eventId}")
  @delete
  @summary("Delete an event in an interdepartmental space")
  deleteSpaceEvent(
    @path id: string,
    @path eventId: string,
  ): NoContentResponse | BaseErrors;
}
