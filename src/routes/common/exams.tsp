import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";

using Http;

namespace PolitoAPI;

model ExamBase {
  id: integer;
  courseId: numeric;
  courseShortcode: string;
  courseName: string;
  type: string;
  places?: PlaceRef[];
  bookingEndsAt: utcDateTime;
  examStartsAt: utcDateTime | null;
  examEndsAt: utcDateTime | null;
  bookedCount: integer;
  availableCount: integer;
}
