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

// List students in exam example (with attendance, withdrawal and special needs info)
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
            hasSpecialNeeds: true,
            isPresent: false,
            isWithdrawn: false,
            isGraduating: false,
            attendanceYear: "2026",
            notes: #["Necessita di supporto per la lettura"],
          },
          #{
            studentId: "291045",
            name: "Laura",
            surname: "Bianchi",
            hasSpecialNeeds: false,
            isPresent: false,
            isWithdrawn: false,
            isGraduating: true,
            attendanceYear: "2025",
            notes: #[],
          }
        ],
      },
    },
  },
};

// Check exam attendance example
const _ex_checkAttendance_resp = #{
  parameters: #{
    examId: 888122,
    body: #{
      students: #[
        #{ studentId: "290683", isPresent: true, isWithdrawn: false },
        #{ studentId: "291045", isPresent: true, isWithdrawn: true }
      ],
    },
  },
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          studentId: "290683",
          name: "Mario",
          surname: "Rossi",
          hasSpecialNeeds: true,
          isPresent: true,
          isWithdrawn: false,
          isGraduating: false,
          notes: #["Necessita di supporto per la lettura"],
        },
        #{
          studentId: "291045",
          name: "Laura",
          surname: "Bianchi",
          hasSpecialNeeds: false,
          isPresent: true,
          isWithdrawn: true,
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
