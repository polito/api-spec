import "@typespec/http";

using Http;

namespace PolitoAPI;

model PlaceRef {
  buildingId: string;
  floorId: string;
  roomId: string;
  siteId: string;
  name: string;
}
