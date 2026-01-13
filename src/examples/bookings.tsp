import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_booking_topic = #{
  id: "DIDATTICA_ING",
  title: "Segreteria Didattica Ingegneria",
  description: "Servizi della Segreteria Didattica Ingegneria",
  isEnabled: true,
  disclaimer: "",
  showCalendar: true,
  slotLength: 15,
  slotsPerHour: 4,
  startDate: null,
  startHour: 8,
  endHour: 18,
  maxBookingsPerDay: 2,
  canBeCancelled: true,
  daysPerWeek: 5,
  agendaView: false,
  subtopics: #[
    #{
      id: "DID_ING_VC_EN",
      title: "Aspetti didattici di carriera - Sportello virtuale in inglese",
      description: "",
      isEnabled: true,
      disclaimer: "",
      showCalendar: true,
      slotLength: 15,
      slotsPerHour: 4,
      startDate: null,
      startHour: 8,
      endHour: 18,
      maxBookingsPerDay: 2,
      canBeCancelled: true,
      daysPerWeek: 5,
      agendaView: false,
      requirements: #[],
    }
  ],
};

const _ex_booking_slot = #{
  id: 103051,
  description: "",
  isBooked: false,
  canBeBooked: false,
  hasSeats: false,
  hasSeatSelection: false,
  places: 2,
  bookedPlaces: 2,
  feedback: "Il turno è pieno",
  location: #{
    name: "Virtual Classroom della Segreteria Generale Studenti",
    description: "",
    type: "VC",
    address: "https://didattica.polito.it/pls/portal30/sviluppo.bbb_corsi.queueRoom?id=SEGRETERIA_GENERALE&p_tipo=SEGRETERIA_GENERALE",
  },
  startsAt: utcDateTime.fromISO("2021-10-05T10:00:00Z"),
  endsAt: utcDateTime.fromISO("2021-10-05T10:15:00Z"),
  bookingStartsAt: utcDateTime.fromISO("2021-10-01T00:00:00Z"),
  bookingEndsAt: utcDateTime.fromISO("2021-10-05T09:00:00Z"),
};

const _ex_booking = #{
  id: 258674,
  description: "",
  topic: #{
    id: "DIDATTICA_ING",
    title: "Segreteria Didattica Ingegneria",
    description: "Servizi della Segreteria Didattica Ingegneria",
  },
  subtopic: null,
  startsAt: utcDateTime.fromISO("2021-10-05T10:00:00Z"),
  endsAt: utcDateTime.fromISO("2021-10-05T10:15:00Z"),
  seat: #{ id: 20018, row: "A", column: "5" },
  cancelableUntil: utcDateTime.fromISO("2021-10-05T09:00:00Z"),
  location: #{
    siteId: "TO_CIT",
    buildingId: "TO_CIT11",
    floorId: "XPTE",
    roomId: "001",
    name: "Aula 1",
    description: "Virtual Classroom della Segreteria Generale Studenti",
    type: "place",
  },
};
