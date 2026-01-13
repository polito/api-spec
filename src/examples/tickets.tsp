import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_ticket_faq = #{
  id: 3623,
  question: "Ho dimenticato il mio nome utente e/o la password e non riesco più ad accedere ad Apply@Polito. Come posso fare?",
  answer: "Clicca sul link &quot;<u>Codice e/o Password dimenticata</u>?&quot; presente sulla pagina di <a href=\"https://didattica.polito.it/pls/portal30/sviluppo.pkg_apply.login?p_lang=IT\">Log-in</a>&nbsp;e segui le istruzioni.",
};

const _ex_ticket_subtopic = #{ id: 103, name: "Accesso studenti esterni" };

const _ex_ticket_topic = #{
  id: 61,
  name: "ACCESSO LAUREE MAGISTRALI",
  subtopics: #[#{ id: 103, name: "Accesso studenti esterni" }],
};

const _ex_ticket_attachment = #{
  id: 0,
  filename: "screenshot.png",
  mimeType: "image/png",
  sizeInKiloBytes: 305,
};

const _ex_ticket_overview = #{
  id: 1145890,
  subject: "Sostituzione esame in piano carriera",
  message: "Buongiorno, vi contatto per sostituire A con B",
  status: TicketStatus.new,
  hasAttachments: true,
  isFromAgent: false,
  agentId: null,
  unreadCount: 2,
  createdAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
  updatedAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
};

const _ex_ticket_reply = #{
  id: 1145890,
  message: "Non si può fare.",
  isFromAgent: true,
  agentId: 351,
  isRead: true,
  createdAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
  attachments: #[],
};
