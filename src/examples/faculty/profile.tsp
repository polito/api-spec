import "@typespec/http";

using Http;

namespace PolitoAPI;

// Get faculty profile example
const _ex_getFacultyProfile_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        id: 2154,
        firstName: "Mario",
        lastName: "Rossi",
        personalEmail: "mario.rossi@example.com",
        academicEmail: "mario.rossi@polito.it",
        phone: "+39 011 090 7654",
        residenceAddress: "Torino, Via Roma 1",
        fiscalResidence: "Torino, Via Roma 1",
        iban: "XK238804602955671016",
        departmentName: "Dipartimento di Automatica e Informatica",
      },
    },
  },
};

// Update faculty profile example
const _ex_updateFacultyProfile_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        id: 2154,
        firstName: "Mario",
        lastName: "Rossi",
        personalEmail: "mario.rossi@example.com",
        academicEmail: "mario.rossi@polito.it",
        phone: "+39 011 090 1234",
        residenceAddress: "Torino, Via Garibaldi 10",
        fiscalResidence: "Torino, Via Garibaldi 10",
        iban: "IT60X0542811101000000123456",
        departmentName: "Dipartimento di Automatica e Informatica",
      },
    },
  },
};

// List faculty publications example
const _ex_listFacultyPublications_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: "pub-001",
          title: "Dispensa di Informatica",
          mimeType: "application/pdf",
          sizeInKiloBytes: 2456,
          createdAt: utcDateTime.fromISO("2026-03-04T12:29:26.681Z"),
          downloadUrl: "https://example.com/download/pub-001",
        }
      ],
      page: 1,
      pageSize: 20,
      total: 1,
    },
  },
};

// Download faculty publication example
const _ex_downloadFacultyPublication_resp = #{
  returnType: #{ statusCode: 302 },
};

// List assigned courses example
const _ex_listAssignedCourses_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          shortcode: "02JSKOV",
          name: "Human Computer Interaction",
          year: "2025",
          teachingPeriod: "2-2",
          enrolledStudentCount: 120,
        }
      ],
    },
  },
};
