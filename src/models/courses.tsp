import "@typespec/http";

import "./places.tsp";

using Http;

namespace PolitoAPI;

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
