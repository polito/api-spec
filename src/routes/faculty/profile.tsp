import "@typespec/http";
import "@typespec/openapi";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/faculty/profile.tsp";

using Http;

namespace PolitoAPI;

model ProfileAddress {
  country: Country;

  @example("Corso Duca degli Abruzzi 24")
  address: string;

  /** Required for Italian addresses; absent for foreign addresses. The province is included in the municipality. | Obbligatorio per indirizzi italiani; assente per indirizzi esteri. La provincia è contenuta nel comune. */
  municipality?: ItalianMunicipality;

  /** Free-text city for foreign addresses; absent for Italian addresses. | Città estera come testo libero; assente per indirizzi italiani. */
  @example("Dhaka")
  city?: string;

  /** Optional hamlet for Italian addresses. | Frazione facoltativa per gli indirizzi italiani. */
  @example("Borgata San Giovanni")
  district?: string;

  @example("10129")
  postalCode: string;
}

/** Address data sent for updates. Do not send a province separately: it is determined by municipalityId. | Dati dell'indirizzo inviati in aggiornamento. Non inviare separatamente la provincia: deriva da municipalityId. */
model ProfileAddressInput {
  @example("IT")
  countryId: string;

  @example("Corso Duca degli Abruzzi 24")
  address: string;

  /** Required for Italy; omit for other countries. | Obbligatorio per l'Italia; omettere per gli altri Stati. */
  @example("001272")
  municipalityId?: string;

  /** Required as free text for countries other than Italy; omit for Italy. | Obbligatorio come testo libero per Stati diversi dall'Italia; omettere per l'Italia. */
  @example("Dhaka")
  city?: string;

  /** Optional hamlet for Italian addresses. | Frazione facoltativa per gli indirizzi italiani. */
  district?: string;

  /** For Italy, select from the postal codes of the selected municipality; free text abroad. | Per l'Italia, selezionare tra i CAP del comune scelto; testo libero per l'estero. */
  @example("10129")
  postalCode: string;
}

model ProfileAddressUpdateRequest extends ProfileAddressInput {
  /** Date declared by the user from which the new address must be used. Sent only on update, not returned by GET. | Data dichiarata dall'utente dalla quale utilizzare il nuovo indirizzo. Inviata solo in aggiornamento, non restituita dalla GET. */
  @example(plainDate.fromISO("2026-11-10"))
  validFrom: plainDate;

  /** Must be true: the caller confirms the declaration that the supplied address details are truthful and acknowledges responsibility for false declarations. Required also for direct API calls outside the frontend. | Deve essere true: il chiamante conferma la dichiarazione di veridicità dei dati dell'indirizzo e la consapevolezza delle responsabilità per dichiarazioni false. Obbligatorio anche per chiamate API esterne al frontend. */
  @example(true)
  hasConfirmedAddressTruthfulness: true;
}

model ResidenceAddressUpdateRequest extends ProfileAddressUpdateRequest {
  /** Also update the correspondence address using the same address and effective date. Omission means no copy. | Aggiornare anche il recapito con gli stessi dati e decorrenza. Se omesso, non copiare. */
  @example(false)
  copyToContactAddress?: boolean;

  /** Also update the tax domicile using the same address and effective date. Omission means no copy. | Aggiornare anche il domicilio fiscale con gli stessi dati e decorrenza. Se omesso, non copiare. */
  @example(false)
  copyToTaxDomicileAddress?: boolean;
}

/** NOTA: Chiedere se comune o città, provincia e Stato di nascita siano disponibili separatamente nel webservice. */
model ProfileBirthPlace {
  @example("Torino")
  city: string;

  /** Italian province, when applicable. | Provincia italiana, se pertinente. */
  province?: Province;

  country: Country;
}

model ProfileContact {
  /** Contact type used for icons and validation. | Tipo di contatto usato per icone e validazione.
   * NOTA: Confermare i codici disponibili con il webservice; gli esempi usano email, mobile e phone.
   */
  @example("email")
  type: string;

  /** NOTA: Approfondire la possibilità di ottenere questo campo in inglese chiamando il webservice con header `Accept-Language: en`. */
  @example("Email personale")
  label: string;

  @example("mario.rossi@example.com")
  value: string;
}

@example(#{
  type: "email",
  label: "email",
  value: "mario.rossi@polito.it",
  isVisibleInDirectory: true,
})
model InstitutionalProfileContact extends ProfileContact {
  /** Directory visibility, provided only for institutional contacts. | Visibilità in rubrica, fornita solo per i contatti istituzionali. */
  @example(true)
  isVisibleInDirectory?: boolean;
}

model FacultyPersonalData {
  @example("002154")
  id: string;

  @example("Mario")
  firstName: string;

  @example("Rossi")
  lastName: string;

  @example("RSSMRA80A01L219K")
  fiscalCode: string;

  birthPlace: ProfileBirthPlace;

  @example(plainDate.fromISO("1980-01-01"))
  birthDate: plainDate;

  /** NOTA: Verificare i valori disponibili, la loro rappresentazione e la possibilità di ottenerli in inglese chiamando il webservice con header `Accept-Language: en`. */
  @example("Coniugato/a")
  maritalStatus: string;

  residenceAddress: ProfileAddress;
}

model FacultyTaxData {
  @example("IT60X0542811101000000123456")
  iban: string;

  /** Tax domicile address. | Indirizzo del domicilio fiscale. */
  taxDomicileAddress: ProfileAddress;
}

model FacultyPersonalContacts {
  /** Correspondence address. | Indirizzo di recapito. */
  contactAddress: ProfileAddress;

  /** Personal email addresses and phone numbers, with at most one contact per type. Type is the unique key; there is no separate contact ID. | Email e telefoni personali, al massimo un contatto per tipo. Il tipo è la chiave univoca; non è previsto un ID separato. */
  contacts: ProfileContact[];
}

/** NOTA: Chiedere al webservice il supporto a caricamento, sostituzione e download del CV, i formati ammessi, la dimensione massima e l'eventuale rimozione. */
model FacultyCurriculum {
  @example("it")
  language: "it" | "en";

  @example(utcDateTime.fromISO("2026-10-20T08:00:00Z"))
  uploadedAt: utcDateTime;

  @example("https://example.com/cv/mario-rossi-it.pdf")
  downloadUrl: string;
}

model FacultyPublicData {
  @example("https://example.com/mario-rossi")
  personalWebsiteUrl: string;

  /** Italian and English CVs, identified by language. | CV italiano e inglese, identificati dalla lingua. */
  curricula: FacultyCurriculum[];
}

model FacultyCurriculumUpload {
  file: HttpPart<bytes>;
}

model CreatePersonalContactRequest {
  /** Only one personal contact per type is allowed. | È consentito un solo contatto personale per tipo. */
  @example("phone")
  type: string;

  @example("+39 011 1234567")
  value: string;
}

model UpdatePersonalContactRequest {
  @example("+39 333 1234567")
  value: string;
}

model IbanValidationRequest {
  @example("IT60X0542811101000000123456")
  iban: string;
}

model InvalidIbanValidationResult {
  /** Invalid IBAN: country and bank information are not returned. | IBAN non valido: non vengono restituiti Stato e istituto bancario. */
  isValid: false;
}

model ValidIbanValidationResult {
  isValid: true;

  /** Country name. | Nome dello Stato. */
  @example("Italia")
  country: string;

  /** Bank name, returned for a valid Italian IBAN only. | Istituto bancario, restituito solo per un IBAN italiano valido.
   * NOTA: Confermare i dati dell'istituto restituiti dal webservice.
   */
  @example("Banca di esempio")
  bankName?: string;
}

@OpenAPI.oneOf
union IbanValidationResult {
  valid: ValidIbanValidationResult,
  invalid: InvalidIbanValidationResult,
}

model FacultyProfile {
  personalData: FacultyPersonalData;
  taxData: FacultyTaxData;
  personalContacts: FacultyPersonalContacts;
  institutionalContacts: InstitutionalProfileContact[];
  publicData: FacultyPublicData;
}

/** Only the residence address can be updated. | È modificabile solo l'indirizzo di residenza. */
model FacultyPersonalDataUpdateRequest {
  residenceAddress?: ResidenceAddressUpdateRequest;
}

model FacultyTaxDataUpdateRequest {
  taxDomicileAddress?: ProfileAddressUpdateRequest;
}

model IdentityDocumentUpload {
  @header contentType: "application/pdf" | "image/jpeg" | "image/png";
  @body content: bytes;
}

// NOTA: chiarire con il webservice gli eventuali ulteriori dati e identificativi necessari per bonifici esteri e circuiti fuori SEPA.
model FacultyBankDetailsUpdateRequest {
  /** New IBAN. The server must validate it before saving. | Nuovo IBAN. Il server deve verificarlo prima del salvataggio. */
  iban: HttpPart<string>;

  /** Required for foreign bank details, entered by the user. Omit for an Italian IBAN: the bank is obtained from validation on the server. | Obbligatorio per coordinate bancarie estere, inserito dall'utente. Omettere per IBAN italiani: l'istituto è ricavato dalla verifica sul server. */
  bankName?: HttpPart<string>;

  /** BIC/SWIFT code, required for non-Italian SEPA transfers and non-SEPA transfers. | Codice BIC/SWIFT obbligatorio per bonifici SEPA non italiani e bonifici non SEPA. */
  bicSwift?: HttpPart<string>;

  /** Identity document required for every IBAN change. Allowed formats: PDF, JPG, JPEG and PNG. | Documento di identità obbligatorio per ogni modifica dell'IBAN. Formati ammessi: PDF, JPG, JPEG e PNG.
   * NOTA: chiedere al webservice la dimensione massima consentita del documento di identità.
   */
  identityDocument: HttpPart<IdentityDocumentUpload>;
}

model FacultyPersonalContactsUpdateRequest {
  contactAddress?: ProfileAddressUpdateRequest;
}

model FacultyPublicDataUpdateRequest {
  @example("https://example.com/mario-rossi")
  personalWebsiteUrl?: string;
}

/** Omitted sections and fields are left unchanged. Institutional contacts cannot be updated. | Le sezioni e i campi omessi restano invariati. I contatti istituzionali non sono modificabili. */
model FacultyProfileUpdateRequest {
  personalData?: FacultyPersonalDataUpdateRequest;
  taxData?: FacultyTaxDataUpdateRequest;
  personalContacts?: FacultyPersonalContactsUpdateRequest;
  publicData?: FacultyPublicDataUpdateRequest;
}

@tag("Faculty - Profile")
@route("/faculty/me")
interface FacultyProfile_Routes {
  @get
  @summary("Get faculty profile | Profilo docente")
  @doc("Returns the personal data of the authenticated faculty member. | Restituisce i dati personali del docente autenticato.")
  @opExample(_ex_getFacultyProfile_resp)
  getFacultyProfile(
  ): OkDataResponse<FacultyProfile> | NotAuthorized | ServerError;

  @route("/personal-contacts")
  @post
  @summary("Add personal contact | Aggiungi contatto personale")
  @doc("Add a personal contact of a type not already present. | Aggiunge un contatto personale di un tipo non ancora presente.")
  @opExample(_ex_createPersonalContact_req)
  createPersonalContact(
    @body body: CreatePersonalContactRequest,
  ): NoContentResponse | NotAuthorized | BaseErrors;

  @route("/personal-contacts/{contactType}")
  @patch(#{ implicitOptionality: false })
  @summary("Update personal contact | Modifica contatto personale")
  @doc("Update the value of the personal contact identified by its type. | Modifica il valore del contatto personale identificato dal tipo.")
  @opExample(_ex_updatePersonalContact_req)
  updatePersonalContact(
    @path contactType: string,
    @body body: UpdatePersonalContactRequest,
  ): NoContentResponse | NotAuthorized | BaseErrors;

  // NOTA: verificare con il webservice il supporto al caricamento multipart dei CV e i vincoli sul file.
  @route("/curricula/{language}")
  @put
  @summary("Upload or replace CV | Carica o sostituisci CV")
  @doc("Upload or replace the CV in the selected language. | Carica o sostituisce il CV nella lingua selezionata.")
  uploadFacultyCurriculum(
    @path language: "it" | "en",
    @header contentType: "multipart/form-data",
    @multipartBody body: FacultyCurriculumUpload,
  ): NoContentResponse | NotAuthorized | BaseErrors;

  // NOTA: chiedere quali controlli effettui il servizio sull'IBAN; non assumere che la validazione garantisca l'esistenza del conto.
  @route("/iban/validation")
  @post
  @summary("Validate IBAN | Verifica IBAN")
  @doc("Validate an IBAN and return its country and, for Italy, bank information when valid. | Verifica un IBAN e, se valido, restituisce lo Stato e, per l'Italia, l'istituto bancario.")
  @opExample(_ex_validateIban_valid_resp)
  @opExample(_ex_validateIban_foreign_resp)
  @opExample(_ex_validateIban_invalid_resp)
  validateFacultyIban(
    @body body: IbanValidationRequest,
  ): OkDataResponse<IbanValidationResult> | NotAuthorized | BaseErrors;

  @route("/bank-details")
  @patch(#{ implicitOptionality: false })
  @summary("Update bank details | Modifica coordinate bancarie")
  @doc("Update bank details with the required identity document. | Modifica le coordinate bancarie allegando il documento di identità obbligatorio.")
  updateFacultyBankDetails(
    @header contentType: "multipart/form-data",
    @multipartBody body: FacultyBankDetailsUpdateRequest,
  ): NoContentResponse | NotAuthorized | BaseErrors;

  @patch(#{ implicitOptionality: false })
  @summary("Update faculty profile | Aggiorna dati anagrafici del docente")
  @opExample(_ex_updateForeignContactAddress_req)
  @opExample(_ex_updateFacultyResidence_req)
  @opExample(_ex_updateFacultyProfile_resp)
  updateFacultyProfile(
    @body body: FacultyProfileUpdateRequest,
  ): OkDataResponse<FacultyProfile> | NotAuthorized | BaseErrors;
}
