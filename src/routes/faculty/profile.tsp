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
  name: string;

  @example("application/pdf")
  mimeType: string;

  @example(2456)
  sizeInKiloBytes: integer;

  @example(utcDateTime.fromISO("2026-03-04T12:27:38.153Z"))
  createdAt: utcDateTime;

  @example("https://example.com/download/pub-001")
  downloadUrl: string;
}

model AssignedCourse {
  @example("02JSKOV")
  courseId: string;

  @example("Human Computer Interaction")
  name: string;

  @example("2025/2026 - Secondo semestre")
  period: string;

  @example(120)
  enrolledCount: integer;
}

model FacultyProfile {
  @example("2154")
  id: string;

  @example("Marco Torchiano")
  name: string;

  @example("marco.torchiano@gmail.com")
  personal_email: string;

  @example("marco.torchiano@polito.it")
  academic_email: string;

  @example("+39 011 090 7654")
  phone: string;

  @example("Torino, Via Roma 1")
  residence: string;

  @example("Torino, Via Roma 1")
  fiscalResidence: string;

  @example("XK238804602955671016")
  iban: string;

  @example("Dipartimento di Automatica e Informatica")
  department: string;

  publications: FacultyPublication[];
  assignedCourses: AssignedCourse[];
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
  residence?: string;

  @example("Torino, Via Garibaldi 10")
  fiscalResidence?: string;

  @example("+39 011 090 1234")
  phone?: string;

  @example("marco.torchiano@gmail.com")
  personal_email?: string;

  @example("marco.torchiano@polito.it")
  academic_email?: string;
}

@tag("Faculty - Profile")
@route("/faculty/me")
interface FacultyProfile_Routes {
  @get
  @summary("Get faculty profile | Profilo docente")
  @doc("Restituisce i dati anagrafici e informativi del docente autenticato (pubblicazioni, corsi assegnati – se disponibili).")
  @opExample(_ex_getFacultyProfile_resp)
  getFacultyProfile(): OkDataResponse<FacultyProfile> | NotAuthorized | ServerError;

  @patch(#{implicitOptionality: true})
  @summary("Update faculty profile | Aggiorna dati anagrafici del docente")
  @opExample(_ex_updateFacultyProfile_resp)
  updateFacultyProfile(
    @body body: FacultyProfileUpdateRequest,
  ): OkDataResponse<FacultyProfile> | NotAuthorized | BaseErrors;

  @route("/publications")
  @get
  @summary("List faculty publications | Elenca pubblicazioni del docente")
  @doc("Restituisce l'elenco paginato delle pubblicazioni associate al docente autenticato.")
  @opExample(_ex_listFacultyPublications_resp)
  listFacultyPublications(
    @query page?: integer = 1,
    @query pageSize?: integer = 20,
  ): OkResponse<PaginatedFacultyPublicationList> | NotAuthorized | ServerError;

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
