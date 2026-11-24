import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/esc.tsp";

namespace PolitoAPI;

using Http;

model EuropeanStudentCard {
  canBeRequested: boolean;
  details: {
    status: "active" | "inactive" | "expired";
    inactiveStatusReason: string | null;
    cardNumber: string;
    expiresAt: string;
    qrCode: string;
  } | null;
}

model EscError {
  @example(500)
  code?: integer;

  @example("An error occurred")
  message?: string;

  @example(123456)
  careerId?: integer;
}

alias EscServerError = {
  @statusCode statusCode: 500;
  @body body: ErrorResponse & {
    errors: EscError[];
  };
};

@tag("Esc")
@route("/esc")
interface Esc {
  @delete
  @summary("Delete all Student data on the ESC-Router (and all student's cards) | Cancella tutti i dati dello studente sul Router ESC (e tutte le carte dello studente)")
  @opExample(_ex_esc_delete_err)
  escDelete(): NoContentResponse | BaseErrors | EscServerError;

  @get
  @summary("retrieve european student card | recupera la european student card")
  escGet(): OkDataResponse<EuropeanStudentCard> | BaseErrors;
  @route("/create")
  @post
  @summary("request european student card | richiedi la european student card")
  escRequest(): CreatedResponse | BaseErrors;
}
