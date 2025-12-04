import "@typespec/http";

using Http;

namespace PolitoAPI;

// Exams list example
const _ex_getExams_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: 888137,
          courseId: 262147,
          courseShortcode: "01UDROV",
          courseName: "Cybersecurity (AA-ZZ)",
          teacherId: 1847,
          type: "Scritto",
          status: "booked",
          bookingStartsAt: null,
          bookingEndsAt: utcDateTime.fromISO("2022-08-23T14:00:00Z"),
          examStartsAt: utcDateTime.fromISO("2022-08-29T08:00:00Z"),
          examEndsAt: utcDateTime.fromISO("2022-08-29T10:00:00Z"),
          bookedCount: 12,
          availableCount: 8,
          moduleNumber: 1,
          notes: null,
          places: #[],
          isReschedulable: false,
          question: null,
          feedback: "Esiste già una prenotazione per l'esame in questione",
          requestReason: null,
          requestDetails: null,
        },
        #{
          id: 887981,
          courseId: 262789,
          courseShortcode: "01NYHOV",
          courseName: "System and device programming (AA-ZZ)",
          teacherId: 2893,
          type: "Esami scritti a risposta aperta o chiusa tramite PC",
          status: "available",
          bookingStartsAt: null,
          bookingEndsAt: utcDateTime.fromISO("2022-09-02T14:00:00Z"),
          examStartsAt: utcDateTime.fromISO("2022-09-08T14:00:00Z"),
          examEndsAt: utcDateTime.fromISO("2022-09-08T18:00:00Z"),
          bookedCount: 42,
          availableCount: 108,
          moduleNumber: 1,
          notes: null,
          places: #[],
          isReschedulable: false,
          question: null,
          feedback: null,
          requestReason: null,
          requestDetails: null,
        }
      ],
    },
  },
};
