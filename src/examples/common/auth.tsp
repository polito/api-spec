import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_identity = #{
  username: "s290683",
  type: "student",
  clientId: "5a54f626-4b7e-488e-a0e3-300f54051510",
  token: "c679fa38ff665df6a676acd833194385",
};

const _ex_switchCareer_req = #{ username: "s290683" };

const _ex_enrolMfa_req = #{
  description: "some identifier you chose",
  pubkey: "dGhpcyBzaG91bGQgYmUgYW4gZWNkcyBwdWJsaWMga2V5Li4uIHdoYXQgZGlkIHlvdSB0aGluayB0aGlzIHdhcz8hIPCfp5AK",
};

const _ex_enrolMfa_resp = #{
  returnType: #{
    statusCode: 201,
    body: #{ data: #{ serial: "EDUP000123456" } },
  },
};

const _ex_validateMfa_req = #{
  serial: "EDUP000123456",
  nonce: "65ba9e0e5aac421a9150991638a9d697",
  signature: "83e08d9fc4be3de046318eb3c2c9ae4ede1374a5423a1487b92febc70d106994",
  decline: false,
};

const _ex_validateMfa_resp = #{
  returnType: #{ statusCode: 200, body: #{ data: #{ success: true } } },
};

const _ex_fetchChallenge_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #{
        serial: "EDUP000123456",
        challenge: "dGhpcyBzaG91bGQgYmUgYW4gZWNkcyBwdWJsaWMga2V5Li4uIHdoYXQgZGlkIHlvdSB0aGluayB0aGlzIHdhcz8hIPCfp5AK",
        requestTs: utcDateTime.fromISO("2025-01-01T00:00:00Z"),
        expirationTs: utcDateTime.fromISO("2025-01-01T01:00:00Z"),
      },
    },
  },
};
