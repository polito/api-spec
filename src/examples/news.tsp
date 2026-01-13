import "@typespec/http";

using Http;

namespace PolitoAPI;

const _ex_news_item_overview = #{
  id: 123,
  title: "Partecipazione, co-progettazione e impatto sociale. Sfide e opportunità per l'inclusione sociale",
  isEvent: false,
  shortDescription: "Seminario di presentazione del progetto",
  eventStartTime: "Dal 30 agosto 2023",
  eventEndTime: "Al 30 agosto 2023",
  createdAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
};

const _ex_news_item = #{
  id: 123,
  title: "Partecipazione, co-progettazione e impatto sociale. Sfide e opportunità per l'inclusione sociale",
  isEvent: false,
  shortDescription: "Seminario di presentazione del progetto",
  eventStartTime: "Dal 30 agosto 2023",
  eventEndTime: "Al 30 agosto 2023",
  createdAt: utcDateTime.fromISO("2022-08-31T14:00:00Z"),
  location: "Energy Center - Via Paolo Borsellino 38, Torino",
  htmlContent: "Martedì <strong>18 aprile 2023 - </strong>presso l'<strong>Auditorium dell'Energy Center del Politecnico</strong>...",
  extras: #[
    #{
      url: "https://",
      description: "Bando",
      type: "image",
      sizeInKiloBytes: 305,
    }
  ],
};

const _ex_news_item_extra = #{
  url: "https://",
  description: "Bando",
  type: "image",
  sizeInKiloBytes: 305,
};
