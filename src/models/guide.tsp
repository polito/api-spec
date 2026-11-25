import "@typespec/http";

using Http;

namespace PolitoAPI;

model GuideSection {
  @example("Title")
  title: string;

  @example("HTML content")
  content: string;
}
