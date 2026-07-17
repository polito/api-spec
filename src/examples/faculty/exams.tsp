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
          teacherId: 1847,
          type: "Esami scritti a risposta aperta o chiusa tramite PC",
          places: #[
            #{
              buildingId: "TO_CIT22",
              floorId: "XPTE",
              name: "Aula 1P",
              roomId: "30",
              siteId: "TO_CIT",
            }
          ],
          bookingStartsAt: null,
          bookingEndsAt: utcDateTime.fromISO("2026-08-31T14:00:00Z"),
          examStartsAt: utcDateTime.fromISO("2026-09-02T14:00:00Z"),
          examEndsAt: utcDateTime.fromISO("2026-09-02T17:00:00Z"),
          bookedCount: 42,
          availableCount: 8,
          moduleNumber: 1,
        }
      ],
    },
  },
};

// List students in exam example (with attendance + extra time info)
const _ex_listStudentsInExam_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        summary: #{
          attendanceDebtCount: 10,
          firstAttendanceCount: 70,
          extraTimeCount: 19,
          graduatingCount: 2,
        },
        students: #[
          #{
            studentId: "290683",
            name: "Mario",
            surname: "Rossi",
            needsExtraTime: true,
            isPresent: false,
            isGraduating: false,
            notes: #["Necessita di supporto per la lettura"],
          },
          #{
            studentId: "291045",
            name: "Laura",
            surname: "Bianchi",
            needsExtraTime: false,
            isPresent: false,
            isGraduating: true,
            notes: #[],
          }
        ],
      },
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
          studentId: "290683",
          name: "Mario",
          surname: "Rossi",
          needsExtraTime: true,
          isPresent: true,
          isGraduating: false,
          notes: #["Necessita di supporto per la lettura"],
        },
        #{
          studentId: "291045",
          name: "Laura",
          surname: "Bianchi",
          needsExtraTime: false,
          isPresent: true,
          isGraduating: true,
          notes: #[],
        }
      ],
    },
  },
};

// Notify exam subscribers example
const _ex_notifyExamSubscribers_resp = #{
  returnType: #{
    statusCode: 202,
    body: #{ data: #{ status: "accepted", trackingId: "track-abc-123" } },
  },
};

// Add student to exam example (201 - created)
const _ex_addStudentToExam_resp = #{
  returnType: #{
    statusCode: 201,
    body: #{ data: #{ studentId: "292145", name: "Anna", surname: "Ferrari" } },
  },
};

// Enroll student to exam example (204 - no content)
const _ex_enrollStudentToExam_resp = #{ returnType: #{ statusCode: 204 } };

// Check student enrollment example
const _ex_checkStudentEnrollment_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        checkPassed: true,
        message: "Lo studente può essere iscritto all'appello",
      },
    },
  },
};
