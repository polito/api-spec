import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";

namespace PolitoAPI;

using Http;

model JobOfferOverview {
  id: numeric;
  title: string;
  location: string;
  companyId: numeric;
  companyName: string;
  createdAtDate: plainDate;
  endsAtDate: plainDate;
}

model JobOffer extends JobOfferOverview {
  companyLocation: string;
  companyMission: string;
  description: string;
  requirements: string;
  contractType: string;
  salary: string;
  contactInformation: string | null;
  url: string | null;
  email: string | null;

  @example(2)
  freePositions: numeric;
}

@tag("Job offers")
@route("/job-offers")
interface JobOffers {
  @get
  @summary("List job offers | Elenca offerte di lavoro")
  getJobOffers(): OkDataResponse<JobOfferOverview[]> | BaseErrors;

  @route("/{jobOfferId}")
  @get
  @summary("Show a job offer | Mostra un'offerta di lavoro")
  getJobOffer(@path jobOfferId: integer): OkDataResponse<JobOffer> | BaseErrors;
}
