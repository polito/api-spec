import "@typespec/http";

import "./examples/common/identity.tsp";

using Http;

namespace PolitoAPI;

/* MODELS */

/**
 * Kind of user the credentials belong to. Open union: unknown values are
 * accepted as plain strings so new user kinds don't break existing clients.
 */
union IdentityType {
  student: "student",
  faculty: "faculty",
  string,
}

model UpdatePreferencesRequest {
  @example("it")
  language?: "it" | "en";
}

@example(_ex_identity)
model Identity {
  @example("s290683")
  username: string;

  @example(IdentityType.student)
  type: IdentityType;

  @example("5a54f626-4b7e-488e-a0e3-300f54051510")
  clientId: string;

  @example("c679fa38ff665df6a676acd833194385")
  token: string;
}

model Device {
  name?: string;
  platform: string;
  version?: string;
  `model`?: string;
  manufacturer?: string;
  toothPicCompatible: boolean;
}

model ClientVersionRequest {
  @example("1060200")
  buildNumber: string;

  @example("1.6.2")
  appVersion: string;
}

model FcmRegistrationRequest {
  @example("a1b2c3d4e5f6a1b2c3d4e5f6a1b2c3d4")
  fcmRegistrationToken?: string;
}

model Client {
  ...ClientVersionRequest;
  ...FcmRegistrationRequest;

  @example("Students app")
  name: string;

  @example("5a54f626-4b7e-488e-a0e3-300f54051510")
  id?: string;
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
