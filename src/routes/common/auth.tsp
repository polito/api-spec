import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/auth.tsp";

using Http;
using OpenAPI;

namespace PolitoAPI;

@example(_ex_identity)
model Identity {
  @example("s290683")
  username: string;

  @example("student")
  type: string;

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
}

model UpdateInfo {
  suggestUpdate: boolean;
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

model LoginRequestBase {
  client?: Client;
  device?: Device;
  preferences: UpdatePreferencesRequest;
}

model LoginCredentialsBasic extends LoginRequestBase {
  @example("s290683")
  username: string;

  @example("moreSecret")
  password: string;

  loginType: "basic";
}

model LoginCredentialsSSO extends LoginRequestBase {
  @example("123456-1234-5678-123456")
  uid: string;

  @example("abcdef-abcd-efgh-abcdef")
  key: string;

  loginType: "sso";
}

@oneOf
@discriminated(#{ envelope: "none", discriminatorPropertyName: "loginType" })
union LoginRequest {
  basic: LoginCredentialsBasic,
  sso: LoginCredentialsSSO,
}

@example(_ex_switchCareer_req)
model SwitchCareerRequest {
  @example("s290683")
  username: string;

  client?: Client;
  device?: Device;
}

@example(_ex_validateMfa_req)
model ValidateMfaRequest {
  @example("EDUP000123456")
  serial: string;

  @example("65ba9e0e5aac421a9150991638a9d697")
  nonce: string;

  @example("83e08d9fc4be3de046318eb3c2c9ae4ede1374a5423a1487b92febc70d106994")
  signature: string;

  @example(false)
  decline?: boolean;
}

model MfaChallenge {
  @example("EDUP000123456")
  serial: string;

  @example("dGhpcyBzaG91bGQgYmUgYW4gZWNkcyBwdWJsaWMga2V5Li4uIHdoYXQgZGlkIHlvdSB0aGluayB0aGlzIHdhcz8hIPCfp5AK")
  challenge: string;

  @example(utcDateTime.fromISO("2025-01-01T00:00:00Z"))
  requestTs: utcDateTime;

  @example(utcDateTime.fromISO("2025-01-01T01:00:00Z"))
  expirationTs: utcDateTime;
}

model MfaStatusResponse {
  /** Current MFA status for the user */
  status: "active" | "locked" | "available" | "unavailable" | "needsReauth";

  /** Additional information about the MFA session.
   * Present only if status is `active` or `locked` */
  details: {
    @example(utcDateTime.fromISO("2021-09-30T00:00:00Z"))
    lastAuth: utcDateTime;

    @example(1)
    authCount: integer;

    @example("EDUP0000123456")
    serial?: string;

    @example("My phone")
    description?: string;
  } | null;
}

model LinkToService {
  url: string;
}

model AppInfoRequest {
  ...ClientVersionRequest;
  ...FcmRegistrationRequest;
}

@tag("Auth")
@route("/auth")
interface Auth {
  @post
  @route("/login")
  @summary("Login")
  @useAuth(NoAuth)
  login(@body body: LoginRequest): OkDataResponse<Identity> | BaseErrors;

  @post
  @route("/switch-career")
  @summary("Switch career | Cambia carriera")
  switchCareer(
    @body body: SwitchCareerRequest,
  ): OkDataResponse<Identity> | BaseErrors;

  /** Invalidates the provided token */
  @delete
  @route("/logout")
  @summary("Logout")
  logout(): NoContentResponse | BaseErrors;

  @patch(#{ implicitOptionality: true })
  @route("/client")
  @summary("Update client version fields | Aggiorna i campi di versione del client")
  appInfo(@body body: AppInfoRequest): OkDataResponse<UpdateInfo> | BaseErrors;
}

@example(_ex_enrolMfa_req)
model EnrolMfaRequest {
  @example("some identifier you chose")
  description: string;

  @example("dGhpcyBzaG91bGQgYmUgYW4gZWNkcyBwdWJsaWMga2V5Li4uIHdoYXQgZGlkIHlvdSB0aGluayB0aGlzIHdhcz8hIPCfp5AK")
  pubkey: string;
}

@tag("Auth")
@route("/auth/mfa")
interface Mfa {
  @post
  @route("/enrol")
  @summary("Enroll a new PUSH token")
  @opExample(_ex_enrolMfa_resp)
  enrolMfa(@body body: EnrolMfaRequest): OkDataCreatedResponse<{
    @example("EDUP000123456")
    serial: string;
  }> | BaseErrors;

  @post
  @route("/validate")
  @summary("Validate a challenge")
  @opExample(_ex_validateMfa_resp)
  validateMfa(@body body: ValidateMfaRequest): OkDataResponse<{
    @example(true)
    success: boolean;
  }> | BaseErrors;

  @get
  @route("/challenge")
  @summary("Fetch pending challenge")
  @opExample(_ex_fetchChallenge_resp)
  fetchChallenge(): OkDataResponse<MfaChallenge | null> | BaseErrors;

  @route("/status")
  @get
  @summary("Get MFA status for the current user")
  getMfaStatus(): OkDataResponse<MfaStatusResponse> | BaseErrors;
}

@tag("Auth")
@route("/auth/serviceLink")
interface ServiceLink {
  @get
  @route("/moodle/{course}")
  @summary("Get authorised service link for Moodle course")
  getMoodleLink(
    /** Moodle course identifier */
    @path course: integer,
  ): OkDataResponse<LinkToService> | BaseErrors;

  @get
  @route("/liveClass/{meetingID}")
  @summary("Get authorised service link for LiveClass meeting")
  getLiveClassLink(
    /** LiveClass meeting identifier */
    @path meetingID: string,
  ): OkDataResponse<LinkToService> | BaseErrors;

  @get
  @route("/mail")
  @summary("Get authorised service link for Mail")
  getMailLink(): OkDataResponse<LinkToService> | BaseErrors;
}
