import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/bookings.tsp";

using Http;

namespace PolitoAPI;
model BookingTopicOverview {
  @example("DIDATTICA_ING")
  id: string;

  @example("Segreteria Didattica Ingegneria")
  title: string;

  @example("Servizi della Segreteria Didattica Ingegneria")
  description: string;
}

model BookingTopicLeaf extends BookingTopicOverview {
  @example(true)
  isEnabled: boolean;

  @example("")
  disclaimer: string;

  @example(true)
  showCalendar: boolean;

  @example(15)
  slotLength: integer;

  @example(4)
  slotsPerHour: integer;

  /** Start date of the booking period */
  startDate: plainDate | null;

  @example(8)
  startHour: integer;

  @example(18)
  endHour: integer;

  @example(2)
  maxBookingsPerDay: integer;

  @example(true)
  canBeCancelled: boolean;

  /** Number of days per week the booking is available, starting from startDate weekday, or monday if missing */
  @example(5)
  daysPerWeek: integer;

  /** Specifies if the topic requires the agenda display */
  @example(false)
  agendaView: boolean;
}

model BookingSubtopic extends BookingTopicLeaf {
  requirements: {
    name?: string;
    url?: string;
  }[];
}

@example(_ex_booking_topic)
model BookingTopic extends BookingTopicLeaf {
  subtopics: BookingSubtopic[];
}

@example(_ex_booking_slot)
model BookingSlot {
  @example(103051)
  id: integer;

  @example("")
  description: string;

  @example(false)
  isBooked: boolean;

  @example(false)
  canBeBooked: boolean;

  @example(false)
  hasSeats: boolean;

  @example(false)
  hasSeatSelection: boolean;

  @example(2)
  places: integer;

  @example(2)
  bookedPlaces: integer;

  @example("Il turno è pieno")
  feedback: string;

  location: {
    name?: string;
    description?: string;
    type?: string;
    address?: string;
  };

  @example(utcDateTime.fromISO("2021-10-05T10:00:00Z"))
  startsAt: utcDateTime;

  @example(utcDateTime.fromISO("2021-10-05T10:15:00Z"))
  endsAt: utcDateTime;

  @example(utcDateTime.fromISO("2021-10-01T00:00:00Z"))
  bookingStartsAt: utcDateTime;

  @example(utcDateTime.fromISO("2021-10-05T09:00:00Z"))
  bookingEndsAt: utcDateTime;
}

model BookingSeatCell {
  @example(20018)
  id: integer;

  @example("available")
  status: "available" | "booked" | "unavailable";

  @example("A5")
  label: string;
}
model BookingSeatsRow {
  id?: integer;
  label: string;
  seats: BookingSeatCell[];
}
model BookingSeats {
  totalCount: integer;
  availableCount: integer;
  rows: BookingSeatsRow[];
}

@tag("Bookings")
@route("/booking-topics")
interface BookingTopics {
  @get
  @summary("List booking topics | Elenca ambiti di prenotazione")
  getBookingTopics(): OkDataResponse<BookingTopic[]> | BaseErrors;

  @route("/{bookingTopicId}/slots")
  @get
  @summary("Show booking slots | Mostra turni prenotabili")
  getBookingSlots(
    @path bookingTopicId: string,

    /** First day - defaults to monday of current week */
    @query fromDate?: plainDate,

    /** Last day - defaults to sunday of current week */
    @query toDate?: plainDate,
  ): OkDataResponse<BookingSlot[]> | BaseErrors;

  @route("/{bookingTopicId}/slots/{bookingSlotId}/seats")
  @get
  @summary("Show seats for a booking slots | Mostra posti prenotabili")
  getBookingSeats(
    @path bookingTopicId: string,
    @path bookingSlotId: string,
  ): OkDataResponse<BookingSeats> | BaseErrors;
}

model BookingLocationCheck {
  enabled: boolean;
  checked: boolean;
  latitude: string | null;
  longitude: string | null;
  radiusInKm: numeric | null;
}

model BookingPhysicalPlaceRef extends PlaceRef {
  description: string;
}

model BookingVirtualPlaceRef {
  name: string;
  url: string;
}

@discriminated(#{ envelope: "none", discriminatorPropertyName: "type" })
union BookingPlaceRef {
  place: BookingPhysicalPlaceRef,
  virtualPlace: BookingVirtualPlaceRef,
}

model Booking {
  @example(258674)
  id: integer;

  @example("")
  description: string;

  topic: BookingTopicOverview;
  subtopic: BookingTopicOverview | null;

  @example(utcDateTime.fromISO("2021-10-05T10:00:00Z"))
  startsAt: utcDateTime;

  @example(utcDateTime.fromISO("2021-10-05T10:15:00Z"))
  endsAt: utcDateTime;

  seat: {
    id?: integer;
    row?: string;
    column?: string;
  } | null;

  @example(utcDateTime.fromISO("2021-10-05T09:00:00Z"))
  cancelableUntil: utcDateTime;

  location: BookingPlaceRef;
  locationCheck?: BookingLocationCheck;
}

model UpdateBookingRequest {
  @example(true)
  isLocationChecked: boolean;
}

model CreateBookingRequest {
  @example(103051)
  slotId: integer;

  @example(20018)
  seatId?: integer;
}

@tag("Bookings")
@route("/bookings")
interface BookingsManagement {
  @get
  @summary("List bookings | Elenca prenotazioni")
  getBookings(): OkDataResponse<Booking[]> | BaseErrors;

  @post
  @summary("Create booking | Crea prenotazione")
  createBooking(
    @body body: CreateBookingRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{bookingId}")
  @delete
  @summary("Delete booking | Cancella prenotazione")
  deleteBooking(@path bookingId: integer): NoContentResponse | BaseErrors;

  @route("/{bookingId}")
  @patch(#{ implicitOptionality: false })
  @summary("Update booking | Aggiorna prenotazione")
  updateBooking(
    @path bookingId: integer,
    @body body: UpdateBookingRequest,
  ): NoContentResponse | BaseErrors;
}
