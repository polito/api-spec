import "@typespec/http";

using Http;

namespace PolitoAPI;

// List faculty exams example
const _ex_listFacultyExams_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: 888122,
          courseId: 262147,
          courseShortcode: "02JSKOV",
          courseName: "Human Computer Interaction",
          teacherId: 2154,
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
          status: "available",
          bookingStartsAt: utcDateTime.fromISO("2026-03-04T11:07:28.541Z"),
          bookingEndsAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
          examStartsAt: utcDateTime.fromISO("2022-09-02T14:00:00Z"),
          examEndsAt: utcDateTime.fromISO("2022-09-02T17:00:00Z"),
          bookedCount: 42,
          availableCount: 8,
          question: null,
          feedback: null,
          isReschedulable: false,
          notes: null,
          moduleNumber: 1,
          requestReason: null,
          requestDetails: null,
          enrolled: #[
            #{
              personId: "290683",
              name: "Mario Rossi",
              degree: "Ingegneria Informatica",
              email: "mario.rossi@studenti.polito.it",
            },
          ],
        },
      ],
    },
  },
};

// Get faculty exam details example
const _ex_getFacultyExam_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        id: 888122,
        courseId: 262147,
        courseShortcode: "02JSKOV",
        courseName: "Human Computer Interaction",
        teacherId: 2154,
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
        status: "available",
        bookingStartsAt: utcDateTime.fromISO("2026-03-04T11:07:28.541Z"),
        bookingEndsAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
        examStartsAt: utcDateTime.fromISO("2022-09-02T14:00:00Z"),
        examEndsAt: utcDateTime.fromISO("2022-09-02T17:00:00Z"),
        bookedCount: 42,
        availableCount: 8,
        question: null,
        feedback: null,
        isReschedulable: false,
        notes: null,
        moduleNumber: 1,
        requestReason: null,
        requestDetails: null,
        enrolled: #[
          #{
            personId: "290683",
            name: "Mario Rossi",
            degree: "Ingegneria Informatica",
            email: "mario.rossi@studenti.polito.it",
          },
          #{
            personId: "291045",
            name: "Laura Bianchi",
            degree: "Ingegneria del Cinema",
            email: "laura.bianchi@studenti.polito.it",
          },
        ],
      },
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
        personId: "292145",
        name: "Anna Ferrari",
        degree: "Ingegneria Informatica",
        email: "anna.ferrari@studenti.polito.it",
      },
    },
  },
};
