import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/student/esc.tsp";

namespace PolitoAPI;

using Http;

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
