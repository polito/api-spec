import "@typespec/http";

using Http;

namespace PolitoAPI;

// List exams example
const _ex_getExams_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: 888122,
          courseId: 262147,
          courseShortcode: "02JSKOV",
          courseName: "Human Computer Interaction",
          type: "Esami scritti a risposta aperta o chiusa tramite PC",
          places: #[
            #{
              buildingId: "TO_CIT22",
              floorId: "XPTE",
              name: "Aula 1P",
              roomId: "30",
              siteId: "TO_CIT",
            },
          ],
          bookingEndsAt: utcDateTime.fromISO("2026-08-31T14:00:00Z"),
          examStartsAt: utcDateTime.fromISO("2026-09-02T14:00:00Z"),
          examEndsAt: utcDateTime.fromISO("2026-09-02T17:00:00Z"),
          bookedCount: 42,
          availableCount: 8,
        },
      ],
    },
  },
};

// List students in exam example (with attendance + extra time info)
const _ex_listStudentsInExam_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          username: "290683",
          name: "Mario",
          surname: "Rossi",
          needsExtraTime: true,
          extraTimeMinutes: 30,
          isPresent: false,
        },
        #{
          username: "291045",
          name: "Laura",
          surname: "Bianchi",
          needsExtraTime: false,
          extraTimeMinutes: null,
          isPresent: false,
        },
      ],
    },
  },
};

// Check exam attendance example
const _ex_checkAttendance_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          username: "290683",
          name: "Mario",
          surname: "Rossi",
          needsExtraTime: true,
          extraTimeMinutes: 30,
          isPresent: true,
        },
        #{
          username: "291045",
          name: "Laura",
          surname: "Bianchi",
          needsExtraTime: false,
          extraTimeMinutes: null,
          isPresent: true,
        },
      ],
    },
  },
};

// Notify exam subscribers example
const _ex_notifyExamSubscribers_resp = #{
  returnType: #{
    statusCode: 202,
    body: #{
      data: #{
        status: "accepted",
        trackingId: "track-abc-123",
      },
    },
  },
};

// Add student to exam example (201 - created)
const _ex_addStudentToExam_resp = #{
  returnType: #{
    statusCode: 201,
    body: #{
      data: #{
        username: "292145",
        name: "Anna",
        surname: "Ferrari",
      },
    },
  },
};

// Enroll / check student enrollment example (204 - no content)
const _ex_enrollStudentToExam_resp = #{
  returnType: #{ statusCode: 204 },
};
