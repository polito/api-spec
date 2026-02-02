import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/news.tsp";

namespace PolitoAPI;

using Http;

@example(_ex_news_item_overview)
model NewsItemOverview {
  @example(123)
  id: numeric;

  @example("Partecipazione, co-progettazione e impatto sociale. Sfide e opportunità per l'inclusione sociale")
  title: string;

  @example(false)
  isEvent: boolean;

  @example("Seminario di presentazione del progetto")
  shortDescription: string;

  @example("Dal 30 agosto 2023")
  eventStartTime: string | null;

  @example("Al 30 agosto 2023")
  eventEndTime: string | null;

  @example(utcDateTime.fromISO("2022-08-31T14:00:00Z"))
  createdAt: utcDateTime;
}

@example(_ex_news_item_extra)
model NewsItemExtra {
  @example("https://")
  url: string;

  @example("Bando")
  description: string;

  @example("image")
  type: "link" | "file" | "image";

  @example(305)
  sizeInKiloBytes: integer | null;
}

@example(_ex_news_item)
model NewsItem extends NewsItemOverview {
  @example("Energy Center - Via Paolo Borsellino 38, Torino")
  location: string;

  @example("Martedì <strong>18 aprile 2023 - </strong>presso l'<strong>Auditorium dell'Energy Center del Politecnico</strong>...")
  htmlContent: string;

  extras: NewsItemExtra[];
}

@tag("News")
@route("/news")
interface News {
  @get
  @summary("List news | Lista news")
  getNews(): OkDataResponse<NewsItemOverview[]> | BaseErrors;

  @route("/{newsItemId}")
  @get
  @summary("Show news | Mostra news")
  getNewsItem(@path newsItemId: numeric): OkDataResponse<NewsItem> | BaseErrors;
}
