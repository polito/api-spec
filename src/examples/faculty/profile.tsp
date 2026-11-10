import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_profile_italian_address = #{
  country: #{ id: "IT", name: "Italia" },
  address: "Via Roma 1",
  municipality: #{
    id: "004130",
    name: "Mondovì",
    province: #{ id: "CN", name: "Cuneo" },
  },
  postalCode: "12084",
};

const _ex_profile_updated_italian_address = #{
  ..._ex_profile_italian_address,
  address: "Via Garibaldi 10",
};

const _ex_faculty_personalData = #{
  id: "002154",
  firstName: "Mario",
  lastName: "Rossi",
  fiscalCode: "RSSMRA80A01L219K",
  birthPlace: #{
    city: "Torino",
    province: #{ id: "TO", name: "Torino" },
    country: #{ id: "IT", name: "Italia" },
  },
  birthDate: plainDate.fromISO("1980-01-01"),
  maritalStatus: "Coniugato/a",
  residenceAddress: _ex_profile_italian_address,
};

const _ex_faculty_taxData = #{
  iban: "IT60X0542811101000000123456",
  taxDomicileAddress: _ex_profile_italian_address,
};

const _ex_faculty_personalContacts = #{
  contactAddress: _ex_profile_italian_address,
  contacts: #[
    #{
      type: "email",
      label: "Email personale",
      value: "mario.rossi@example.com",
    },
    #{ type: "mobile", label: "Cellulare personale", value: "+39 333 7654321" }
  ],
};

const _ex_faculty_profile = #{
  personalData: _ex_faculty_personalData,
  taxData: _ex_faculty_taxData,
  personalContacts: _ex_faculty_personalContacts,
  institutionalContacts: #[
    #{
      type: "email",
      label: "email",
      value: "mario.rossi@polito.it",
      isVisibleInDirectory: true,
    },
    #{
      type: "phone",
      label: "Telefono ufficio",
      value: "+39 011 090 7654",
      isVisibleInDirectory: false,
    }
  ],
  publicData: #{
    personalWebsiteUrl: "https://example.com/mario-rossi",
    curricula: #[
      #{
        language: "it",
        uploadedAt: utcDateTime.fromISO("2026-10-20T08:00:00Z"),
        downloadUrl: "https://example.com/cv/mario-rossi-it.pdf",
      },
      #{
        language: "en",
        uploadedAt: utcDateTime.fromISO("2026-10-21T09:00:00Z"),
        downloadUrl: "https://example.com/cv/mario-rossi-en.pdf",
      }
    ],
  },
};

const _ex_getFacultyProfile_resp = #{
  returnType: #{ statusCode: 200, body: #{ data: _ex_faculty_profile } },
};

const _ex_updateFacultyResidence_req = #{
  parameters: #{
    body: #{
      personalData: #{
        residenceAddress: #{
          countryId: "IT",
          address: "Via Garibaldi 10",
          municipalityId: "004130",
          postalCode: "12084",
          validFrom: plainDate.fromISO("2026-11-10"),
          hasConfirmedAddressTruthfulness: true,
          copyToContactAddress: true,
          copyToTaxDomicileAddress: true,
        },
      },
    },
  },
};

// Residence and both copied addresses change; operation-only fields are not returned.
const _ex_updateFacultyProfile_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        ..._ex_faculty_profile,
        personalData: #{
          ..._ex_faculty_personalData,
          residenceAddress: _ex_profile_updated_italian_address,
        },
        taxData: #{
          ..._ex_faculty_taxData,
          taxDomicileAddress: _ex_profile_updated_italian_address,
        },
        personalContacts: #{
          ..._ex_faculty_personalContacts,
          contactAddress: _ex_profile_updated_italian_address,
        },
      },
    },
  },
};

const _ex_createPersonalContact_req = #{
  parameters: #{ body: #{ type: "phone", value: "+39 011 1234567" } },
};

const _ex_updatePersonalContact_req = #{
  parameters: #{ contactType: "mobile", body: #{ value: "+39 333 1234567" } },
};

const _ex_validateIban_valid_resp = #{
  parameters: #{ body: #{ iban: "IT60X0542811101000000123456" } },
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        isValid: true,
        country: "Italia",
        bankName: "Banca di esempio",
      },
    },
  },
};

const _ex_validateIban_foreign_resp = #{
  parameters: #{ body: #{ iban: "FR1420041010050500013M02606" } },
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{ isValid: true, country: "Francia" },
    },
  },
};

const _ex_validateIban_invalid_resp = #{
  parameters: #{ body: #{ iban: "IT00INVALID" } },
  returnType: #{ statusCode: 200, body: #{ data: #{ isValid: false } } },
};

const _ex_updateForeignContactAddress_req = #{
  parameters: #{
    body: #{
      personalContacts: #{
        contactAddress: #{
          countryId: "BD",
          address: "12 Example Road",
          city: "Dhaka",
          postalCode: "1000",
          validFrom: plainDate.fromISO("2026-11-10"),
          hasConfirmedAddressTruthfulness: true,
        },
      },
    },
  },
};
