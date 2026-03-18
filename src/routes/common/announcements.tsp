import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/announcements.tsp";

namespace PolitoAPI;

using Http;

enum AnnouncementScope {
  onboarding: "onboarding",
  appInfo: "appInfo",
}

@example(_ex_announcement)
model Announcement {
  @example("abc-123")
  id: string;

  @example("Welcome to the app")
  title: string;

  @example("Here is a quick guide to get started.")
  contents: string;

  @example("Onboarding announcement")
  description?: string;

  @example(AnnouncementScope.onboarding)
  scope: AnnouncementScope;

  @example(false)
  seen: boolean;

  @example(utcDateTime.fromISO("2026-01-01T12:00:00Z"))
  date: utcDateTime;

  @example("https://example.com/announcement-cover.jpg")
  cover?: string;
}

@tag("Announcements")
@route("/announcements")
interface Announcements {
  @get
  @summary("List announcements | Lista annunci")
  @opExample(_ex_getAnnouncements_resp)
  getAnnouncements(
    @query new?: boolean,
  ): OkDataResponse<Announcement[]> | BaseErrors;

  @route("/{announcementId}/read")
  @put
  @summary("Mark announcement as read | Segna annuncio come letto")
  markAnnouncementAsRead(
    @path announcementId: string,
  ): NoContentResponse | BaseErrors;
}
