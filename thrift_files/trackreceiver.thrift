include "dispatchCommon.thrift"
include "dispatchEventType.thrift"

namespace cpp dispatch.server.trackreceiver2

exception TrackreceiverError {
	1: string message,
}

struct TimeblockInterval {
	1: i32 fromTimestamp,
	2: i32 toTimestamp,
}

struct TileId {
	1: i32 zoom,
	2: i32 x,
	3: i32 y,
}

enum TrackPointType {position, stop, start}

struct GeoPoint {
	1: double lon,
	2: double lat,
}

struct Size {
	1: i32 width,
	2: i32 height,
}

struct TinyUuid {
	1: i64 hi,
	2: i64 lo,
}

struct Address {
	1: string country,
	2: string region,
	3: string parish,
	4: string city,
	5: string district,
	6: string street,
	7: string building,
}

struct SensorTriggerState {
	1: string sensor,
	2: i64 timestamp,
	3: bool isOnRecent,
}

typedef list<SensorTriggerState> SensorActuations

struct TinyTrackPoint {
	1: i64 capturedTimestamp,
	2: GeoPoint point,
}

struct TrackPointData {
	1: string staticId,
	2: i64 capturedTimestamp,
	3: GeoPoint point,
	4: double speed,
	5: double direction,
	6: i32 satelliteCount,
	7: optional binary plainData,
	8: optional Address address,
	9: optional bool usedPreviousCoords,
	10: optional SensorActuations sensorActuations,
	11: optional TinyTrackPoint lastValidPoint, // only for 'recentPoints*' requests
}

struct TrackPoint {
	1: i32 x,
	2: i32 y,
	3: i64 capturedTimestamp,
	4: double speedKmH,
	5: optional TrackPointType type = TrackPointType.position,
	6: optional bool isRecent,
	7: optional i32 color,
}

typedef list<TrackPoint> TrackSegment
typedef list<dispatchCommon.ChartPoint> ChartSegment

struct TileBuilderCachePoint {
	1: GeoPoint point,
	2: i64 capturedTimestamp,
	3: double speed,
	4: i32 flag, // = LodBlockFlag
	5: i32 color,
	6: i16 colorPriority,
}

struct TileCacheEntry {
	1: list<TrackSegment> segments,
}

struct Viewport {
	1: Size size, // pixels
	2: i32 zoom, // zoom number
	3: GeoPoint hotPoint, // Point of Earth displayed in the center
}

enum ChartEventCurveId {
	Trip
}

struct ChartCurveId {
	// Only one of following fields is and must be set
	1: optional string positionFieldName,
	2: optional dispatchCommon.ChartPositionCustomFieldId positionCustomFieldId,
	3: optional i32 fuelingCurveTankId,
	4: optional ChartEventCurveId eventCurveId,
}

struct ChartCurve {
	1: ChartCurveId id,
	2: list<ChartSegment> segments,
}

enum VehicleParam {
	ignition,
	//gps_navigation,
		lat_deg,
		lon_deg,
		speed_kmh
		direction_deg,
		hdop,
		satellite_count,
		altitude_m,
	//gsm_info,
		mcc,
		mnc,
		lac,
		cellid,
		signal_strength,
		timing_advance,
	//device_info,
		external_power_mv,
		battery_power_mv,
		temperature_c,
		acceleration_x_ms2,
		acceleration_y_ms2,
		acceleration_z_ms2,
		alarm_on,
		external_power_on,
	//fms_data,
		coolant_temp_c,
		engine_rpm,
		engine_load_percent,
		fuel_percent,
		mileage_km,
		total_fuel_consumed_l,
	//can_data,
		can_log_version,
		mhours,
		can_fuel_l,
		can_speed_kmh,
	//traffic_info,
		in_chunk_size,
		in_package_count,
		out_chunk_size,
		out_package_count,
	fuel_l,
	analog_input,
	digital_input,
	can_input,
	pulse_counter_pcs,
	frequency_hz,
	axle_load_kg,
	event,
	one_wire_input,
	sensor_input,
	voltage_mv,
	//eco_info,
		max_speed_kmh,
		over_speed_timer_s,
		rpm_red_timer_s,
		rpm_green_dist_km,
		max_rpm,
		brake_count,
		harsh_acceleration_count,
		extreme_braking_count,
		harsh_braking_count,
		cornering_count,
		idling_timer_s,
		normal_speed_dist_km,
		cornering_value_ms2,
		driving_acceleration_ms2,
	odometer,
	custom_temperatures_c,
	tamper,
	movement,
	programming_cable_connected,
	battery_charging,
	battery_supply_present,
	external_battary_failure,
	remote_programming_activated,
	deep_sleep_mode,
	fix,
	lock_state,
	firmware_version,
	navitag_status,
	battery_charge_pcnt,
	internal_battery_failure,
	accuracy_m,
	coordinates_source,
	hardware_version,
	roaming,
	sim_slot,
	total_load_kg,
	fuel_rate_lh,
	distance_to_service_km,
	accelerator_pedal_percents,
	brake_pedal_percents,
	distance_from_prev_point,
	tracker_gnss_odometer_m,
	max_positive_acceleration_module_ms2,
	max_negative_acceleration_module_ms2,
	max_rotational_acceleration_degs2,
	network_registration,
	time_synchronization,
	gsm_modem_on,
	doors_opening_sensor,
	passengers_counter,
	max_positive_acceleration_x_ms2,
	max_negative_acceleration_x_ms2,
	max_positive_acceleration_y_ms2,
	max_negative_acceleration_y_ms2,
	max_positive_acceleration_z_ms2,
	max_negative_acceleration_z_ms2,
	last
}

struct SpeedingInterval {
	1:i64 beginTimestamp,
	2:i64 endTimestamp,
}

struct SpeedingProperties {
	1:optional double maxSpeed_kmh,
	2:optional double avgSpeed_kmh,
	3:optional double trackLength_m,
}

struct NearestVehicle {
	1:TinyUuid staticId,
	2:GeoPoint coordinates,
}

struct RecentPositionFilter {
	1:optional i32 actualitySeconds,
	2:optional dispatchCommon.GeoRect rectangle,
}

struct FencesChunks {
	1:list<TinyUuid> fences,
	2:binary chunks,
	3:list<TinyUuid> stillInsideFences,
}

struct TrackColumn {
	1:string key,
	2:bool is_custom,
	3:bool is_required,
}

enum TrackColumnFilterType {And, Or}
enum TrackColumnFilterConditionType {Less, Greater, Equal, LessOrEqual, GreaterOrEqual, NotEqual}

struct TrackColumnFilterCondition {
	1:TrackColumnFilterConditionType type,
	2: optional string value,
}

struct TrackColumnFilter {
	1:TrackColumnFilterType type,
	2:list<TrackColumnFilterCondition> conditions,
}

struct LastMaintenanceDoneEvent {
	1:TinyUuid maintenanceScheduleStaticId,
	2:optional i64 timestamp,
	3:optional double mileageKm,
}

struct MaintenanceDoneEvent {
	1:TinyUuid maintenanceScheduleStaticId,
	2:optional i64 timestamp,
	3:optional i64 scheduledTimestamp,
	4:optional double mileageKm,
	5:optional double scheduledMileageKm,
}

struct RoadAccidentEvent {
	/* uuid */
	1: string accidentId,
	2: string vin,
	3: i64 capturedTimestamp,
	4: dispatchCommon.GeoPoint coordinates,
	5: optional bool crashSevere,
	6: optional dispatchCommon.RoadAccidentAddress address,
	7: optional string location
}

enum MileageSource {fromCoordinates, fromSensor}

struct AccelerationCalibration {
	1:optional double roll,
	2:optional double pitch,
	3:optional double yaw,
}

struct StreetChunks {
	1:dispatchCommon.Address street,
	2:binary chunks,
}

struct StreetPassingStatistics {
	1:i64 fromTimestamp,
	2:i64 toTimestamp,
	3:optional string streetName,
	4:optional double maxSpeed_kmh,
	5:optional double avgSpeed_kmh,
	6:double trackLength_m,
}

struct GetMileageParams {
	1:string vehicleStaticId,
	2:MileageSource source,
}

struct TripPointShift {
	1:string tripPointId,
	// at least one of must be set
	2:optional i64 newArrivalTimestamp,
	3:optional i64 newDepartureTimestamp,
}

struct AbortedTimestampChange {
	1:optional i64 abortedTimestamp,
}

struct Message {
	1:binary data,
}

struct TileRequest {
	1:i32 timeBlockId,
	2:TileId tileId,
}

enum StatusFlags {
	ChangesAcceptorConnected = 1,
}

enum EventRegenerateClass {
	SensorAlarm,
	GeoFenceEnterLeave
	GeoFenceSpeedingSensor
	DelayInGeofence
	StartStopActiveInactive
	Fuel
	Speeding
	SpeedingOnRoad
	SpeedingPenalty
}

struct EventRegenerateParams {
	1: TinyUuid vehicleStaticid,
	2: i64 fromTimestamp,
	3: bool dispatchNotification,
	4: bool regenerateGaugesOnly,
	5: list<EventRegenerateClass> eventRegenerateClasses
}

struct TripEvent {
	1:TinyUuid tripId,
	2:optional TinyUuid vehicleId,
	3:binary eventInfo, // сериализованный EventInfo, пока через SlightlyMoreCompactSimpleProtocol
	4:i64 sequenceId, // трекрисивер возвращает seq-id из события, tr2-router возращает свою нумерацию
	5:optional i32 tripPointSeqId, // для событий по точке рейса
} 

struct EventByIdParams {
	1: string eventId,
	2: TinyUuid vehicleStaticId,
	3: i64 capturedTimestamp,
}

struct SerializedEvent {
	1: string eventId,
	2: TinyUuid vehicleStaticId,
	3: string vehicleName,
	4: TinyUuid groupId,
	5: binary event, // Serialized QVariantMap
}

struct SendOperatorEmailData {
	1: string email,
	2: string title,
	3: string message,
	4: optional i64 fromTimestamp,
	5: optional i64 toTimestamp,
}

struct VehicleEventReactionUser {
	1: string login,
	2: string welcomeName,
}

struct VehicleEventReaction {
	1: i64 time,
	2: string comment,
	3: optional VehicleEventReactionUser user,
}

struct VehicleEventScreenMessage {
	1: string message,
	2: bool isReal,
}

struct VehicleEvent {
	1: TinyUuid vehicleId,
	8: string eventId,
	2: binary eventInfo, // EventInfo serialized via SlightlyMoreCompactSimpleProtocol
	3: i64 sequenceId, // trackriver returns seq-id from event, tr2-router use own numbering
	4: bool reactionRequired,
	5: optional VehicleEventScreenMessage screenMessage,
	6: optional VehicleEventReaction reaction,
	7: optional string driverName,
	9: optional i64 pairDuration,
}

struct VehicleEvents {
	1: TinyUuid vehicleId,
	2: string vehicleName,
	3: TinyUuid groupId,
	4: string groupTitle,
	5: optional string eventgenerator_settings_json,
	6: optional double mileage,
	7: list<VehicleEvent> events,
}

struct UserEvent {
	1:binary event,
	2:i64 sequenceId,
}

service Trackreceiver {
	list<TrackSegment> tiles(1:string vehicleStaticId, 2:i32 timeblock, 3:TileId tile) throws(1:TrackreceiverError err),
	list<list<TrackSegment>> tilesMassive(
		1:string vehicleStaticId,
		2:list<TileRequest> tileRequests
	) throws(1:TrackreceiverError err),

	list<ChartCurve> charts(
		1:string vehicleStaticId,
		2:TimeblockInterval interval,
		3:i32 zoom,
		4:list<ChartCurveId> curveIds,
	) throws(1:TrackreceiverError err),

	list<string> chartCompatiblePositionFields(
	) throws(1:TrackreceiverError err),

	binary vehiclesInfos(
		1:list<string> vehicleStaticIds,
		2:i64 timestamp,
		3:i64 params /* Bitset  (1 << VehicleParam) */
	) throws(1:TrackreceiverError err),

	list<TrackPointData> recentPoints(1: list<string> vehicleStaticIds, 2: i16 langId),
	list<TrackPointData> recentPointsFast(1: list<string> vehicleStaticIds),
	TrackPointData pointByTimestamp(1: string vehicleStaticId, 2:i64 timestamp),
	double getMileage(1: string vehicleStaticId, 2: MileageSource source),
	list<double> getMileages(1: list<GetMileageParams> params),

	AccelerationCalibration getVehicleAutoAccelerationCalibration(1:string vehicleStaticId) throws(1:TrackreceiverError err),

	// returns serialized QVariantList
	binary recentPositionGrid(
		1: Viewport viewport,
		2: Size groupingSize,
		3: list<TinyUuid> vehicleIds,
		4: list<TinyUuid> excludeVehicleIds,
	),

	list<NearestVehicle> findNearestVehiclesWithCommand(
		1: GeoPoint coordinates,
		2: string commandIdName,
		3: i32 numberToSearch,
		4: string roleId,
		5: list<string> rootGroupIds,
	),

	// returns serialized QVariantMap
	binary trackDetails(
		1:string vehicleStaticid,
		2:i64 beginTimeStamp,
		3:i64 endTimeStamp,
		4:bool desc,
		5:i64 limit,
		6:i64 offset,
		7:list<TrackColumn> columns,
		8:map<string, TrackColumnFilter> filters
	) throws(1:TrackreceiverError err),

	// returns serialized QVariantMap
	binary trackGroupedDetails(
		1:string vehicleStaticid,
		2:i64 beginTimeStamp,
		3:i64 endTimeStamp,
		4:bool desc,
		5:i64 limit,
		6:i64 offset,
		7:list<TrackColumn> analog, // is_required not used
		8:list<TrackColumn> digital // is_required not used
	) throws(1:TrackreceiverError err),

	// returns geofence as WKT
	binary buildBufferByTrack(
		1:string vehicleStaticid,
		2:i64 beginTimeStamp,
		3:i64 endTimeStamp,
		4:double width,
		5:double simplifyFactor
	) throws(1:TrackreceiverError err),

	binary doorReport(
		1:list<string> vehicleStaticids,
		2:i64 beginTimeStamp,
		3:i64 endTimeStamp,
		4:bool desc,
		5:i16 langId,
	) throws(1:TrackreceiverError err),

	i64 positionIndex(
		1:i64 positionCapturedTimeStamp
		2:string vehicleStaticid,
		3:i64 beginTimeStamp,
		4:i64 endTimeStamp,
		5:bool desc,
		6:map<string, TrackColumnFilter> filters
	) throws(1:TrackreceiverError err),

	i64 positionGroupedIndex(
		1:i64 positionCapturedTimeStamp
		2:string vehicleStaticid,
		3:i64 beginTimeStamp,
		4:i64 endTimeStamp,
		5:bool desc
	) throws(1:TrackreceiverError err),

	// returns serialized QVariantMap
	binary trackEvents(
		1:string vehicleStaticid,
		2:i64 beginTimeStamp,
		3:i64 endTimeStamp,
		4:i64 limit,
		5:i64 offset,
	) throws(1:TrackreceiverError err),

	list<LastMaintenanceDoneEvent> getLastMaintenanceDoneEvents(
		1:string vehicleStaticId
	) throws(1:TrackreceiverError err),

	void registerMaintenanceDoneEvent(
		1:string vehicleStaticId,
		3:MaintenanceDoneEvent event,
	) throws(1:TrackreceiverError err),

	void registerRoadAccidentEvent(
		1:string vehicleStaticId,
		3:RoadAccidentEvent event,
	) throws(1:TrackreceiverError err),

	void cancelTrip(1: string tripId, 2: string userStaticId) throws(1:TrackreceiverError err),
	void shiftTripPoints(
		1:string tripId,
		2:string userStaticId,
		3:list<TripPointShift> pointShifts
		4:AbortedTimestampChange abortedTimestampChange,
	) throws(1:TrackreceiverError err),

	// Get ready LOD blocks or calculate on demand
	list<binary> getBlockData(
		1:string deviceId,
		2:i32 serviceId,
		3:i64 blockIdBegin,
		4:i64 blockIdEnd
	) throws(1:TrackreceiverError err),

	list<SpeedingProperties> getSpeedingProperties(1: string vehicleStaticId, 2: list<SpeedingInterval> intervals),

	list<StreetPassingStatistics> getStreetsPassingReport(
		1: string vehicleStaticId,
		2: i64 fromTimestamp,
		3: i64 toTimestamp,
		4: i16 langId,
	) throws(1:TrackreceiverError err),


	/*
	 *
	 * Subscribe to selected vehicles for existing and incoming messages.
	 * Return value is relaying session id which should be used for retrieving messages.
	 *
	 * @param requests - vehicle static ids and starting received_timestamp for each vehicle. Note: timestamp is inclusive.
	 *   Note: non-accessible and non-existing vehicles are silently filtered out.
	 * @param messageLimit - limit for messages for each vehicle
	 * @param columns - selected columns
	 *
	 */
	dispatchCommon.RelaySession startRelayingVehicles(
		1: list<dispatchCommon.VehicleRelayTrackRequest> requests,
		2: dispatchCommon.PositionRequestFields columns,
		3: i32 messageLimit,
	) throws (
		1: TrackreceiverError err,
		2: dispatchCommon.RelaySessionError rse,
	),

	/*
	 *
	 * Return collected messages for relaying session.
	 * Note: function waits until at least 1 vehicle have data to send
	 * Note: messages for each vehicle are sorted by increasing received_timestamp
	 *
	 * @param relaySession - relaying session
	 *
	*/
	list<dispatchCommon.Track> getRelayingTracks(
		1: dispatchCommon.RelayingTracksRequest request
	) throws (
		1: TrackreceiverError err,
		2: dispatchCommon.RelaySessionError rse,
	),

	/*
	 *
	 * Return recent points for selected vehicles.
	 * Note: messages for each vehicle are sorted by increasing captured_timestamp.
	 *
	 * @param requests - vehicle static ids and captured_timestamp range for each vehicle
	 *   Note: timestamp has open right border.
	 * @param messageLimit - limit for messages for each vehicle
	 * @param columns - selected columns
	 *
	 */
	list<dispatchCommon.Track> getVehiclesTracks(
		1: list<dispatchCommon.VehicleHistoryTrackRequest> requests,
		2: dispatchCommon.PositionRequestFields columns,
		3: i32 messageLimit,
	) throws (1:TrackreceiverError err),

	/*
	 *
	 * Returns bounding rects of recent points for selected vehicles.
	 *
	 * @param requests - vehicle static ids and captured_timestamp range for each vehicle
	 *   Note: timestamp has open right border.
	 *
	 */
	list<dispatchCommon.GeoRect> getVehiclesTracksRects(
		1: list<dispatchCommon.VehicleHistoryTrackRequest> requests,
	) throws (1:TrackreceiverError err),

	/*
	 *
	 * Return message history for selected vehicle sorted ascending by captured_timestamp.
	 *
	 * @param request - vehicle static id and captured_timestamp range
	 * Note: timestamp has open right border.
	 * @param columns - selected columns (lat_deg lon_deg must be present)
	 * @param viewport - viewport to clip and simplify track
	 * @param useTrackSplitting - if true uses additional track splitting by time between points and movement speed
	 */

	list<dispatchCommon.Track> getClippedVehicleTrack(
		1: dispatchCommon.VehicleHistoryTrackRequest request,
		2: dispatchCommon.PositionRequestFields columns,
		3: dispatchCommon.Viewport viewport,
		4: bool useAdditionalTrackSplitting,
	) throws (1:TrackreceiverError err),

	list<dispatchCommon.PositionWithVehicle> getRecentPositions(
		1: list<TinyUuid> vehicleUuids,
		2: dispatchCommon.PositionRequestFields columns,
		3: RecentPositionFilter filter,
		4: bool gpsPositionIsNecessary
	) throws (1:TrackreceiverError err),

	list<dispatchCommon.PositionWithColumns> getRecentPositionsWithAllColumns(
		1: list<TinyUuid> vehicleUuids,
		2: RecentPositionFilter filter,
		3: bool gpsPositionIsNecessary
	) throws (1:TrackreceiverError err),

	i32 getRecentPositionsCount(
		1: list<TinyUuid> vehicleUuids,
		2: TinyUuid fenceDataId,
		3: i32 actualitySeconds,
	) throws (1:TrackreceiverError err),

	list<FencesChunks> getInsideFencesReportChunks(
		1: string deviceId,
		2: list<TinyUuid> fenceIds,
		3: i64 beginTimeStamp,
		4: i64 endTimeStamp,
		5: bool separateByEachFenceInOut,
	) throws (1:TrackreceiverError err),

	list<StreetChunks> getStreetsReportChunks(
		1: string deviceId,
		2: list<dispatchCommon.Address> streets,
		3: i64 beginTimeStamp,
		4: i64 endTimeStamp,
		5: i16 langId,
		6: double width,
		7: double simplifyFactor,
	) throws (1:TrackreceiverError err),

	Message getLastMessage(
		1: string vehicleStaticId,
		2: i64 beginTimestamp,
		3: i64 endTimestamp,
	) throws (1:TrackreceiverError err),

	/*
	 * Returns status bits from StatusFlags enum
	 */
	i64 getStatusFlags(),

	void addEventsRegenerationTask(
		1: list<EventRegenerateParams> params,
	) throws (1:TrackreceiverError err),

	i64 getMaxEventSequenceId(),

	list<VehicleEvent> getEventsSince(
		1: list<TinyUuid> vehicleUuids,
		2: i64 fromTimeStamp,
		3: i64 minSeqId,
		4: i32 limit,
		5: i64 maxSeqId,
	) throws (1:TrackreceiverError err),

	list<SerializedEvent> getEventsByIds(
		1: list<EventByIdParams> events,
	) throws (1:TrackreceiverError err),

	void addReaction(
		1: TinyUuid userStaticId,
		2: list<EventByIdParams> events,
		3: string comment,
	) throws (1:TrackreceiverError err),

	void takeOnControl(
		1: TinyUuid userStaticId,
		2: list<EventByIdParams> events,
	) throws (1:TrackreceiverError err),

	SendOperatorEmailData getOperatorEmailData(
		1: list<EventByIdParams> events,
	) throws (1:TrackreceiverError err),

	/*
	 * Return list of serialized events.
	 *
	 * @param portionFetchRequest - serialized PortionFetchRequest
	 */
	list<binary> reactionRequiredFiltered(
		1: list<TinyUuid> userRootGroupsUuids,
		2: list<TinyUuid> vehicleUuids,
		3: binary portionFetchRequest,
	) throws (1:TrackreceiverError err),

	binary similarReactionRequired(
		1: TinyUuid vehicleStaticId,
		2: TinyUuid userStaticId,
		3: i32 eventType,
		4: i64 beginTimestamp,
		5: i64 endTimestamp,
	) throws (1:TrackreceiverError err),

	binary groupedEvents(
		1: TinyUuid vehicleStaticId,
		2: TinyUuid userStaticId,
		3: i64 beginTimestamp,
		4: i64 endTimestamp,
		5: Viewport viewport,
		6: Size groupingSize,
	) throws (1:TrackreceiverError err),

	binary groupedTripEvents(
		1: TinyUuid tripId,
		2: i64 beginTimestamp,
		3: i64 endTimestamp,
		4: Viewport viewport,
		5: Size groupingSize,
	) throws (1:TrackreceiverError err),

	/*
	 * Return list of serialized events.
	 *
	 * @param portionFetchRequest - serialized PortionFetchRequest
	 */
	list<binary> trackEventsPortion(
		1: TinyUuid vehicleStaticId,
		2: i64 beginTimestamp,
		3: i64 endTimestamp,
		4: bool onlyEnabled,
		5: binary portionFetchRequest,
	) throws (1:TrackreceiverError err),

	list<VehicleEvents> getEvents(
		1: list<TinyUuid> vehicleStaticIds,
		2: i64 beginTimestamp,
		3: i64 endTimestamp,
		4: list<i64> typeFilter, // if empty then all types
	) throws (1:TrackreceiverError err),

	/*
	 * Return list of EventInfo serialized via SlightlyMoreCompactSimpleProtocol.
	 */
	list<binary> tripEvents(
		1: list<string> tripStaticIds, // if empty then any
		2: list<string> tripPointStaticIds, // if empty then any
		3: list<i64> typeFilter, // if empty then all types
	) throws (1:TrackreceiverError err),

	/*
	 * Return list of serialized events.
	 */
	list<binary> tripEventsWithVehicles(
		1: list<string> tripStaticIds,
		2: list<TinyUuid> userRootGroupsUuids,
		3: list<i64> typeFilter, // if empty then all types
	) throws (1:TrackreceiverError err),

	list<TripEvent> getTripEvents(
		1: list<TinyUuid> tripUuids,
		2: list<dispatchEventType.EventType> eventTypes,
		3: i64 minSeqId,
		5: i64 maxSeqId,
	) throws (1:TrackreceiverError err),

	list <UserEvent> currentUserEventsFiltered(
		1: TinyUuid userId,
		2: list<TinyUuid> parentGroups,
		3: list<i64> sequenceIds,
		4: i64 toTime,
		6: i64 maxSeqId,
	) throws (1:TrackreceiverError err),

	list <UserEvent> currentUserEvents(
		1: TinyUuid userId,
		2: list<TinyUuid> parentGroups,
		4: i64 fromTime,
		5: i64 limit,
		6: i64 maxSeqId,
	) throws (1:TrackreceiverError err),

	list <UserEvent> currentUserActionRequiredEvents(
		1: TinyUuid userId,
		2: list<TinyUuid> parentGroups,
		3: i64 limit,
		4: i64 maxSeqId,
	) throws (1:TrackreceiverError err),
}
