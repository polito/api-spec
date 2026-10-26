import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/geography.tsp";

using Http;

namespace PolitoAPI;

model Country {
  /** TODO: Confirm the country identifier coding with the webservice; the example uses an ISO alpha-2 code. | Confermare la codifica dell'identificativo dello Stato con il webservice; l'esempio usa un codice ISO alpha-2. */
  @example("IT")
  id: string;

  @example("Italia")
  name: string;
}

/** Province or equivalent territorial unit, including metropolitan cities and autonomous provinces. | Provincia o unità territoriale equivalente, comprese città metropolitane e province autonome. */
model Province {
  /** TODO: Confirm the province identifier coding; the example uses the province abbreviation. | Confermare la codifica dell'identificativo della provincia; l'esempio usa la sigla provinciale. */
  @example("CN")
  id: string;

  @example("Cuneo")
  name: string;
}

model ItalianMunicipality {
  /** TODO: Confirm the municipality identifier coding with the webservice; the example uses an ISTAT code. Keep identifiers as strings to preserve leading zeroes. | Confermare la codifica dell'identificativo del comune con il webservice; l'esempio usa un codice ISTAT. Mantenere gli identificativi come stringhe per conservare gli zeri iniziali. */
  @example("004130")
  id: string;

  @example("Mondovì")
  name: string;

  /** Province associated with the municipality, used to fill in the province automatically after selection. | Provincia associata al comune, da compilare automaticamente dopo la selezione. */
  province: Province;
}

@tag("Geography")
@route("/countries")
interface Countries {
  @get
  @summary("List countries | Elenca Stati")
  @doc("Returns the countries available for residence, correspondence and tax domicile addresses. | Restituisce gli Stati selezionabili per gli indirizzi di residenza, recapito e domicilio fiscale.")
  @opExample(_ex_getCountries_resp)
  getCountries(): OkDataResponse<Country[]> | BaseErrors;
}

@tag("Geography")
@route("/italian-municipalities")
interface ItalianMunicipalities {
  @get
  @summary("List Italian municipalities | Elenca comuni italiani")
  @doc("Returns Italian municipalities with their associated provinces. | Restituisce i comuni italiani con le rispettive province.")
  @opExample(_ex_getItalianMunicipalities_resp)
  getItalianMunicipalities(
  ): OkDataResponse<ItalianMunicipality[]> | BaseErrors;
}
