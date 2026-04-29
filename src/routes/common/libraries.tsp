import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";

using Http;

namespace PolitoAPI;

model LibraryContact {
  @example("Mario Rossi")
  name: string | null;

  @example("011 090 1234")
  phone: string | null;

  @example("biblioteca.centrale@polito.it")
  email: string | null;
}

model LibraryOverview {
  @example("BIBLIOTECA CENTRALE")
  id: string;

  @example("Biblioteca Centrale")
  name: string;

  @example("Servizi della Biblioteca Centrale")
  description: string;

  place: PlaceRef;
}

model Library {
  ...LibraryOverview;
  openingHours: OpeningHours[];
  contact: LibraryContact;
}

enum LoanItemType {
  book: "book",
  magazine: "magazine",
  dvd: "dvd",
  thesis: "thesis",
  eResource: "e_resource",
  other: "other",
}

enum LoanStatus {
  active: "active",
  expiring: "expiring",
  expired: "expired",
}

model LoanOverview {
  id: string;
  type: LoanItemType;

  @example("Il piccolo principe e la sua principessa")
  title: string;

  status: LoanStatus;

  @example(utcDateTime.fromISO("2026-05-15T00:00:00Z"))
  expiresAt: utcDateTime;
}

enum LoanConsultationType {
  online: "online",
  paper: "paper",
  onSite: "on_site",
}

model Loan {
  ...LoanOverview;

  @example(#["Antoine de Saint-Exupéry"])
  authors: string[];

  @example(1943)
  publicationYear: integer | null;

  consultationType: LoanConsultationType;

  @example("9791256860364")
  isbn: string | null;

  @example("Il Foglio Letterario Edizioni")
  publisher: string | null;

  library: LibraryOverview;

  @example(utcDateTime.fromISO("2025-04-12T00:00:00Z"))
  borrowedAt: utcDateTime;

  renewable: boolean;
}

model LibraryLinks {
  @format("url")
  loanRequestUrl: string;

  @format("url")
  catalogUrl: string;
}

model LibraryCatalog {
  id: string;

  @example("PICO")
  title: string;

  @example("Un motore di ricerca per trovare documenti di interesse in tutte le collezioni.")
  description: string;

  @format("url")
  url: string;
}

enum ElectronicResourceCategory {
  database: "database",
  journal: "journal",
  ebook: "ebook",
}

model ElectronicResource {
  id: string;

  @example("AIDA")
  title: string;

  @format("url")
  url: string;
}

model LibraryResourcesPage {
  catalogs: LibraryCatalog[];
}

model ElectronicResourcesPage {
  accessNotice: string;
  resources: ElectronicResource[];
}

@tag("Libraries")
@route("/libraries")
interface Libraries {
  /**
   * Lists the university libraries in minimal view (id, title,
   * description, place reference). Used by the "Libraries" listing
   * page.
   */
  @get
  @summary("List libraries | Elenca biblioteche")
  getLibraries(): OkDataResponse<LibraryOverview[]> | BaseErrors;

  /**
   * Returns the full detail of a specific library, including opening
   * hours and contact information of the referent.
   */
  @get
  @route("/{libraryId}")
  @summary("Show library | Mostra biblioteca")
  getLibrary(@path libraryId: string): OkDataResponse<Library> | BaseErrors;

  /**
   * Returns the external links shown in the libraries section: Pico
   * portal to request a loan and the university catalog. Exposed from
   * the backend so they can be updated without a new app release.
   */
  @get
  @route("/external-links")
  @summary("Get library links | Ottieni link biblioteche")
  getLibraryLinks(): OkDataResponse<LibraryLinks> | BaseErrors;

  /**
   * Returns the content of the "Resources" page: list of university
   * catalogs (PICO, Polidigita, Webthesis, etc.). Navigation entries
   * to the electronic resources sub-pages (databases, journals,
   * e-books) are hardcoded on the app side.
   */
  @get
  @route("/resources")
  @summary("Get library resources page | Pagina risorse")
  getLibraryResources(): OkDataResponse<LibraryResourcesPage> | BaseErrors;

  /**
   * Lists the electronic resources subscribed to in a specific
   * category (databases, journals, e-books) together with the access
   * notice to be shown at the top of the page.
   */
  @get
  @route("/resources/electronic/{category}")
  @summary("List electronic resources | Elenca risorse elettroniche")
  getElectronicResources(
    @path category: ElectronicResourceCategory,
  ): OkDataResponse<ElectronicResourcesPage> | BaseErrors;
}

@tag("Libraries")
@route("/library-loans")
interface LibraryLoans {
  /**
   * Lists the authenticated user's loans in minimal view (title,
   * type, status, expiry date). Filtering by status
   * (active/expiring/expired) is performed on the client side.
   */
  @get
  @summary("List my loans | Elenca i miei prestiti")
  getMyLoans(): OkDataResponse<LoanOverview[]> | BaseErrors;

  /**
   * Returns the detail of a loan: authors, publication year, ISBN,
   * publisher, consultation type, reference library, request and
   * expiry dates, and the renewable flag.
   */
  @get
  @route("/{loanId}")
  @summary("Show loan | Mostra prestito")
  getLoan(@path loanId: string): OkDataResponse<Loan> | BaseErrors;

  /**
   * Renews an active loan, extending its expiry date. Returns the
   * updated loan. Available only when `renewable` is true on the
   * loan detail.
   */
  @put
  @route("/{loanId}/renew")
  @summary("Renew loan | Rinnova prestito")
  renewLoan(@path loanId: string): NoContentResponse | NotFound | BaseErrors;
}
