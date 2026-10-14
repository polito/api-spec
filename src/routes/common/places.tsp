import "@typespec/http";
import "@typespec/openapi3";

import "../../common.tsp";
import "../../examples/common/places.tsp";

namespace PolitoAPI;

using Http;

@example(_ex_place_category)
model PlaceCategory {
  @example("AULA")
  id: string;

  @example("Aula")
  name: string;

  showInMenu?: boolean;

  @example("lightBlue")
  color?: string = "gray";

  @format("url") markerUrl?: string;

  /** A MapBox style priority number. 0 means most important, larger numbers are less important */
  @example(60)
  priority?: numeric = 100;

  /** If true, markers of this category should be shown initially on the map */
  @example(false)
  highlighted?: boolean;
}

model RootPlaceCategory {
  ...PlaceCategory;
  subCategories?: PlaceCategory[];
}

model PlaceCategoryOverview {
  ...PlaceCategory;
  subCategory?: PlaceCategory;
}

model GeoJsonPolygon {
  type: "Feature";
  geometry: {
    type: "Polygon";
    coordinates: numeric[][][];
  };
}

@example(_ex_geo_json_point)
model GeoJSONPoint {
  @example("Point")
  type: "Point";

  @example(#[45.064254, 7.657823])
  coordinates: numeric[];
}

@example(_ex_geo_json_feature_geometry)
model GeoJSONFeatureGeometry {
  @example("Feature")
  type: "Feature";

  geometry: {
    @example("LineString")
    type: "LineString";

    @example(#[#[7.657823, 45.064254], #[7.658123, 45.064754]])
    coordinates: numeric[][];
  };
  properties: {
    @example("B1")
    bl_id: string;

    @example("F1")
    fn_fl_id: string;
  };
}

@example(_ex_navigation_response_feature)
model NavigationResponseFeature {
  @example("FeatureCollection")
  type: "FeatureCollection";

  startPoint: GeoJSONPoint;
  endPoint: GeoJSONPoint;

  @example(1)
  segmentId: integer;

  isPrivate: boolean;
  features: GeoJSONFeatureGeometry;
}

@example(_ex_navigation_response)
model NavigationResponse {
  @example("FeatureCollection")
  type: "FeatureCollection";

  @example(1240)
  totDistance: numeric;

  @example(2)
  stairsCount: numeric;

  @example(1)
  elevatorsCount: numeric;

  @example(18)
  stepsCount: numeric;

  features: NavigationResponseFeature[];
}

@example(_ex_geo_location)
model GeoLocation {
  @example(45.064254)
  latitude: numeric;

  @example(7.657823)
  longitude: numeric;
}

model Building {
  ...BuildingOverview;
  ...GeoLocation;
}
model BuildingOverview {
  id: string;
  name: string;
  siteId: string;
  category: PlaceCategoryOverview;
  geoJson?: GeoJsonPolygon;
}

model Department {
  id: string;
  name: string | null;
  type: string;
}
model Floor {
  id: string;
  name: string;
  level: numeric;
}

model PlaceOverview {
  ...GeoLocation;
  id: string;
  room: {
    id: string;
    name: string;
  };
  category: PlaceCategoryOverview;
  site: {
    id: string;
    name: string;
  };
  building: BuildingOverview;
  floor: Floor;
  department: Department;
}

model Site {
  id: string;
  name: string;
  ...GeoLocation;
  floors: Floor[];
  city: {
    id: string;
    name: string;
  };

  /** A delta in degrees that applied to the centroid
   * coordinates of the site determines its extent */
  extent: numeric;
}

model FreeRoom {
  ...PlaceRef;
  id?: string;
  freeFrom: utcDateTime;
  freeTo: utcDateTime;
}

model Place {
  ...PlaceOverview;
  geoJson: GeoJsonPolygon;

  @example(300)
  capacity: integer;

  structure: {
    name: string;
    shortName: string;
    email: string | null;
    phone: string | null;
  } | null;
  resources: {
    name: string;
    description: string;
    category: string;
  }[];
}

@tag("Places")
@route("/v2/place-categories")
interface PlaceCategories {
  @get
  @summary("List place categories | Elenca categorie luoghi")
  getPlaceCategories(
    @query siteId?: string,
  ): OkDataResponse<RootPlaceCategory[]> | BaseErrors;
}

@tag("Places")
@route("/v2/sites")
interface Sites {
  @get
  @summary("List sites | Elenca sedi")
  getSites(): OkDataResponse<Site[]> | BaseErrors;

  @route("/{siteId}/free-rooms")
  @get
  @summary("List free rooms | Elenca aule libere")
  getFreeRooms(
    /** Date */
    @query date: string,

    /** Start time */
    @query timeFrom: string,

    /** End time */
    @query timeTo: string,

    @path siteId: string,
  ): OkDataResponse<FreeRoom[]> | BaseErrors;

  @route("/{siteId}/buildings")
  @get
  @summary("List buildings | Elenca edifici")
  getBuildings(
    @path siteId: string,

    /** Filter buildings containing 'search' in their name */
    @query search?: string,

    @query placeCategoryId?: string,
    @query(#{ explode: true }) `placeSubCategoryId[]`?: string[],
  ): OkDataResponse<Building[]> | BaseErrors;
}

@tag("Places")
@route("/v2/places")
interface Places {
  @get
  @summary("Search places | Cerca luoghi")
  getPlaces(
    /** Filter places containing 'search' in their name */
    @query search?: string,

    @query placeCategoryId?: string,
    @query(#{ explode: true }) `placeSubCategoryId[]`?: string[],
    @query siteId?: string,
    @query buildingId?: string,
    @query floorId?: string,
    @query departmentId?: string,
  ): OkDataResponse<PlaceOverview[]> | BaseErrors;

  @get
  @route("/{placeId}")
  @summary("Show place | Mostra luogo")
  getPlace(@path placeId: string): OkDataResponse<Place> | BaseErrors;
}

@tag("Places")
@route("/departments")
interface Departments {
  @get
  @summary("List departments | Elenca dipartimenti")
  @opExample(_ex_getDepartments_resp)
  getDepartments(
    @query siteId?: string,
    @query departmentType?: string,
  ): OkDataResponse<Department[]> | BaseErrors;
}

@tag("Places")
@route("/directions/{startPlaceId}/to/{endPlaceId}")
interface Directions {
  @get
  @summary("Get directions | Ottieni indicazioni")
  getDirections(
    @path startPlaceId: string,
    @path endPlaceId: string,
    @query avoidStairs?: boolean,
    @query usePrivate?: boolean,
  ): OkDataResponse<NavigationResponse> | BaseErrors;
}
