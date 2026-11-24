import "@typespec/http";

using Http;

namespace PolitoAPI;

/* MODELS */

model PlaceRef {
  buildingId: string;
  floorId: string;
  roomId: string;
  siteId: string;
  name: string;
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
