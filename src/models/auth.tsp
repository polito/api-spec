import "@typespec/http";

using Http;

namespace PolitoAPI;

model UpdatePreferencesRequest {
  @example("it")
  language?: "it" | "en";
}
