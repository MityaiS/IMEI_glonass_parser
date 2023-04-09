namespace cpp dispatch.common
namespace java dispatch.common
namespace py dispatch.common

struct PositionRequestFields {
	1: list<string> columns, // predefined columns
	2: list<string> customColumns, // custom user columns
	/*
	 *  Valid predefined column names:
	 *  received_timestamp - unix timestamp of message received by tracker server
	 *  captured_timestamp - unix timestamp of message creation on the tracker
	 *  lat_deg, lon_deg - latitude/longitude in degrees
	 *  speed_kmh - actual speed
	 *  direction_deg - north-based azimuth in degrees
	 *  hdop - horizontal dilution of precision
	 *  satellite_count - satellites used for position calculation
	 *
	 */
}

typedef PositionRequestFields PositionFields


// Only one should be valid.
struct Variant {
	1:optional i32 i32Value,
	2:optional i64 i64Value,
	3:optional bool boolValue,
	4:optional double doubleValue,
	5:optional string stringValue,
}

struct Position {
	1: list<Variant> values,
	2: list<Variant> customValues,
	3: optional string sensorKey,
}

struct PositionWithVehicle {
	1: Position position,
	2: string vehicleUuid,
}

struct PositionWithColumns {
	1: Position position,
	2: PositionFields columns,
	3: string vehicleUuid,
}

struct Track {
	1: list<Position> positions,
	2: string vehicleUuid,
	3: bool limited, // Message limit reached for this vehicle.
}

struct VehicleRelayTrackRequest {
	1: string vehicleUuid,
	2: i64 fromTimestamp, // Starting received_timestamp for vehicle. Note: inclusive.
}

struct VehicleHistoryTrackRequest {
	1: string vehicleUuid,
	2: i64 fromTimestamp, // starting captured_timestamp for vehicle. Note: inclusive
	3: i64 toTimestamp, // ending captured_timestamp. Note: exclusive
	4: optional bool includeTrackSensors, // include track sensors information into Position, false by default
}

struct VehicleHistoryTrackGroupedDetailsRequest {
	1: string vehicleUuid,
	2: i64 fromTimestamp, // starting captured_timestamp for vehicle. Note: inclusive
	3: i64 toTimestamp, // ending captured_timestamp. Note: exclusive
	4: bool desc, // sort in descending order
	5: optional i32 limit,
	6: optional i32 offset,
	7: optional PositionRequestFields columns,
}

struct VehicleHistoryTrackGroupedDetailsResponse {
	1: list<string> columns,
	2: list<list<Variant>> valueRows,
}

struct TripTrackRequest {
	1: string tripId,
	2: i64 fromTimestamp, // starting captured_timestamp for vehicle. Note: inclusive
	3: i64 toTimestamp, // ending captured_timestamp. Note: inclusive
}

struct GeoPoint {
	1: double lon,
	2: double lat,
}

struct GeoRect {
	1: GeoPoint topLeft,
	2: GeoPoint rightBottom,
}

struct Viewport {
	1: i32 height; // Height of viewport in pixels
	2: i32 width;  // Width of viewport in pixels
	3: i32 zoom;   // Zoom number from 3 (minimal zoom) to 18 (maximal zoom)
	4: GeoPoint hotPoint; // Point of Earth displayed in the center
}

struct Polyline {
	1: list<GeoPoint> points,
}

struct ClippedPolyline {
	1: list<Polyline> polylines,
}

struct Address {
	1: i16 langId,
	2: string country,
	3: string region,
	4: string parish,
	5: string city,
	6: string district,
	7: string street,
	8: string building,
}

struct RelaySession {
	1: string uuid,
}

struct RelayingTracksRequest {
	1: RelaySession relaySession,
	/** How long request can wait data, if not set - default value is used, if 0 - return nothing on no data */
	2: optional i64 waitTimeoutSeconds,
}

exception RelaySessionError {
	1: string message, //error info for debug
}

struct ChartPoint {
	1: i64 capturedTimestamp,
	2: double val,
}

struct ChartCurve {
	1: list<ChartPoint> points,
}

struct ChartPositionCustomFieldId {
	1: string fieldName,
	2: string sensor, // empty if it's very custom sensor
}

struct ChartCurveId {
	// Only one of following fields is and must be set
	1: optional string positionFieldName,
	2: optional ChartPositionCustomFieldId positionCustomFieldId,
}

struct RoadAccidentAddress {
	1: string region,
	2: optional string settlement,
	3: optional string street,
	4: optional string building
}
