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

model FacultyProfile {
  @example(2154)
  id: integer;

  @example("Mario")
  firstName: string;

  @example("Rossi")
  lastName: string;

  @example("mario.rossi@example.com")
  personalEmail: string;

  @example("mario.rossi@polito.it")
  academicEmail: string;

  @example("+39 011 090 7654")
  phone: string;

  @example("Torino, Via Roma 1")
  residenceAddress: string;

  /** TODO: Verify whether this means tax domicile or tax residence before confirming the field name. | Verificare se indica il domicilio fiscale o la residenza fiscale prima di confermare la denominazione. */
  @example("Torino, Via Roma 1")
  fiscalResidence: string;

  @example("XK238804602955671016")
  iban: string;

  /** TODO: Verify the department data structure; an acronym will probably also be available. | Verificare la struttura dei dati del dipartimento: probabilmente sarà disponibile anche l’acronimo. */
  @example("Dipartimento di Automatica e Informatica")
  departmentName: string;
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

model FacultyProfileUpdateRequest {
  @example("Torino, Via Garibaldi 10")
  residenceAddress?: string;

  /** TODO: Verify whether this means tax domicile or tax residence before confirming the field name. | Verificare se indica il domicilio fiscale o la residenza fiscale prima di confermare la denominazione. */
  @example("Torino, Via Garibaldi 10")
  fiscalResidence?: string;

  @example("+39 011 090 1234")
  phone?: string;

  @example("mario.rossi@example.com")
  personalEmail?: string;

  @example("mario.rossi@polito.it")
  academicEmail?: string;
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

  @patch(#{ implicitOptionality: true })
  @summary("Update faculty profile | Aggiorna dati anagrafici del docente")
  @opExample(_ex_updateFacultyProfile_resp)
  updateFacultyProfile(
    @body body: FacultyProfileUpdateRequest,
  ): OkDataResponse<FacultyProfile> | NotAuthorized | BaseErrors;

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
}
