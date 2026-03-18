import "@typespec/http";

namespace PolitoAPI;

const _ex_announcement = #{
  id: "abc-123",
  title: "Welcome to the app",
  contents: "Here is a quick guide to get started.",
  description: "Onboarding announcement",
  scope: AnnouncementScope.onboarding,
  seen: false,
  date: utcDateTime.fromISO("2026-01-01T12:00:00Z"),
};

const _ex_getAnnouncements_resp = #{
  returnType: #{
    statusCode: 200,
    body: #{
      data: #[
        #{
          id: "abc-123",
          title: "Welcome to the app",
          contents: "Here is a quick guide to get started.",
          description: "Onboarding announcement",
          scope: AnnouncementScope.onboarding,
          seen: false,
          date: utcDateTime.fromISO("2026-01-01T12:00:00Z"),
        },
        #{
          id: "def-456",
          title: "New feature available",
          contents: "Check out the new booking system.",
          scope: AnnouncementScope.appInfo,
          seen: true,
          date: utcDateTime.fromISO("2026-02-15T09:30:00Z"),
        }
      ],
    },
  },
};
