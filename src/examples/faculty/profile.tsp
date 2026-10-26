import "@typespec/http";

using Http;

namespace PolitoAPI;

// Get faculty profile example
const _ex_getFacultyProfile_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        personalData: #{
          id: 2154,
          firstName: "Mario",
          lastName: "Rossi",
          fiscalCode: "RSSMRA80A01L219K",
          birthPlace: "Torino",
          birthDate: plainDate.fromISO("1980-01-01"),
          maritalStatus: "Coniugato/a",
          residenceAddress: #{},
        },
        taxData: #{ iban: "XK238804602955671016", taxDomicileAddress: #{} },
        personalContacts: #{
          contactAddress: #{},
          contacts: #[
            #{ label: "Email personale", value: "mario.rossi@example.com" },
            #{ label: "Cellulare personale", value: "+39 333 7654321" }
          ],
        },
        institutionalContacts: #[
          #{
            label: "email",
            value: "mario.rossi@polito.it",
            isVisibleInDirectory: true,
          },
          #{
            label: "Telefono ufficio",
            value: "+39 011 090 7654",
            isVisibleInDirectory: false,
          }
        ],
        publicData: #{ personalWebsiteUrl: "https://example.com/mario-rossi" },
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
        personalData: #{
          id: 2154,
          firstName: "Mario",
          lastName: "Rossi",
          fiscalCode: "RSSMRA80A01L219K",
          birthPlace: "Torino",
          birthDate: plainDate.fromISO("1980-01-01"),
          maritalStatus: "Coniugato/a",
          residenceAddress: #{},
        },
        taxData: #{ iban: "XK238804602955671016", taxDomicileAddress: #{} },
        personalContacts: #{
          contactAddress: #{},
          contacts: #[
            #{ label: "Email personale", value: "mario.rossi@example.com" },
            #{ label: "Cellulare personale", value: "+39 333 1234567" }
          ],
        },
        institutionalContacts: #[
          #{
            label: "email",
            value: "mario.rossi@polito.it",
            isVisibleInDirectory: true,
          },
          #{
            label: "Telefono ufficio",
            value: "+39 011 090 7654",
            isVisibleInDirectory: false,
          }
        ],
        publicData: #{ personalWebsiteUrl: "https://example.com/mario-rossi" },
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
