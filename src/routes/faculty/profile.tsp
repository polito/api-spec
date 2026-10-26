import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/faculty/profile.tsp";

using Http;

namespace PolitoAPI;

model FacultyPublication {
  @example("pub-001")
  id: string;

  @example("Dispensa di Informatica")
  title: string;

  @example("application/pdf")
  mimeType: string;

  @example(2456)
  sizeInKiloBytes: integer;

  /** TODO: Verify whether this is the record creation, file upload or publication date. | Verificare se indica la creazione del record, il caricamento del file o la pubblicazione. */
  @example(utcDateTime.fromISO("2026-03-04T12:27:38.153Z"))
  createdAt: utcDateTime;

  /** TODO: Verify whether publications can be downloaded through this URL by checking how the web directory behaves. | Verificare se sia possibile scaricare la pubblicazione da questo URL, controllando il comportamento della rubrica web. */
  @example("https://example.com/download/pub-001")
  downloadUrl: string;
}

model AssignedCourse {
  @example("02JSKOV")
  shortcode: string;

  @example("Human Computer Interaction")
  name: string;

  @example("2025")
  year: string;

  /** The semester(s) this course belongs to | Semestre o semestri a cui appartiene il corso */
  @example("2-2")
  teachingPeriod: string;

  @example(120)
  enrolledStudentCount: integer;
}

/** TODO: Define the address fields. This object is provisional. | Definire i campi dell'indirizzo. L'oggetto è provvisorio. */
model ProfileAddress {}

model ProfileContact {
  @example("Email personale")
  label: string;

  @example("mario.rossi@example.com")
  value: string;
}

@example(#{
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
  @example(2154)
  id: integer;

  @example("Mario")
  firstName: string;

  @example("Rossi")
  lastName: string;

  @example("RSSMRA80A01L219K")
  fiscalCode: string;

  @example("Torino")
  birthPlace: string;

  @example(plainDate.fromISO("1980-01-01"))
  birthDate: plainDate;

  /** TODO: Verify the available values and their representation. | Verificare i valori disponibili e la loro rappresentazione. */
  @example("Coniugato/a")
  maritalStatus: string;

  residenceAddress: ProfileAddress;
}

model FacultyTaxData {
  @example("XK238804602955671016")
  iban: string;

  /** Tax domicile address. | Indirizzo del domicilio fiscale. */
  taxDomicileAddress: ProfileAddress;
}

model FacultyPersonalContacts {
  /** Correspondence address. | Indirizzo di recapito. */
  contactAddress: ProfileAddress;

  /** Personal email addresses and phone numbers. | Indirizzi email e numeri di telefono personali. */
  contacts: ProfileContact[];
}

/** TODO: Add the CV once its representation and upload/update mechanism have been defined. Both the CV and the personal website are editable. | Aggiungere il CV dopo averne definito la rappresentazione e il caricamento/aggiornamento. Sia il CV sia la pagina web personale sono modificabili. */
model FacultyPublicData {
  @example("https://example.com/mario-rossi")
  personalWebsiteUrl: string;
}

model FacultyProfile {
  personalData: FacultyPersonalData;
  taxData: FacultyTaxData;
  personalContacts: FacultyPersonalContacts;
  institutionalContacts: InstitutionalProfileContact[];
  publicData: FacultyPublicData;
}

model PaginatedFacultyPublicationList {
  data: FacultyPublication[];

  @example(1)
  page: integer;

  @example(20)
  pageSize: integer;

  @example(42)
  total: integer;
}

/** Only the residence address can be updated. | È modificabile solo l'indirizzo di residenza. */
model FacultyPersonalDataUpdateRequest {
  residenceAddress?: ProfileAddress;
}

model FacultyTaxDataUpdateRequest {
  @example("IT60X0542811101000000123456")
  iban?: string;

  taxDomicileAddress?: ProfileAddress;
}

model FacultyPersonalContactsUpdateRequest {
  contactAddress?: ProfileAddress;

  /** TODO: Confirm whether updating contacts replaces the whole list or addresses individual contacts. | Confermare se l'aggiornamento dei contatti sostituisce l'intero elenco o riguarda singoli contatti. */
  contacts?: ProfileContact[];
}

/** TODO: Define CV updates, possibly through a dedicated upload endpoint. | Definire l'aggiornamento del CV, eventualmente tramite un endpoint di caricamento dedicato. */
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

  @route("/publications")
  @get
  @summary("List faculty publications | Elenca pubblicazioni del docente")
  @doc("Returns the paginated publications of the authenticated faculty member. | Restituisce l'elenco paginato delle pubblicazioni associate al docente autenticato.")
  @opExample(_ex_listFacultyPublications_resp)
  listFacultyPublications(
    @query page?: integer = 1,
    @query pageSize?: integer = 20,
  ): OkResponse<PaginatedFacultyPublicationList> | NotAuthorized | ServerError;

  @route("/courses")
  @get
  @summary("List assigned courses | Elenca corsi assegnati")
  @doc("Returns the courses assigned to the authenticated faculty member. | Restituisce i corsi assegnati al docente autenticato.")
  @opExample(_ex_listAssignedCourses_resp)
  listAssignedCourses(
  ): OkDataResponse<AssignedCourse[]> | NotAuthorized | ServerError;

  @route("/publications/{publicationId}")
  @get
  @summary("Download faculty publication | Scarica pubblicazione")
  @doc("Restituisce un redirect o lo stream del file associato alla pubblicazione indicata.")
  @opExample(_ex_downloadFacultyPublication_resp)
  downloadFacultyPublication(@path publicationId: string):
    | OkResponse<void>
    | RedirectResponse
    | NotAuthorized
    | NotFound
    | ServerError;

  @patch(#{ implicitOptionality: true })
  @summary("Update faculty profile | Aggiorna dati anagrafici del docente")
  @opExample(_ex_updateFacultyProfile_resp)
  updateFacultyProfile(
    @body body: FacultyProfileUpdateRequest,
  ): OkDataResponse<FacultyProfile> | NotAuthorized | BaseErrors;
}
