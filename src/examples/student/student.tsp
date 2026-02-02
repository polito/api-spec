import "@typespec/http";

using Http;

namespace PolitoAPI;

// Deadline examples for getDeadlines
const _ex_getDeadlines_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          name: "Termine per l'iscrizione e pagamento della prima rata, per gli studenti di anni successivi al primo",
          type: "Iscrizioni e pagamento tasse",
          date: plainDate.fromISO("2022-10-11"),
          url: null,
        },
        #{
          name: "Trasferimento da altri Atenei italiani",
          type: "Trasferimenti e valutazioni carriere precedenti",
          date: plainDate.fromISO("2022-10-14"),
          url: null,
        },
        #{
          name: "Termine per superare gli esami",
          type: "Sessioni esami di laurea",
          date: plainDate.fromISO("2022-11-12"),
          url: null,
        },
        #{
          name: "Termine iscrizione esame finale",
          type: "Sessioni esami di laurea",
          date: plainDate.fromISO("2022-11-14"),
          url: null,
        },
        #{
          name: "Periodo per la compilazione del piano carriera / carico didattico",
          type: "Iscrizioni e pagamento tasse",
          date: plainDate.fromISO("2022-11-25"),
          url: null,
        }
      ],
    },
  },
};
