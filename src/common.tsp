import "@typespec/http";

using Http;

namespace PolitoAPI;

/* MODELS */

model UpdatePreferencesRequest {
  @example("it")
  language?: "it" | "en";
}

enum CourseEnrollmentRole {
  /** A student enrolled in the course, in personal study plan */
  student: "student",

  /** A user who can access the course content, not in the personal study plan */
  viewer: "viewer",

  /** A user who is the teacher of the course */
  teacher: "teacher",

  /** A user who is a collaborator in the course */
  collaborator: "collaborator",
}

model PlaceRef {
  buildingId: string;
  floorId: string;
  roomId: string;
  siteId: string;
  name: string;
}

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

model RelatedVirtualClassroom {
  @example(150157)
  id: integer;

  @example("Lecture 1")
  title: string;
}

model Lecture {
  id: numeric;
  startsAt: utcDateTime;
  endsAt: utcDateTime;
  type: string;
  virtualClassrooms: RelatedVirtualClassroom[];
  description: string | null;
  courseId: integer;
  courseName: string;

  @example(150157)
  teacherId: integer;

  place: PlaceRef;
}

model GuideSection {
  @example("Title")
  title: string;

  @example("HTML content")
  content: string;
}

/* UTILS */

@error
model ErrorResponse {
  code?: integer;
  message?: string;
}

// Reusable response aliases
alias OkResponse<T = null> = {
  @statusCode statusCode: 200;
  @body body: T;
};

alias CreatedResponse<T = null> = {
  @statusCode statusCode: 201;
  @body body: T;
};

alias NoContentResponse = {
  @statusCode statusCode: 204;
};

alias AcceptedResponse<T = null> = {
  @statusCode statusCode: 202;
  @body body: T;
};

alias RedirectResponse = {
  @statusCode statusCode: 302;
};

alias BadRequest = {
  @statusCode statusCode: 400;
  @body body: ErrorResponse;
};

alias NotFound = {
  @statusCode statusCode: 404;
  @body body: ErrorResponse;
};

alias NotAuthorized = {
  @statusCode statusCode: 401;
  @body body: ErrorResponse;
};

alias ServerError = {
  @statusCode statusCode: 500;
  @body body: ErrorResponse;
};

alias OkDataResponse<T> = OkResponse<{
  data: T;
}>;

alias OkDataCreatedResponse<T> = CreatedResponse<{
  data: T;
}>;

alias BaseErrors = BadRequest | ServerError;

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
