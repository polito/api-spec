import "@typespec/http";

import "../../common.tsp";

using Http;

namespace PolitoAPI;

const _ex_announcement = #{
  id: "abc-123",
  title: "Welcome to the app",
  contents: "Here is a quick guide to get started.",
  description: "Onboarding announcement",
  scope: AnnouncementScope.onboarding,
  seen: false,
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
        },
        #{
          id: "def-456",
          title: "New feature available",
          contents: "Check out the new booking system.",
          scope: AnnouncementScope.appInfo,
          seen: true,
        }
      ],
    },
  },
};
