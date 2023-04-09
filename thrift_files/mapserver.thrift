include "licensecommon.thrift"
include "dispatchCommon.thrift"
namespace cpp dispatch.server.mapserver
namespace java dispatch.server.mapserver

exception MapServerError {
	1: string message,
}

struct AddressInfoIt {
	1: string info,
	2: dispatchCommon.GeoPoint position,
	3: string key,
}

struct FindNearestObject {
	1: string label,
	2: string number,
	3: string street,
	4: string city
	5: dispatchCommon.GeoPoint point,
}

typedef list<dispatchCommon.GeoPoint> GeoPolyline

struct RouteData {
	1: dispatchCommon.GeoPoint src,
	2: dispatchCommon.GeoPoint dst,
	3: double length,
	4: i32 time,
	5: GeoPolyline points,
}

enum VehicleType {
	Pedestrian = 0,
	Bicycle    = 1,
	CarOrMoto  = 2,
	Taxi       = 3,
	Bus        = 4,
	Emergency  = 5,
	Delivery   = 6,
	Truck      = 7
}

struct TruckExtendedParameters {
	1: optional i32 totalWeightKg,
	2: optional i32 axleWeightKg,
	3: optional double widthMeters,
	4: optional double heightMeters,
	5: optional double lengthMeters,
}

struct StreetPolylines {
	1: dispatchCommon.Address street,
	2: list<GeoPolyline> polylines,
}

struct AddressPoint {
	1: list<dispatchCommon.Address> address,
	2: optional dispatchCommon.GeoPoint point,
}

struct SpeedLimitsByCellsRequest {
	1: list<dispatchCommon.GeoRect> cells,
}

typedef list<AddressInfoIt> AddrInfoList
typedef list<dispatchCommon.GeoPoint> WaypointList
typedef list<RouteData> RouteDataList

service MapServices {
	licensecommon.ClientId getId(
		1:licensecommon.ClientId clientId
	) throws (1:licensecommon.InvalidOperation e),
	AddrInfoList getCountries(1:licensecommon.ClientAuthData auth, 2:string mask) throws (1:licensecommon.InvalidOperation e),
	AddrInfoList getCities(1:licensecommon.ClientAuthData auth, 2:AddressInfoIt country, 3:string mask, 4:i32 limit) throws (1:licensecommon.InvalidOperation e),
	AddrInfoList getStreets(1:licensecommon.ClientAuthData auth, 2:AddressInfoIt city, 3:string mask, 4:i32 limit) throws (1:licensecommon.InvalidOperation e),
	AddrInfoList getBuildings(1:licensecommon.ClientAuthData auth, 2:AddressInfoIt street, 3:string mask, 4:i32 limit) throws (1:licensecommon.InvalidOperation e),

	FindNearestObject findNearestQuery(1:licensecommon.ClientAuthData auth, 2:dispatchCommon.GeoPoint point, 3:string lang) throws (1:licensecommon.InvalidOperation e),

	RouteDataList buildRoute(1:licensecommon.ClientAuthData auth, 2:WaypointList waypoints, 3:i32 vehicleType) throws (1:licensecommon.InvalidOperation e),
	RouteDataList buildRouteWithJams(1:licensecommon.ClientAuthData auth, 2:WaypointList waypoints, 3:i32 vehicleType) throws (1:licensecommon.InvalidOperation e),
	RouteDataList buildRouteWithParams(1:licensecommon.ClientAuthData auth, 2:WaypointList waypoints, 3:i32 vehicleType, 4:bool useJams, 5:TruckExtendedParameters params) throws (1:licensecommon.InvalidOperation e),

	list<dispatchCommon.Address> nearestAddressQuery(1:licensecommon.ClientAuthData auth, 2:dispatchCommon.GeoPoint point) throws (1:licensecommon.InvalidOperation e),
	list<list<dispatchCommon.Address>> nearestAddressQueryGroup(1:licensecommon.ClientAuthData auth, 2:list<dispatchCommon.GeoPoint> points) throws (1:licensecommon.InvalidOperation e),

	AddressPoint nearestAddressQueryEx(1:licensecommon.ClientAuthData auth, 2:dispatchCommon.GeoPoint point) throws (1:licensecommon.InvalidOperation e),
	list<AddressPoint> nearestAddressQueryGroupEx(1:licensecommon.ClientAuthData auth, 2:list<dispatchCommon.GeoPoint> points) throws (1:licensecommon.InvalidOperation e),

	list<byte> getSpeedLimits(1:licensecommon.ClientAuthData auth, 2:list<dispatchCommon.GeoPoint> points) throws (1:licensecommon.InvalidOperation e),
	list<byte> getSpeedLimitsByCells(1:licensecommon.ClientAuthData auth, 2:SpeedLimitsByCellsRequest request) throws (1:licensecommon.InvalidOperation e),

	list<dispatchCommon.Address> getCompleteAddress(1:licensecommon.ClientAuthData auth, 2:AddressInfoIt info) throws (1:licensecommon.InvalidOperation e),
	StreetPolylines getStreetPolylines(1:licensecommon.ClientAuthData auth, 2:dispatchCommon.Address street, 3:i16 langId) throws (1:licensecommon.InvalidOperation e),

	list<list<dispatchCommon.Address>> nearestStreetQueryGroup(1:licensecommon.ClientAuthData auth, 2:list<dispatchCommon.GeoPoint> points) throws (1:licensecommon.InvalidOperation e),
	list<AddressPoint> nearestStreetQueryGroupEx(1:licensecommon.ClientAuthData auth, 2:list<dispatchCommon.GeoPoint> points) throws (1:licensecommon.InvalidOperation e),
}
