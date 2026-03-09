import "@typespec/http";

using Http;

namespace PolitoAPI;

// Get faculty profile example
const _ex_getFacultyProfile_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        id: "2154",
        name: "Marco Torchiano",
        personal_email: "marco.torchiano@gmail.com",
        academic_email: "marco.torchiano@polito.it",
        phone: "+39 011 090 7654",
        residence: "Torino, Via Roma 1",
        fiscalResidence: "Torino, Via Roma 1",
        iban: "XK238804602955671016",
        department: "Dipartimento di Automatica e Informatica",
        publications: #[
          #{
            id: "pub-001",
            name: "Dispensa di Informatica",
            mimeType: "application/pdf",
            sizeInKiloBytes: 2456,
            createdAt: utcDateTime.fromISO("2026-03-04T12:27:38.153Z"),
            downloadUrl: "https://example.com/download/pub-001",
          },
        ],
        assignedCourses: #[
          #{
            courseId: "02JSKOV",
            name: "Human Computer Interaction",
            period: "2025/2026 - Secondo semestre",
            enrolledCount: 120,
          },
        ],
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
        id: "2154",
        name: "Marco Torchiano",
        personal_email: "marco.torchiano@gmail.com",
        academic_email: "marco.torchiano@polito.it",
        phone: "+39 011 090 1234",
        residence: "Torino, Via Garibaldi 10",
        fiscalResidence: "Torino, Via Garibaldi 10",
        iban: "IT60X0542811101000000123456",
        department: "Dipartimento di Automatica e Informatica",
        publications: #[
          #{
            id: "pub-001",
            name: "Dispensa di Informatica",
            mimeType: "application/pdf",
            sizeInKiloBytes: 2456,
            createdAt: utcDateTime.fromISO("2026-03-04T12:27:38.153Z"),
            downloadUrl: "https://example.com/download/pub-001",
          },
        ],
        assignedCourses: #[
          #{
            courseId: "02JSKOV",
            name: "Human Computer Interaction",
            period: "2025/2026 - Secondo semestre",
            enrolledCount: 120,
          },
        ],
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
          name: "Dispensa di Informatica",
          mimeType: "application/pdf",
          sizeInKiloBytes: 2456,
          createdAt: utcDateTime.fromISO("2026-03-04T12:29:26.681Z"),
          downloadUrl: "https://example.com/download/pub-001",
        },
      ],
      page: 1,
      pageSize: 20,
      total: 1,
    },
  },
};

// Download faculty publication example
const _ex_downloadFacultyPublication_resp = #{
  returnType: #{
    statusCode: 302,
  },
};
