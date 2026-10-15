namespace PolitoAPI;

// Event type IDs 1 (Riunione) and 2 (Lezione) are fictitious examples.
// IDs 4, 7, 9, 11 and 12 below are taken from the supplied webservice document.

// Illustrative room data, not an authoritative directory of sites or room IDs.
const _ex_departmental_space_place = #{
  buildingId: "TO_CIT11",
  floorId: "XP01",
  roomId: "03XC",
};

const _ex_departmental_space_ref = #{
  id: "sala riunioni ISAD",
  name: "Sala riunioni ISAD",
  description: "Saletta ISIAD",
};

const _ex_departmental_space = #{
  ..._ex_departmental_space_ref,
  numSeats: 120,
  type: #{ id: "S", label: "Sale Riunioni" },
  size: "L",
  place: _ex_departmental_space_place,
  permissionLevel: 1,
};

const _ex_getDepartmentalSpaces_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        Torino: #{
          `Sede Centrale`: #[_ex_departmental_space],
          `Cittadella del Design`: #[],
        },
        Mondovì: #{},
      },
    },
  },
};

const _ex_getDepartmentalSpaceEvents_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: 9183864,
          isCreatedByDepartment: true,
          space: _ex_departmental_space_ref,
          place: _ex_departmental_space_place,
          seatsOccupied: 10,
          description: "Riunione di dipartimento",
          type: #{ id: 1, label: "Riunione" },
          note: "Prepararsi in anticipo secondo documentazione inviata",
          startsAt: utcDateTime.fromISO("2026-10-20T08:00:00Z"),
          endsAt: utcDateTime.fromISO("2026-10-20T09:30:00Z"),
          isTeachingEvent: false,
          details: #{
            requestedBy: #{ id: "028889", name: "Mario Rossi" },
            bookedBy: #{ id: "004435" },
          },
        },
        #{
          id: 9183865,
          isCreatedByDepartment: false,
          space: _ex_departmental_space_ref,
          place: _ex_departmental_space_place,
          seatsOccupied: 100,
          description: "Lezione di System and device programming",

          // Illustrative teaching type ID; upstream mapping is still to be confirmed.
          type: #{ id: 2, label: "Lezione" },

          note: "",
          recurrenceId: 12960,
          startsAt: utcDateTime.fromISO("2026-10-20T12:00:00Z"),
          endsAt: utcDateTime.fromISO("2026-10-20T14:00:00Z"),
          isTeachingEvent: true,
          details: #{
            year: "2026",
            teachingPeriod: "1-1",
            moduleName: "Programming Module A",
            surnameRange: "AAA-ZZZ",
            courseName: "System and device programming",
            teacherId: 2893,
            teacherName: "Mario Rossi",
            classroomTeacherId: 3001,
            classroomTeacherName: "Giovanni Verdi",
            idImt: "",
            courseShortcode: "01NYHOV",
            courseInstanceId: 0,
          },
        }
      ],
    },
  },
};

const _ex_getDepartmentalSpaceEventTypes_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{ id: 1, label: "Riunione" },
        #{ id: 2, label: "Lezione" },
        #{ id: 4, label: "Congresso" },
        #{ id: 7, label: "Concorso" },
        #{ id: 9, label: "Gruppi di studio" },
        #{ id: 11, label: "Seminario" },
        #{ id: 12, label: "Corsi Esterni" }
      ],
    },
  },
};

const _ex_createSpaceRecurrence_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{ id: 12960, failedDates: #[plainDate.fromISO("2026-10-22")] },
    },
  },
};

const _ex_createSpaceEvent_req_body = #{
  spaceId: "sala riunioni ISAD",
  requestedById: "028889",
  typeId: 1,
  eventDescription: "Riunione di dipartimento",
  notes: "Prepararsi in anticipo secondo documentazione inviata",
  isPubliclyVisible: false,
  startsAt: utcDateTime.fromISO("2026-10-20T08:00:00Z"),
  endsAt: utcDateTime.fromISO("2026-10-20T09:30:00Z"),
  seatsToAllocate: 10,
};

// Occurrences stay at 10:00–11:30 Europe/Rome across the DST change.
const _ex_createSpaceRecurrence_req_body = #{
  spaceId: "sala riunioni ISAD",
  typeId: 1,
  eventDescription: "Riunione di dipartimento",
  notes: "Prepararsi in anticipo secondo documentazione inviata",
  isPubliclyVisible: false,
  fromDate: plainDate.fromISO("2026-10-20"),
  toDate: plainDate.fromISO("2026-10-29"),
  startsAt: plainTime.fromISO("10:00:00"),
  endsAt: plainTime.fromISO("11:30:00"),
  seatsToAllocate: 10,
  recurrenceDays: #[DayOfWeek.tuesday, DayOfWeek.thursday],
};

// Attendance increases from 10 to 15; all other fields are unchanged.
const _ex_updateSpaceEvent_req = #{
  parameters: #{
    eventId: 9183888,
    body: #{ ..._ex_createSpaceEvent_req_body, seatsToAllocate: 15 },
  },
};

// Only the description changes.
const _ex_updateSpaceRecurrence_req = #{
  parameters: #{
    recurrenceId: 12960,
    body: #{
      typeId: 1,
      eventDescription: "Riunione di dipartimento - aggiornamento piano attività",
      notes: "Prepararsi in anticipo secondo documentazione inviata",
      isPubliclyVisible: false,
    },
  },
};

const _ex_updateSpaceRecurrence_partial_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{ data: #{ failedDates: #[plainDate.fromISO("2026-10-22")] } },
  },
};
