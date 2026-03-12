import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/tickets.tsp";

namespace PolitoAPI;

using Http;

@example(_ex_ticket_faq)
model TicketFAQ {
  @example(3623)
  id: numeric;

  @example("Ho dimenticato il mio nome utente e/o la password e non riesco più ad accedere ad Apply@Polito. Come posso fare?")
  question: string;

  @example("Clicca sul link &quot;<u>Codice e/o Password dimenticata</u>?&quot; presente sulla pagina di <a href=\"https://didattica.polito.it/pls/portal30/sviluppo.pkg_apply.login?p_lang=IT\">Log-in</a>&nbsp;e segui le istruzioni.")
  answer: string;
}

@example(_ex_ticket_subtopic)
model TicketSubtopic {
  @example(103)
  id: numeric;

  @example("Accesso studenti esterni")
  name: string;
}

@example(_ex_ticket_topic)
model TicketTopic {
  ...TicketSubtopic;
  subtopics: TicketSubtopic[];
}

enum TicketStatus {
  new: "new",
  pending: "pending",
  closed: "closed",
}

@example(_ex_ticket_attachment)
model TicketAttachment {
  @example(0)
  id: numeric;

  @example("screenshot.png")
  filename: string;

  @example("image/png")
  mimeType: string;

  @example(305)
  sizeInKiloBytes: integer;
}

@example(_ex_ticket_overview)
model TicketOverview {
  @example(1145890)
  id: numeric;

  @example("Sostituzione esame in piano carriera")
  subject: string;

  @example("Buongiorno, vi contatto per sostituire A con B")
  message: string;

  status: TicketStatus;

  @example(true)
  hasAttachments: boolean;

  /** If true, this ticket was opened by an agent (not by the student) */
  @example(false)
  isFromAgent: boolean;

  agentId: numeric | null;

  @example(2)
  unreadCount: numeric;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  createdAt: utcDateTime;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  updatedAt: utcDateTime;
}

enum TicketSpecialAgent {
  AIAgent: "AIAgent",
}

@example(_ex_ticket_reply)
model TicketReply {
  @example(1145890)
  id: numeric;

  @example("Non si può fare.")
  message: string;

  /** If true, this reply was sent by an agent (not by the student) */
  @example(true)
  isFromAgent: boolean;

  @example(351)
  agentId: TicketSpecialAgent | numeric | null;

  @example(false)
  needsFeedback?: boolean;

  @example(true)
  isRead: boolean;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  createdAt: utcDateTime;

  attachments: TicketAttachment[];
}

model Ticket {
  ...TicketOverview;
  replies: TicketReply[];
  attachments: TicketAttachment[];
}

model CreateTicketRequest {
  subject: HttpPart<string>;
  message: HttpPart<string>;
  subtopicId: HttpPart<numeric>;
  attachment?: HttpPart<bytes>;
}

model ReplyTicketRequest {
  message: HttpPart<string>;
  attachment?: HttpPart<bytes>;
}

@tag("Tickets")
@route("/ticket-faqs")
interface TicketFAQs {
  @get
  @summary("Search ticket FAQs | Ricerca FAQ ticket")
  searchTicketFAQs(
    @header `Accept-Language`?: "it" | "en" = "it",

    /** Find FAQs containing 'search' in the question */
    @query search: string,
  ): OkDataResponse<TicketFAQ[]> | BaseErrors;
}

@tag("Tickets")
@route("/ticket-topics")
interface TicketTopics {
  @get
  @summary("List ticket topics | Elenca ambiti ticket")
  getTicketTopics(): OkDataResponse<TicketTopic[]> | BaseErrors;
}

@tag("Tickets")
@route("/tickets")
interface Tickets {
  @get
  @summary("List tickets | Elenca ticket")
  getTickets(): OkDataResponse<TicketOverview[]> | BaseErrors;

  @post
  @summary("Create ticket | Crea ticket")
  createTicket(
    @header contentType: "multipart/form-data",
    @multipartBody body: CreateTicketRequest,
  ): OkDataResponse<TicketOverview> | BaseErrors;

  @route("/{ticketId}")
  @get
  @summary("Show a ticket | Mostra un ticket")
  getTicket(@path ticketId: integer): OkDataResponse<Ticket> | BaseErrors;

  @route("/{ticketId}/read")
  @put
  @summary("Mark a ticket as read | Segna un ticket come letto")
  markTicketAsRead(@path ticketId: integer): NoContentResponse | BaseErrors;

  @route("/{ticketId}/close")
  @put
  @summary("Mark a ticket as closed | Segna un ticket come chiuso")
  markTicketAsClosed(@path ticketId: integer): NoContentResponse | BaseErrors;

  @route("/{ticketId}/attachments/{attachmentId}")
  @get
  @summary("Download ticket attachment | Scarica allegato del ticket")
  getTicketAttachment(@path ticketId: integer, @path attachmentId: integer):
    | {
        @header contentType: "application/octet-stream";
        @body body: bytes;
      }
    | RedirectResponse
    | NotFoundResponse
    | BaseErrors;

  @route("/{ticketId}/replies")
  @post
  @summary("Reply to a ticket | Rispondi ad un ticket")
  replyToTicket(
    @path ticketId: integer,
    @header contentType: "multipart/form-data",
    @multipartBody body: ReplyTicketRequest,
  ): NoContentResponse | BaseErrors;

  @route("/{ticketId}/replies/{replyId}/feedback")
  @put
  @summary("Give feedback on a ticket reply | Fornisci feedback su una risposta al ticket")
  setTicketReplyFeedback(
    @path ticketId: integer,
    @path replyId: integer,
    @query positive: boolean,
  ): NoContentResponse | BaseErrors;

  @route("/{ticketId}/replies/{replyId}/attachments/{attachmentId}")
  @get
  @summary("Download ticket reply attachment | Scarica allegato di una risposta al ticket")
  getTicketReplyAttachment(
    @path ticketId: integer,
    @path replyId: integer,
    @path attachmentId: integer,
  ):
    | {
        @header contentType: "application/octet-stream";
        @body body: bytes;
      }
    | RedirectResponse
    | NotFoundResponse
    | BaseErrors;
}
