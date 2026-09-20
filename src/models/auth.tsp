import "@typespec/http";

import "../examples/common/identity.tsp";

using Http;

namespace PolitoAPI;

/**
 * Kind of user the credentials belong to. Open union: unknown values are
 * accepted as plain strings so new user kinds don't break existing clients.
 */
union IdentityType {
  student: "student",
  faculty: "faculty",
  string,
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

model UpdatePreferencesRequest {
  @example("it")
  language?: "it" | "en";
}
