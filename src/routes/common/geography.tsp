import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/geography.tsp";

using Http;

namespace PolitoAPI;

model Country {
  /** NOTA: Confermare gli identificativi degli Stati e se indirizzi e verifica IBAN usino lo stesso elenco. */
  @example("IT")
  id: string;

  /** NOTA: Approfondire la possibilità di ottenere questo campo in inglese chiamando il webservice con header `Accept-Language: en`. */
  @example("Italia")
  name: string;
}

/** Province or equivalent territorial unit, including metropolitan cities and autonomous provinces. | Provincia o unità territoriale equivalente, comprese città metropolitane e province autonome. */
model Province {
  /** NOTA: Confermare la codifica dell'identificativo della provincia; l'esempio usa la sigla provinciale. */
  @example("CN")
  id: string;

  @example("Cuneo")
  name: string;
}

model ItalianMunicipality {
  /** NOTA: Confermare la codifica dell'identificativo del comune con il webservice; l'esempio usa un codice ISTAT. Mantenere gli identificativi come stringhe per conservare gli zeri iniziali. */
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

  @route("/{municipalityId}/postal-codes")
  @get
  @summary("List municipality postal codes | Elenca CAP del comune")
  @doc("Return the postal codes available for the selected Italian municipality. | Restituisce i CAP selezionabili per il comune italiano scelto.")
  @opExample(_ex_getMunicipalityPostalCodes_resp)
  getMunicipalityPostalCodes(
    @path municipalityId: string,
  ): OkDataResponse<string[]> | BaseErrors;
}
