include "dispatchCommon.thrift"
include "dispatchEventType.thrift"
include "SensorType.thrift"

namespace cpp dispatch.server.thrift.backend
namespace java dispatch.server.thrift.backend
namespace py dispatch.server.thrift.backend

/*---------------------------------------------------------------
  Errors
---------------------------------------------------------------*/

// error type API

// incorrect request format/invalid input args, args validation error
exception BadRequest {
	1: string message, //error info for debug
}

// internal server error
exception InternalServerError {
	1: string message, //error info for debug
}

// overloaded server
exception Busy {
	1: string message, //error info for debug
}

// session is wrong or expired
exception Unauthorized {
	1: string message, //error info for debug
}

// user try to execute operation unacceptable for user's role
exception AccessDenied {
	1: string message, //error info for debug
}

// object does not found
exception ObjectNotFound {
	1: string message, //error info for debug
}

exception UserLicenseExpired {
	1: string message, //error info for debug
}

exception TrialIsNotActivated {
	1: string message, //error info for debug
}

exception LoginAlreadyExists {
	1: string message, //error info for debug
}

exception LoginFailed {
	1: string message, //error info for debug
}

exception TrackerAlreadyUsed {
	1: string message, //error info for debug
}

exception ObjectIdMustBeEmptyOnObjectCreation {
	1: string message, //error info for debug
}

/*---------------------------------------------------------------
  End Errors
---------------------------------------------------------------*/

enum FilterType {
	AND = 0,
	OR = 1
}

enum ExtensionForStoreType {
	Company = 0,
	Vehicle = 1,
	Driver = 2,
	Geofence = 3,
	Trip = 4,
}

struct StoreField {
	1: string id,
	2: string title,
	3: string description,
	4: bool inherited, //readonly flag
}

/** Only one should be valid */
struct StoreSchemeId {
	1: optional string id,
	2: optional ExtensionForStoreType extensionFor,
}

struct StoreScheme {
	1: StoreSchemeId id,
	2: string parentGroupId, //uuid
	3: string name,
	4: string description,
	/** readonly uuid, scheme id which was inherited */
	5: optional string inheritId,
	/** list with scheme fields, list<StoreField> */
	6: list<StoreField> fields,
}

struct StoreFieldValue {
	1: string title,
	2: optional string value,
}

struct AdditionalFields {
	/** list with field values */
	1: list<StoreFieldValue> data,
}

struct Session {
	1: string id, //uuid
}

struct License {
	1: optional i64 expire, //unix time
	2: optional i32 monitoringObjectsLimit,
	3: optional i32 usersLimit,
	4: optional i32 smsLimit,
	5: optional bool enabled,
}

struct Group {
	1: string parentGroupId, //uuid
	2: string id, //uuid
	3: string title, //not empty
	4: optional License license,
	5: optional AdditionalFields additionalFields,
}

struct Permission {
	1: string name,
	2: i64 mask,
}

struct Role {
	1: string parentGroupId, //uuid
	2: string id, //uuid
	3: string name, //not empty
	4: list<Permission> extensionPermissions,
}

struct User {
	1: string parentGroupId, //uuid
	2: string id, //uuid
	3: string roleId, //role id, uuid
	4: list<string> groupLink, //visible groups, uuid list
	5: string login, //user login, not empty
	6: optional string welcomeName, //user welcome name
	7: optional string email,// user email
	8: optional string phone,// user phone
	9: bool enabled,
}

struct UserSecurityData {
	1: string userId,
	2: string data1,
	3: string data2
}

struct UserFilter {
	1: optional string groupId,
	2: optional bool recursive,
	4: optional string login,
	5: optional string email,
	6: optional string phone,
	7: optional string welcomeName,
}

struct UserFilterOptionalParams {
	1: optional FilterType type,
	2: optional i32 offset,
	3: optional i32 limit,
}

enum TrackerStatus {
	InstallationDone = 0,
	CheckDone = 1,
	IdentificationDone = 2,
	RequiredAutoIndentification = 3,
	AutoIdentificationDone = 4
}

struct TrackerStatusChange {
	1: i64 timestamp,
	2: TrackerStatus status,
}

struct Tracker {
	1: string vendor, //not empty
	2: string model, //not empty
	3: list<string> identifier, // imei or id or imei/id or empty for stub tracker
	4: optional string phoneNumber,
}

struct TrackerCertificate {
	1: string monitoringObjectId,
	2: string certificateJson
}

struct MonitoringObject {
	1: string parentGroupId, //uuid
	2: string id, //uuid
	3: string name, //not empty
	4: Tracker tracker,
	5: optional string displayColor,
	6: optional string displayIcon,
	7: optional AdditionalFields additionalFields,
	8: optional string vin,
	9: optional string displayIconUuid,
	10: optional string displayIconFormat,
	11: optional string mapIconUuid,
	12: optional string mapIconFormat,
	13: optional string description
}

struct DataRelevanceFilter {
	1: string period, // ISO 8601 period specification, e.g PT1M for 1 minute
	2: bool newer, // data must be newer or older than the specified time period
}

struct MonitoringObjectFilter {
	1: optional string groupId,
	2: optional bool recursive,
	3: optional string name,
	4: optional string imei,
	5: optional AdditionalFields additionalFields,
	6: optional string vin,
	7: optional DataRelevanceFilter capturedTimestamp,
	8: optional DataRelevanceFilter receivedTimestamp,
	9: optional string geofenceId,
}

/** Иконка объекта мониторинга (в списке или на карте) */
struct MonitoringObjectIcon {
	/** UUID иконки */
	1: string id,
	/** Двоичный массив данных изображения */
	2: binary icon,
	/** Строка формата: 'png', 'svg' и так далее */
	3: string format,
}

/** Фильтр иконок объектов мониторинга */
struct MonitoringObjectIconFilter {
	/** список UUID иконок */
	1: list<string> iconUuids,
}

struct CompanyStatistics {
	/** UUID компании */
	1: string uuid,
	/** количество sms отправленных за период. */
	2: optional i32 smsCount,
	/**  максимальное количество объектов мониторинга за период. */
	3: optional i32 vehiclesCount,
}

struct SensorId {
	1: optional SensorType.SensorType type, // if not set, then customId must be set
	2: optional string index, // for "indexed" sensors like: LoadAxle3 = {type = LoadAxle, index = 3}
	3: optional string customId, // for custom sensors (defined by expression)
}

struct SensorValue {
	1: SensorId sensorId,
	2: optional i64 value_integer,
	3: optional double value_double,
	4: optional bool value_boolean,
	5: optional string value_string,
}

struct RoadAccidentEventParameters {
	/* uuid */
	1: string accidentId,
	2: string vin,
	3: i64 capturedTimestamp,
	4: dispatchCommon.GeoPoint coordinates,
	5: optional bool crashSevere,
	6: optional dispatchCommon.RoadAccidentAddress address,
	7: optional string location
}

struct EventAdditionalInfo {
	/** duration for paired events */
	1: optional i32 pairDuration,
	/** fence name */
	2: optional string fenceName,
	/** route name */
	3: optional string routeName,
	/** current speed in kilometers per hour */
	4: optional i16 speed,
	/** speed limit if any, in kilometers per hour */
	5: optional i16 speedLimit,
	/** maximal speed on the track between paired events */
	6: optional i16 maxSpeed,
	/** direction in degrees */
	7: optional i16 direction,
	/** amount of fuel pumped in, in liters */
	8: optional i16 fuelingAmount,
	/** amount of fuel drained, in liters */
	9: optional i16 drainedAmount,
	/** acceleration */
	10: optional i16 accelerarion,
	/** turn angle, in degrees */
	11: optional i16 turnAngle,
	/** accident information */
	12: optional RoadAccidentEventParameters accidentInfo,
}

struct MonitoringObjectEvent {
	/** monitoring object UUID*/
	1: string monitoringObjectUuid,
	/** event UUID*/
	2: string uuid,
	/** event unix time*/
	3: i64 capturedTime,
	/** event type*/
	4: dispatchEventType.EventType type,
	/** event position*/
	5: optional dispatchCommon.GeoPoint position,
	/** global monotonic event index */
	6: optional i64 globalMonotonicIndex,
	/** event rule id triggered the event */
	7: optional string eventRuleId,
	/** values of the sensors when event occured */
	8: optional list<SensorValue> sensorsValues,
	/** values of the sensors when delayed event registered */
	9: optional list<SensorValue> sensorsValuesAtRegistration,
	/** UUID of a geofence bound to the event if applicable */
	10: optional string geofenceId,
	/** Optional event additional properties */
	11: optional EventAdditionalInfo additionalFields
	/** Event rule name triggered the event */
	12: optional string eventRuleName;
}

struct TripEvent {
	/* event data */
	1: MonitoringObjectEvent event,
	/* trip id */
	2: string uuid,
	/* global monotonic event index */
	3: i64 globalMonotonicIndex, // deprecated, see MonitoringObjectEvent
	/* TripStage seqNo */
	4: optional i32 tripStageSeqNo,
	/* object speed when event occured, km/h */
	5: optional double speed,
	/* object direction when event occured, clockwise degrees from north */
	6: optional double direction,
}

struct Command {
	/** parent monitoring object UUID, not empty */
	1: string parentMonitoringObjectId,
	/** command UUID, not empty */
	2: string id,
	/** command name, not empty */
	3: string name,
	/** command description */
	4: optional string commandDescription,
}

enum CommandStatusCode {
	InProgress = 0,
	Done = 1,
	Error = 2,
	TimeOut = 3,
}

struct CommandStatus {
	/** command launch id, not empty */
	1:i64 launchId,
	/** command Uuid, not empty */
	2:string commandId,
	/** command status, not empty */
	3:CommandStatusCode status,
	/** command execute start time, not empty, unix time */
	4:i64 startTime,
	/** command status description */
	5:string commandStatusDescription,
}

struct RelayOptionalParams {
	1: optional bool egtsUseOID, //used only in egts relay
	2: optional string egtsProtocolVersion, //used only in egts relay
	3: optional string wialonPassword, //used only in wialon relay
	4: optional i32 port, //unnecessary in olympstroy
	5: optional string yandexClid, //used only in yandex relay
	6: optional string egtsLogin, //used only in egts relay
	7: optional string egtsPassword, //used only in egts relay
	8: optional i32 egtsDispatcherId, //used only in egts relay
	9: optional string yandexRouteSourceType, //used only in yandex relay, 'trip', 'fence', 'additional_field'
	10: optional string yandexRouteSourceAdditionalField, //used only in yandex relay and for route source 'additional_field'
}

struct Relay {
	1: string id, //uuid
	2: string parentGroupId, //uuid
	3: string title, //not empty
	4: string protocol, //not empty, one of "egts", "granit06", "kurs", "magicsystems", "olympstroy", "scoutopen", "transnavi", "wialonIPS", "can_way", "sodch", "yandex"
	5: bool enabled,
	6: list<string> monitoringObjectsIds, //list of uuid-s
	7: string host,
	8: optional RelayOptionalParams optionalParams,
}

struct Geofence {
	/** uuid, not empty */
	1: string id,
	/** uuid, not empty */
	2: string parentGroupId,
	/** not empty */
	3: string title,
	4: string color,
}

struct Place {
	/**  uuid, not empty */
	1: string id,
	/** uuid, not empty  */
	2: string parentGroupId,
	/** not empty */
	3: string title,
	4: dispatchCommon.GeoPoint position,
}

enum RouteControlMethod {
	RouteStage = 1,
	RouteStageAndLine = 2,
}

enum VehicleRoutingType {
	CarOrMoto = 2,
	Taxi = 3,
	Bus = 4,
	Emergency = 5,
	Delivery = 6,
	Truck = 7,
}

enum RouteStageType {
	CorrectionPoint = 1,
	WayPoint = 2,
	Places = 3,
	Geofences = 4,
}

struct SegmentPlan {
	1: i32 seconds,
	2: i32 meters,
}

struct RouteStage {
	1: optional string id,
	2: RouteStageType type,
	/**  stage coordinates for all types except Places */
	3: optional dispatchCommon.GeoPoint point,
	/**  uuids of place for Places type of RouteStage */
	4: optional list<string> places,
	/**  uuids of geofences for Geofences type of RouteStage */
	5: optional list<string> geofences,
}

struct RouteStageSet {
	1: list<RouteStage> routeStages,
}

struct Route {
	/** uuid, not empty */
	1: string id,
	/** uuid, not empty */
	2: string parentGroupId,
	/** not empty */
	3: string title,
	/** free format, not empty */
	4: string color,
	/** not empty, free format */
	6: double corridorWidth,
	7: RouteControlMethod routeControlMethod,
	8: VehicleRoutingType vehicleRoutingType,
	9: list<RouteStageSet> routeStageSets,
}

struct SegmentPlanSet {
	1: list<SegmentPlan> plan, // for all stages except the first
}

struct RouteInfo {
	1: Route route,
	2: list<SegmentPlanSet> segmentsPlanSets,
}

struct RouteGeometry {
	1: list<SegmentPlan> segmentsPlan, // for all stages except the first
	2: dispatchCommon.ClippedPolyline routeLine,
}

struct Timepoint {
	1: i64 value, // in seconds; can be UTC-value, can reprecents day's relative value, etc
	2: string timezone, // for example "UTC+07:00"
}

struct GeofenceCondition {
	1: list<string> geofenceIds,
	2: optional i32 speedlimit, // for speeding-in-geofence events
	3: optional Timepoint timepoint, // for delayed-in-geofence events, uses day's relative value
}

enum SensorConditionType {
	greater = 1,
	less = 2,
	greaterOrEqual = 3,
	lessOrEqual = 4,
	inside = 5, // borders are included
	outside = 6, // borders are not included
	on = 7,
	off = 8,
	unset = 9,
}

struct SensorCondition {
	1: SensorId sensorId,
	2: SensorConditionType conditionType,
	3: optional double value, // also used as 'from'-value if interval
	4: optional double toValue, // interval case
	5: optional bool ignoreNull
}

/**
 * Condition to make rule's events generated.
 * Fields existance depends on (correlates with) generated event type. Can have no fields at all.
 */
struct GenerateEventsCondition {
	1: optional GeofenceCondition geofenceCondition,
	2: optional SensorCondition sensorCondition,
	3: optional double distanceCondition, // f.e. for distance-in-group events, in meters
	4: optional i64 connectTimeoutCondition, // in minutes
	5: optional i64 durationCondition, // for paired events: must be bigger to generate the pair, in seconds
	6: optional i64 generateAfterTimestamp,
	7: optional bool durationOnlyByTrack
}

struct ScheduleInterval {
	1: bool enabled,
	2: i32 left,
	3: i32 right,
}

struct ScheduleCondition {
	1: byte weekDaysMask, // 0th bit is monday, 7th bit is not used
	2: optional list<ScheduleInterval> scheduleIntervals,
	3: string timezone, // for example "UTC+07:00"
}

enum BoundaryCondition {
	beginOnly,
	endOnly,
	both,
}

/**
 * Condition to make rule's actions applied (when events condition is satisfied).
 * At least one field must present; field(s) existance depends on (correlates with) event type.
 */
struct ApplyActionsCondition {
	1: bool enabled,
	2: optional i32 autoDisableAfter,
	3: optional BoundaryCondition boundaryCondition, // required if events generating condition semantics has boundaries
	4: optional ScheduleCondition scheduleCondition, // no condition means satisfied
}

/** Description of the notification */
struct Notification {
	1: bool userReactionRequired,
	2: bool showOnScreen,
	3: string locale,
	4: optional list<string> emailAddresses,
	5: optional list<string> smsPhoneNumbers,
	6: optional string screenTemplate, // used default template if not set
	7: optional string emailBodyTemplate, // used default template if not set
	8: optional string smsBodyTemplate, // used default template if not set
}

/** Command to send to tracker */
struct TrackerCommand {
	1: string name, // command name, not empty
	2: string roleId, // describes permissions
}

/** Actions to execute when all conditions satisfied */
struct EventsRuleActions {
	1: optional Notification notification, // there is no notifications by default
	2: optional string newGroupId, // action: move affected monitoring object to new group
	3: optional list<TrackerCommand> commandsToSend, // action: send commands to affected monitoring object's tracker
}

/** Rule to generate events */
struct EventsRule {
	1: string parentGroupId, // uuid
	2: string id, // uuid
	3: string title,
	4: list<string> monitoringObjectIds, // uuids, not empty
	5: list<GenerateEventsCondition> eventsConditions, // condition(s) to make rule's events generated
	6: optional bool eventsConditionsAreDisjunctive, // false means conjunctive conditions
	7: dispatchEventType.EventType generatedEventType, // type of events to be generated
	8: optional ApplyActionsCondition actionsCondition, // additional condition (when events generated) to make rule's actions applied
	9: optional EventsRuleActions actions, // actions to execute when all conditions are satisfied
}

/**
 * Structure specifies the geofence, the addresses and
 * event types filter for sending notifications
 * if the event occurred in the geofence
 */
struct TripGeofenceNotification {
	1: string geofence, // uuid
	2: list<string> emailAddresses, // email is sent for event occured in geofence
	3: list<string> smsPhoneNumbers, // sms is sent for event occured in geofence
	4: list<dispatchEventType.EventType> filter, // notify for these events, if empty then for all
}

/**
 * Structure specifies trip notification parameters
 */
struct TripNotification {
	1: string messageTemplate = "Object: {{device}}, Type: {{event}}",
	2: bool showOnScreen = false,
	3: list<string> emailAddresses, // e-mail addresses for unconditional notification
	4: list<string> smsPhoneNumbers, // sms numbers for unconditional notification
	5: i32 disconnectMinutes = 120, //min 15
	6: i32 unscheduledStopMinutes = 30, //min 15
	7: i32 absenceFromTripMinutes = 20, //min 1
	8: i32 soonTripEndKm = 30, //min 1, max 100
	9: list<TripGeofenceNotification> geofenceNotifications, // address information for conditional notification
	10: bool emailOperatorControl, // do not send emails immediately, only after operator reaction on event, has no sense without 'reactionRequiredEventTypes'
	11: list<dispatchEventType.EventType> reactionRequiredEventTypes,
}

struct TripStage {
	1: string routeStageId, // uuid
	2: i64 arrivalUnixTime,
	3: i32 arrivalToleranceSeconds,
	4: i64 departureUnixTime
	5: i32 departureToleranceSeconds,
	6: i32 seqNo,
	7: optional bool optionalControl,
}

enum TripStatus {
	planned = 0,
	started = 1,
	ended = 4,
	aborted = 5,
	canceled = 6,
}

struct TripStageSet {
	1: list<TripStage> tripStages,
}

struct Trip {
	1: string id,
	2: TripStatus status,
	3: string vehicleId, // uuid
	4: string routeId, // uuid
	5: list<TripStageSet> tripStageSets,
	6: i64 startTripUnixTime,
	7: i64 abortTripUnixTime,
	8: TripNotification notificationParams,
	9: optional AdditionalFields additionalFields,
}

/** Filtering info for address info service*/
struct AddressFilterInfo {
	/** Symbol mask for search */
	1: string mask,
	/** Limits the number of results returned by search*/
	2: i32 limit,
}

/** Context for continues address search using AddressInfoIt*/
struct AddressInfoItContext {
	1: string key,
}

/** Result of address search*/
struct AddressInfoIt {
	1: string info,
	/** Context to use in subsequent search */
	2: AddressInfoItContext context,
}

struct SensorCalibrationTablePoint {
	1: double x,
	2: double y,
}

struct SensorCalibrationTable {
	1: list<SensorCalibrationTablePoint> points,
	2: bool fixMinMax, // if true, then result is null on value less than min and greater than max
}

struct SensorBooleanValues {
	1: string onValue, // shown in UI when value is true, must be not empty
	2: string offValue // shown in UI when value is false, must be not empty
}

struct SensorConfiguration {
	1: SensorId sensorId,
	2: string expression, // must be not empty and valid (lua-like syntax)
	3: optional SensorCalibrationTable calibrationTable, // calibrate value calculated in 'expression'
	4: string description, // human-readable description, may be empty
	5: bool visible, // sensor value is shown in monitoring object popup
	6: optional SensorBooleanValues booleanValues
}

struct TrackSensorConfiguration {
	/** sensor key */
	1: string sensorKey,
	/** color string in '#RRGGBB' format */
	2: optional string color,
	/** icon ID as in monitoring object properties */
	3: optional string iconUuid,
	/** icon format as in monitoring object properties */
	4: optional string iconFormat,
	/** delay in seconds */
	5: optional i32 delay,
}

struct SensorConfigurationSet {
	1: string id, // uuid, not empty
	2: string parentGroupId, // uuid, not empty
	3: string name, // not empty
	4: list<SensorConfiguration> sensorConfigurations,
}

/** reportBrokenTracker Request */
struct BrokenTrackerRequest {
	1: string monitoringObjectId,        /**< Monitoring Object ID, not empty, uuid */
	2: optional i64 brokenSinceUnixTime, /**< Moment, when the tracker has broken down, now by default, unix time */
}

enum ReportFormat {
	SCREEN = 0,
	CSV_FORMATTED = 1,
	CSV = 2,
	CSV_1C = 3,
	PDF = 4,
	XLSX = 5,
	DOCX = 6,
}

enum ReportArgumentType {
	VEHICLE = 0,
	GROUP = 1,
	DRIVER = 2,
	ROUTE = 3,
	SCHEDULE = 4,
	GEOFENCE = 5,
}

enum ReportStateFilter {
	TRIP_ONLY = 0,
	STOP_ONLY = 1,
	IGNITION_ON = 2,
	IGNITION_OFF = 3,
	FUELING_ON = 4,
	FUELING_OFF = 5,
	POWER_ON = 6,
	POWER_OFF = 7
}


struct ReportWorkingHours {
	1: i16 workingDaysMask, // 0th bit is monday, 7th bit and other is not usedlist
	2: i32 beginOffset, // working hours begin day offset (in seconds), 32400 for 09:00
	3: i32 endOffset, // working hours end day offset (in seconds), 32400 for 09:00
}

struct ReportTimeFilter {
	1: bool isWorkingTime, // true if working time, false if resting time
	2: ReportWorkingHours workingHours,
}

enum ReportFilterType {
	STATE_FILTER = 0,
	WORKING_TIME_FILTER = 1,
}

struct ReportInfo {
	// 1 is reserved for Report.ID — I'm still not sure that it could be avoided in the Thrift API
	/** Report type, not empty */
	2: string type,
	3: string title,
	4: list<ReportArgumentType> supportedArgumentTypes,
	5: optional list<string> supportedColumns,
	6: optional list<string> supportedGroupBy,
	7: optional list<ReportFilterType> supportedFilters,
	8: bool hierarchicalRows,
}

struct ReportRequest {
	// 1 is reserved for Report.ID — I'm still not sure that it could be avoided in the Thrift API
	/** Report Type */
	2: string type,
	3: string title,
	4: ReportFormat format,
	5: string language, // report language in 'xx_YY' format (ISO 639-1 & ISO 3166), e.g. 'ru_RU'
	6: string timezone, // timezone to use for the report, e.g. UTC+0400
	7: i64 fromTimestamp, // starting poing for the report
	8: i64 toTimestamp, // ending point for the report
	9: optional list<string> columns, // report columns for reports which support column customization
	10: optional string groupBy,
	11: optional ReportStateFilter stateFilter,
	12: optional ReportTimeFilter timeFilter,
	20: ReportArgumentType argumentType,
	21: list<string> argumentIds,
}

union ScreenReportCell {
	1: string stringValue,
	2: i64 i64Value,
	3: bool boolValue,
	4: double doubleValue,
}

struct ScreenReportSimpleRow {
	1: list<ScreenReportCell> cells,// simple columns data
}

struct ScreenReportHierarchicalRow {
	1: list<ScreenReportSimpleRow> rows,
	2: ScreenReportSimpleRow subtotal,
}

union ScreenReportRow {
	1: ScreenReportSimpleRow simple,
	2: ScreenReportHierarchicalRow hierarchical,
}

struct ScreenReport {
	// 1 is reserved for Report.ID — I'm still not sure that it could be avoided in the Thrift API
	2: string type,
	3: i64 fromTimestamp,
	4: i64 toTimestamp,
	5: i64 generatedAt,
	6: list<string> columns, // column names
	7: list<ScreenReportRow> rows, // rows data
}

service DispatchBackend {

	///////Login service////////
	/*
	 * returns session for some username
	 *
	 * @param userLoginName - user login name, not empty
	 * @param password - password, not empty
	 * @param longSession - type of session expiration time (true: 30d, false: 12h)
	 *
	 */
	Session login(
		1:string userLoginName,
		2:string password,
		3:bool longSession,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:AccessDenied ade,
		5:UserLicenseExpired ule,
		6:TrialIsNotActivated tne,
		7:LoginFailed lfe,
	),

	/*
	 *
	 * @param session - user session
	 *
	 */
	void logout(
		1:Session session,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
	),
	///////END Login service////////

	///////User service////////
	/*
	 * returns user info by user id
	 *
	 * @param session - user session
	 * @param id - user id, not empty, uuid
	 *
	 */
	User getUser(
		1:Session session,
		2:string id,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	list<UserSecurityData> getUserSecurityData(
		1:Session session,
		2:list<string> id,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	/*
	 * returns user info by user id
	 *
	 * @param session - user session
	 * @param filter - filter for found users
	 * @param filterType - filter type
	 *
	 */
	list<User> getUsers(
		1:Session session,
		2:UserFilter filter,
		3:UserFilterOptionalParams optionalParams,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	/*
	 * returns user info by session
	 *
	 * @param session - user session
	 *
	 */
	User getCurrentUser(
		1:Session session,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
	),

	/*
	 * returns users list for parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all users from subgroups
	 *
	 */
	list<User> getChildrenUsers(
		1:Session session,
		2:string parentGroupId,
		3:bool recursive
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	/*
	 * returns new user info
	 *
	 * @param session - abmin user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param login - login name, not empty, max length 32
	 * @param password - password, not empty, max length 32
	 * @param roleId - user role id, not empty, uuid
	 * @param groupLink - user visible groups, not empty, uuid list
	 * @param welcomeName - user welcome name
	 * @param email - user email
	 * @param phone - user phone
	 *
	 */
	User createUser(
		1:Session session,
		2:string parentGroupId,
		3:string login,
		4:string password,
		5:string roleId,
		6:list<string> groupLink
		7:string welcomeName,
		8:string email,
		9:string phone,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
		7:LoginAlreadyExists le,
	),

	/*
	 * returns new user info
	 *
	 * @param session - abmin user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param login - login name, not empty, max length 32
	 * @param passwordHash - password hash, not empty
	 * @param passwordSalt - password salt, not empty
	 * @param roleId - user role id, not empty, uuid
	 * @param groupLink - user visible groups, not empty, uuid list
	 * @param welcomeName - user welcome name
	 * @param email - user email
	 * @param phone - user phone
	 *
	 */
	User createUserSecure(
		1:Session session,
		2:string parentGroupId,
		3:string login,
		4:string passwordHash,
		5:string passwordSalt,
		6:string roleId,
		7:list<string> groupLink
		8:string welcomeName,
		9:string email,
		10:string phone,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
		7:LoginAlreadyExists le,
	),

	/*
	 *
	 * @param session - user session
	 * @param data - new data for edited user
	 *
	 */
	void editUser(
		1:Session session,
		2:User data,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
		7:LoginAlreadyExists lae,
	),

	/*
	 *
	 * @param session - user session
	 * @param id - iser id, not empty, uuid
	 *
	 */
	void deleteUser(
		1:Session session,
		2:string id,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 *
	 * @param session - user session
	 * @param oldPassword - old password, not empty
	 * @param newPassword - new password, 5 <= length <= 32
	 *
	 */
	void changePassword(
		1:Session session,
		2:string oldPassword,
		3:string newPassword,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:ObjectNotFound one,
	),

	/*
	 *
	 * @param session - admin user session
	 * @param userId - user id, not empty, uuid
	 * @param newPassword - new password, not empty, max length 32
	 *
	 */
	void setPassword(
		1:Session session,
		2:string userId,
		3:string newPassword,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	/*
	 *
	 * @param session - admin user session
	 * @param userId - user id, not empty, uuid
	 * @param newPasswordHash - password hash, not empty
	 * @param newPasswordSalt - password salt, not empty
	 *
	 */
	void setPasswordSecure(
		1:Session session,
		2:string userId,
		3:string newPasswordHash,
		4:string newPasswordSalt,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),
	///////END User service////////

	///////Role service////////
	/*
	 * returns role info by role id
	 *
	 * @param session - user session
	 * @param id - role id, not empty, uuid
	 *
	 */
	Role getRole(
		1:Session session,
		2:string id,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	/*
	 * returns role info by user id
	 *
	 * @param session - user session
	 * @param userId - user id, not empty, uuid
	 *
	 */
	Role getUserRole(
		1:Session session,
		2:string userId,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	/*
	 * returns roles list for parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all roles from subgroups
	 *
	 */
	list<Role> getGroupRoles(
		1:Session session,
		2:string parentGroupId,
		3:bool recursive
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),
	///////END Role service////////

	///////Group service////////
	/*
	 * returns group info by its id
	 *
	 * @param session - user session
	 * @param id - group id, not empty, uuid
	 *
	 */
	Group getGroup(
		1:Session session,
		2:string id,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns children groups list info by parent group id
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all subgroups
	 *
	 */
	list<Group> getChildrenGroups(
		1:Session session,
		2:string parentGroupId,
		3:bool recursive,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns root group list for user
	 *
	 * @param session - user session
	 *
	 */
	list<Group> getRootGroups(
		1:Session session,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
	),

	/*
	 * returns new group info
	 *
	 * @param session - user session
	 * @param parentGroupId - new group parent id, not empty, uuid
	 * @param title - new group title, not empty
	 *
	 */
	Group createGroup(
		1:Session session,
		2:string parentGroupId,
		3:string title,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns new group info
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param title - new company title, not empty
	 * @param license - company license struct, not empty
	 *
	 */
	Group createCompany(
		1:Session session,
		2:string parentGroupId,
		3:string title,
		4:License license,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns new group info
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param title - new company title, not empty
	 * @param license - company license struct, not empty
	 * @param  additionalFields - additional fields
	 *
	 */
	Group createCompanyWithAdditionalFields(
		1:Session session,
		2:string parentGroupId,
		3:string title,
		4:License license,
		5:AdditionalFields additionalFields,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 *
	 * @param session - user session
	 * @param data - new data for edited group
	 *
	 */
	void editGroup(
		1:Session session,
		2:Group data,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
	),

	/*
	 *
	 * @param session - user session
	 * @param id - group id, not empty, uuid
	 * @param cascade - delete all subobjects first
	 *
	 */
	void deleteGroup(
		1:Session session,
		2:string id,
		3:bool cascade
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	///////END Group service////////

	///////Monitoring object service////////
	/*
	 * returns monitoring object info by its id
	 *
	 * @param session - user session
	 * @param id - monitoring object id, not empty, uuid
	 *
	 */
	MonitoringObject getMonitoringObject(
		1:Session session,
		2:string id,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns objects list for parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all objects from subgroups
	 *
	 */
	list<MonitoringObject> getChildrenMonitoringObjects(
		1:Session session,
		2:string parentGroupId,
		3:bool recursive,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns filtered objects list portion
	 *
	 * @param session - user session
	 * @param filter - filter for found objects
	 * @param offset - start offset
	 * @param limit - objects max count
	 *
	 */
	list<MonitoringObject> getMonitoringObjectsPortion(
		1:Session session,
		2:MonitoringObjectFilter filter,
		3:i32 offset,
		4:i32 limit
	) throws (
		1:BadRequest bre,
		2:InternalServerError ise,
		3:AccessDenied ad,
		4:ObjectNotFound one,
	),

	/*
	 * returns filtered objects list
	 *
	 * @param session - user session
	 * @param filter - filter for found objects
	 * @param filterType - filter type
	 *
	 */
	list<MonitoringObject> getMonitoringObjects(
		1:Session session,
		2:MonitoringObjectFilter filter,
		3:FilterType filterType,
	) throws (
		1:BadRequest bre,
		2:InternalServerError ise,
		3:AccessDenied ad,
		4:ObjectNotFound one,
	),

	/*
	 * returns new monitoring object info
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param tracker - tracker device, not empty
	 * @param name - monitoring object name, not empty
	 * @param displayColor - display color
	 * @param displayIcon - display icon
	 *
	 */
	MonitoringObject createMonitoringObject(
		1:Session session,
		2:string parentGroupId,
		3:Tracker tracker,
		4:string name,
		5:string displayColor,
		6:string displayIcon,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
		7:TrackerAlreadyUsed tau,
	),

	/*
	 * returns new monitoring object info
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param tracker - tracker device, not empty
	 * @param name - monitoring object name, not empty
	 * @param displayColor - display color
	 * @param displayIcon - display icon
	 * @param additionalFields - additional fields
	 *
	 */
	MonitoringObject createMonitoringObjectWithAdditionalFields(
		1:Session session,
		2:string parentGroupId,
		3:Tracker tracker,
		4:string name,
		5:string displayColor,
		6:string displayIcon,
		7:AdditionalFields additionalFields,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
		7:TrackerAlreadyUsed tau,
	),

	 /*
	 * returns new monitoring object info
	 *
	 * @param session - user session
	 * @param data - monitoring object description
	 *   Note: id must be empty
	 */
	MonitoringObject createMonitoringObjectByObjectDescription(
		1:Session session,
		2:MonitoringObject data,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
		7:TrackerAlreadyUsed tau,
		8:ObjectIdMustBeEmptyOnObjectCreation imbe
	),

	/*
	 *
	 * @param session - user session
	 * @param data - new data for edited object
	 *
	 */
	void editMonitoringObject(
		1:Session session,
		2:MonitoringObject data,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ade,
		6:ObjectNotFound one,
		7:TrackerAlreadyUsed tau,
	),

	/*
	 *
	 * @param session - user session
	 * @param id - monitoring object id, not empty, uuid
	 *
	 */
	void deleteMonitoringObject(
		1:Session session,
		2:string id,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns monitoring objects events for period
	 *
	 * @param session - user session
	 * @param monitoringObjectIdList - list of monitoring object id, not empty, uuid list
	 * @param startDate - start date, not empty, ISO-8601
	 * @param endDate - end date, not empty, ISO-8601
	 *
	 */
	list<MonitoringObjectEvent> getMonitoringObjectEvents(
		1: Session session,
		2: list<string> monitoringObjectIdList,
		3: string startDate,
		4: string endDate,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns monitoring objects events since 'startDate'
	 * and with globalMonotonicIndex value NOT LESS than specified in 'startMonotonicIndex'
	 *
	 * @param session - user session
	 * @param monitoringObjectIdList - list of monitoring object id, not empty, uuid list
	 * @param startDate - start date, not empty, ISO-8601
	 * @param startMonotonicIndex - globalMonotonicIndex value
	 * @param limit - maximum number of events to return
	 *
	 */
	list<MonitoringObjectEvent> getMonitoringObjectEventsSince(
		1: Session session,
		2: list<string> monitoringObjectIdList,
		3: string startDate,
		4: i64 startMonotonicIndex,
		5: i32 limit,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/**
	 * Возвращает список иконок объектов мониторинга, удовлетворяющих фильтру
	 *
	 * @param session - сессия пользователя
	 * @param filter - фильтр иконок
	 */
	list<MonitoringObjectIcon> getMonitoringObjectIcons(
		1: Session session,
		2: MonitoringObjectIconFilter filter
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
	),

	/*
	 * create road accident event for given monitoring object
	 *
	 * @param session - user session
	 * @param monitoringObjectId - id of monitoring object, not empty, uuid
	 * @param eventParams - new event creating info, not null
	 *
	 */
	void reportRoadAccident(
		1: Session session,
		2: string monitoringObjectId,
		3: RoadAccidentEventParameters eventParams
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * returns commands available for monitoring object
	 *
	 * @param session - user session
	 * @param monitoringObjectId - monitoring object id, not empty, uuid
	 *
	 */
	list<Command> getMonitoringObjectCommands (
		1:Session session,
		2:string monitoringObjectId,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/* returns command launch id
	 *
	 * @param session - user session
	 * @param commandId - command id, not empty, uuid
	 *
	 */
	i64 executeCommand (
		1:Session session,
		2:string commandId,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*returns command status list by command id
	 *
	 * @param session - user session
	 * @param monitoringObjectId - monitoring object id, not empty, uuid
	 *
	 */
	list<CommandStatus> getCommandsStatus (
		1:Session session,
		2:string monitoringObjectId,
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

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
		1: Session session,
		2: list<dispatchCommon.VehicleRelayTrackRequest> requests,
		3: dispatchCommon.PositionRequestFields columns,
		4: i32 messageLimit,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

	/*
	 *
	 * Return collected messages for relaying session.
	 * Note: function waits until at least 1 vehicle have data to send.
	 * Note: messages for each vehicle are sorted by increasing received_timestamp.
	 *
	 * @param relaySession - relaying session
	 *
	*/
	list<dispatchCommon.Track> getRelayingTracks(
		1: dispatchCommon.RelaySession relayingSession
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: dispatchCommon.RelaySessionError rse,
	)

	/*
	 *
	 * Return collected messages for relaying session.
	 * Note: function waits until at least 1 vehicle have data to send specified or default amount of time.
	 * Note: messages for each vehicle are sorted by increasing received_timestamp.
	 *
	*/
	list<dispatchCommon.Track> getRelayingTracksEx(
		1: dispatchCommon.RelayingTracksRequest request
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: dispatchCommon.RelaySessionError rse,
	)

	/*
	 *
	 * Return messages history for selected vehicles.
	 * Note: messages for each vehicle are sorted by increasing captured_timestamp.
	 *
	 * @param requests - vehicle static ids and captured_timestamp range for each vehicle
	 *   Note: timestamp has open right border.
	 * @param messageLimit - limit for messages for each vehicle
	 * @param columns - selected columns
	 *
	 */
	list<dispatchCommon.Track> getMonitoringObjectsTracks(
		1: Session session,
		2: list<dispatchCommon.VehicleHistoryTrackRequest> requests,
		3: dispatchCommon.PositionRequestFields columns,
		4: i32 messageLimit,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

	/*
	 *
	 * Return message history for selected vehicle sorted ascending by captured_timestamp.
	 *
	 * @param requests - vehicle static ids and captured_timestamp range
	 * Note: timestamp has open right border.
	 * @param columns - selected columns
	 * @param viewport - viewport to clip and simplify track
	 * @param useTrackSplitting - if true uses additional track splitting by time between points and movement speed
	 */
	list<dispatchCommon.Track> getClippedMonitoringObjectTracks(
		1: Session session,
		2: dispatchCommon.VehicleHistoryTrackRequest request,
		3: dispatchCommon.PositionRequestFields columns,
		4: dispatchCommon.Viewport viewport,
		5: bool useAdditionalTrackSplitting,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

	/**
	 * Возвращает краткую сгруппированную историю движения объекта мониторинга
	 */
	dispatchCommon.VehicleHistoryTrackGroupedDetailsResponse getMonitoringObjectTrackGroupedDetails(
		1: Session session,
		2: dispatchCommon.VehicleHistoryTrackGroupedDetailsRequest request,
	)  throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	),

	/*
	 *
	 * Return last message for selected vehicles.
	 * @param vehicleUuids - vehicle static ids
	 * @param columns - selected columns, same as for above function
	 *
	 */
	list<dispatchCommon.PositionWithVehicle> getRecentPositions(
		1: Session session,
		2: list<string> vehicleUuids,
		3: dispatchCommon.PositionRequestFields columns,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

	/*
	 *
	 * Return last message with all fields for selected vehicles.
	 * @param vehicleUuids - vehicle static ids
	 *
	 */
	list<dispatchCommon.PositionWithColumns> getRecentPositionsWithAllColumns(
		1: Session session,
		2: list<string> vehicleUuids,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

	/*
	 *
	 * @param session - user session
	 * @param vehicleId - vehicle static id
	 * @param enable - enable or disable action
	 *
	 */
	void enableVehicle(
		1: Session session,
		2: string vehicleId,
		3: bool enable
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ad,
		6: ObjectNotFound one,
	)

	/*
	 * Set new status for the monitoring objects tracker
	 * @param monitoringObjectId - identifier of the monitoring object to which the tracker is linked
	 * @param status - new tracker ststus
	 */
	void setTrackerStatus(
		1: Session session,
		2: string monitoringObjectId,
		3: TrackerStatus status
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * Get status for the monitoring objects tracker
	 * @param monitoringObjectId - identifier of the monitoring object to which the tracker is linked
	 */
	list<TrackerStatusChange> getTrackerStatusHistory(
		1: Session session,
		2: string monitoringObjectId
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * Get certificate for monitoring objects tracker
	 * @param monitoringObjectIds - identifiers of the monitoring objects to which the trackers are linked
	 */
	list<TrackerCertificate> getTrackersCertificate(
		1: Session session,
		2: list<string> monitoringObjectIds
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * Set certificate for monitoring objects tracker
	 * @param certificate - tracker certificate
	 */
	void setTrackerCertificate(
		1: Session session,
		3: TrackerCertificate certificate
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 * Remove certificate linked to monitoring objects tracker
	 * @param monitoringObjectIds - identifiers of the monitoring objects to which the trackers are linked
	 */
	void removeTrackersCertificate(
		1: Session session,
		2: list<string> monitoringObjectIds
	) throws (
		1:BadRequest bre,
		2:Busy bse,
		3:InternalServerError ise,
		4:Unauthorized ue,
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	/*
	 *
	 * @param session - user session
	 * @param vehicleId - vehicle static id
	 *
	 */
	bool isVehicleEnabled(
		1: Session session,
		2: string vehicleId
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ad,
		6: ObjectNotFound one,
	)

	/*
	 *
	 * Return last message for selected vehicles.
	 * @param vehicleUuids - vehicle static ids
	 * @param columns - selected columns, same as for above function
	 * In contrast to function getRecentPositions, if the recent position has no valid gps
	 * information, it returns the last known one
	 */
	list<dispatchCommon.PositionWithVehicle> getRecentPositionsWithValidGPS(
		1: Session session,
		2: list<string> vehicleUuids,
		3: dispatchCommon.PositionRequestFields columns,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

	/*
	 * Mark the current tracker of a given monitoring object as malfunctioning
	 * @param request — structure specifying monitoring object and describing other failure details
	 */
	void reportBrokenTracker(
		1: Session session,
		2: BrokenTrackerRequest request,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound onfe,
	)

	///////END Monitoring object service////

	///////Map querying service////

	/*
	 *
	 * Returns addresses for list of coordinates.
	 * Return size is the same as the points list size.
	 * Each element of return value contains the same object in different language.
	 * @param points - list of points
	 */
	list<list<dispatchCommon.Address>> getGeopointsAddresses(
		1:Session session,
		2:list<dispatchCommon.GeoPoint> points,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	),

	///////END Map querying service////

	/**
	 * Billing service.
	 * Subset of companyUUIDs available to the user in no particular order.
	 */
	list<CompanyStatistics> getCompanyStatistics(
		/** user session */
		1: Session session,
		/** дата и время начала периода аггрегации статистики по компании в формате ISO-8601 (inclusive) */
		2: string startDate,
		/** дата и время периода конца аггрегации (non-inclusive) */
		3: string endDate,
		/** список UUID компаний */
		4: list<string> companyUUIDs
	) throws (
		/** Invalid UUID in @param companyUUIDs, bad date-time causes InternalServerError */
		1:BadRequest bre,
		2:Busy bse,
		/** Invalid date format or other error */
		3:InternalServerError ise,
		/** Invalid session */
		4:Unauthorized ue,
		/** User has no permission to view companies (licenses) */
		5:AccessDenied ad,
		6:ObjectNotFound one,
	),

	///////Relay service////////

	/**
	 * returns relay info by its id
	 *
	 * @param session - user session
	 * @param id - relay id, not empty, uuid
	 *
	 */
	Relay getRelay(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * returns relays for parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all relays from subgroups
	 *
	 */
	list<Relay> getChildRelays(
		1: Session session,
		2: string parentGroupId,
		3: bool recursive,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * creates relay and returns it's info
	 *
	 * @param session - user session, uuid
	 * @param title - relay title, not empty
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param protocol - not empty, one of "egts", "granit06", "kurs", "magicsystems", "olympstroy", "scoutopen", "transnavi", "wialonIPS", "can_way", "sodch", "yandex"
	 * @param enabled
	 * @param monitoringObjectsIds - list of monitoring object id, not empty, uuid list
	 * @param host - relay host, not empty
	 *
	 */
	Relay createRelay(
		1: Session session,
		2: string title,
		3: string parentGroupId,
		4: string protocol,
		5: bool enabled,
		6: list<string> monitoringObjectsIds,
		7: string host,
		8: RelayOptionalParams optionalParams,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),


	/**
	 * edits existing relay
	 *
	 * @param session - user session, uuid
	 * @param relay - relay with modified params
	 *
	 */
	void editRelay(
		1: Session session,
		2: Relay relay,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * deletes existing relay
	 *
	 * @param session - user session, uuid
	 * @param id - relay id, not empty, uuid
	 *
	 */
	void deleteRelay(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	///////END Relay service////////

	///////Geofence service////////

	/**
	 * returns geofence info by its id
	 *
	 * @param session - user session
	 * @param id - geofence id, not empty, uuid
	 *
	 */
	Geofence getGeofence(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * returns list of geofences for parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all geofences from subgroups
	 *
	 */
	list<Geofence> getChildGeofences(
		1: Session session,
		2: string parentGroupId,
		3: bool recursive,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * returns geofence geometry by its id
	 *
	 * @param session - user session
	 * @param id - geofence id, not empty, uuid
	 *
	 */
	string getGeofenceGeometryWKT(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * creates geofence and returns it's info
	 *
	 * @param session - user session, uuid
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param title - geofence title, not empty
	 * @param color - geofence color
	 * @param geometryWKT - geofence geometry in WKT format
	 *
	 */
	Geofence createGeofence(
		1: Session session,
		2: string parentGroupId,
		3: string title,
		4: string color,
		5: string geometryWKT,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * edits existing geofence
	 *
	 * @param session - user session, uuid
	 * @param geofence - geofence with modified params
	 *
	 */
	void editGeofence(
		1: Session session,
		2: Geofence geofence,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * edits existing geofence geometry
	 *
	 * @param session - user session, uuid
	 * @param id - geofence id, not empty, uuid
	 * @param geometryWKT - updated geometry for specified geofence
	 *
	 */
	void editGeofenceGeometryWKT(
		1: Session session,
		2: string id,
		3: string geometryWKT,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * deletes existing geofence
	 *
	 * @param session - user session, uuid
	 * @param id - geofence id, not empty, uuid
	 *
	 */
	void deleteGeofence(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	///////END Geofence service////////

	///////Places service////////

	/**
	 * @return place info by its id
	 *
	 * @param session - user session
	 * @param id - place id, not empty, uuid
	 *
	 */
	Place getPlace(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * @return places of parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all places on map from subgroups
	 *
	 */
	list<Place> getChildPlaces(
		1: Session session,
		2: string parentGroupId,
		3: bool recursive,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * creates place and returns it's info
	 *
	 * @param session - user session, uuid
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param title - place title, not empty
	 * @param longitude - place longitude
	 * @param latitude - place latitude
	 *
	 */
	Place createPlace(
		1: Session session,
		2: string parentGroupId,
		3: string title,
		4: dispatchCommon.GeoPoint position,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * edits existing place
	 *
	 * @param session - user session, uuid
	 * @param place - place with modified params
	 *
	 */
	void editPlace(
		1: Session session,
		2: Place place,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * deletes existing place
	 *
	 * @param session - user session, uuid
	 * @param id - place id, not empty, uuid
	 *
	 */
	void deletePlace(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	///////END Places service////////

	///////Routes service////////

	/**
	 * @return route info
	 *
	 * @param session - user session
	 * @param routeId - route id, not empty, uuid
	 *
	 */
	RouteInfo getRoute (
		1: Session session,
		2: string routeId,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * @return group child routes
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all routes from subgroups
	 *
	 */
	list<RouteInfo> getChildRoutes (
		1: Session session,
		2: string parentGroupId,
		3: bool recursive
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * @return points of route line
	 *
	 * @param session - user session
	 * @param routeId - route id, not empty, uuid
	 *
	 */
	list<dispatchCommon.ClippedPolyline> getRouteLines (
		1: Session session,
		2: string routeId,
		3: dispatchCommon.Viewport viewport
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * creates route and returns its info
	 *
	 * @param session - user session, uuid
	 * @param parentGroupId - parent group id, uuid
	 * @param title - route title, not empty
	 * @param color - route line color, not empty, free format
	 * @param coridorWidth
	 * @param routeControlMethod
	 * @param vehicleRoutingType
	 * @param routeStages
	 *
	 */

	RouteInfo createRoute(
		1: Session session,
		2: string parentGroupId,
		/** not empty */
		3: string title,
		/** not empty, free format */
		4: string color,
		5: double coridorWidth,
		6: RouteControlMethod routeControlMethod,
		7: VehicleRoutingType vehicleRoutingType,
		8: list<RouteStageSet> routeStageSets,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * edits route and returns its updated info
	 *
	 * @param session - user session, uuid
	 * @param route - route with modified params
	 *
	 */
	RouteInfo editRoute(
		1: Session session,
		2: Route route,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * deletes route
	 *
	 * @param session - user session
	 * @param id - route id, not empty
	 */
	void deleteRoute(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	),

	/**
	 * calculatess route geometry
	 *
	 * @param session - user session, uuid
	 * @param stages
	 *
	 */
	RouteGeometry calculateRouteGeometry(
		1: Session session,
		2: list<RouteStage> stages,
		3: VehicleRoutingType routingType,
		4: dispatchCommon.Viewport viewport
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	///////END Routes service////////

	///////Events generating service////////

	/**
	 * @return events generating rule by its id
	 * @param session - user session
	 * @param id - events generating rule uuid, not empty
	 */
	EventsRule getEventsRule(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	),

	/**
	 * @return events generating rules in group
	 * @param session - user session
	 * @param parentGroupId - parent group uuid, not empty
	 * @param recursive - also return rules from subgroups
	 */
	list<EventsRule> getChildEventsRules(
		1: Session session,
		2: string parentGroupId,
		3: bool recursive,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	),

	/**
	 * @return new events generating rule
	 * @param session - user session
	 * @param parentGroupId - parent group uuid, not empty
	 * @param title - name of the rule, not empty
	 * @param monitoringObjectIds - monitoring objects uuids, not empty
	 * @param eventsConditions - condition(s) to make rule's events generated
	 * @param eventsConditionsAreDisjunctive - false means conjunctive conditions
	 * @param generatedEventType - type of event to be generated
	 * @param actionsCondition - additional condition (when events generated) to make rule's actions applied
	 * @param actions - actions to execute when events generating rule applied
	 */
	EventsRule createEventsRule(
		1: Session session,
		2: string parentGroupId,
		3: string title,
		4: list<string> monitoringObjectIds,
		5: list<GenerateEventsCondition> eventsConditions,
		6: bool eventsConditionsAreDisjunctive,
		7: dispatchEventType.EventType generatedEventType,
		8: ApplyActionsCondition actionsCondition,
		9: EventsRuleActions actions,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
	),

	/**
	 * @param session - user session
	 * @param modifiedRule - rule to change existing one, identified by uuid
	 */
	void editEventsRule(
		1: Session session,
		2: EventsRule modifiedRule,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	),

	/**
	 * @param session - user session
	 * @param id - events generating rule uuid, not empty
	 */
	void deleteEventsRule(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	),

	///////END Events generating service////////

	///////Trip service////////
	/**
	 * @return trip info by its id
	 *
	 * @param session - user session
	 * @param id - trip id, not empty, uuid
	 *
	 */
	list<Trip> getTripsInfo(
		1: Session session,
		2: list<string> tripsId,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * @return trips of parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param allowableStatuses- return trips whoes status is one of listed, empty if no filtering
	 * @param recursive - return all trips from subgroups
	 *
	 */
	list<string> getTripsId(
		1: Session session,
		2: string parentGroupId,
		3: list<TripStatus> allowableStatuses,
		4: bool recursive,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * @return trips for monitoring objects
	 *
	 * @param session - user session
	 * @param monitoringObjectsId - monitoringObjects uuid list
	 *
	 */
	map<string, list<string>> getMonitoringObjectsTrips(
		1: Session session,
		2: list<string> monitoringObjectsId,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * creates trip and returns it's info
	 *
	 * @param session - user session, uuid
	 * @param vehicleId - vehicle uuid
	 * @param routeId - route uuid
	 * @param tripStageSets - trip stages uuids for each trip variant
	 *
	 */
	Trip createTrip(
		1: Session session,
		2: string vehicleId, // uuid
		3: string routeId, // uuid
		4: list<TripStageSet> tripStageSets,
		5: i64 startTripUnixTime,
		6: i64 abortTripUnixTime,
		7: TripNotification notificationParams,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * creates trip and returns it's info
	 *
	 * @param session - user session, uuid
	 * @param trip - trip to create
	 * @param additionalFields - additional fields
	 *
	 */
	Trip createTripWithAdditionalFields(
		1: Session session,
		2: string vehicleId, // uuid
		3: string routeId, // uuid
		4: list<TripStageSet> tripStageSets,
		5: i64 startTripUnixTime,
		6: i64 abortTripUnixTime,
		7: TripNotification notificationParams,
		8: AdditionalFields additionalFields
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * edits existing trip
	 *
	 * @param session - user session, uuid
	 * @param trip - trip with modified params
	 *
	 */
	void editTrip(
		1: Session session,
		2: Trip trip,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * deletes existing trip
	 *
	 * @param session - user session, uuid
	 * @param id - trip id, not empty, uuid
	 *
	 */
	void deleteTrip(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * cancels existing not finished trip
	 *
	 * @param session - user session, uuid
	 * @param id - trip id, not empty, uuid
	 *
	 */
	void cancelTrip(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * @return events for selected trips and event types
	 * @param session - user session
	 * @param tripIds - selected trip ids
	 * @param eventTypes - selected event types, must be trip event types
	 * @param globalMonotonicIndex - skip events with index less than this value. Ignored if 0.
	 */
	list<TripEvent> getTripEvents(
		1: Session session,
		2: list<string> tripIds,
		3: list<dispatchEventType.EventType> eventTypes,
		4: i64 globalMonotonicIndex,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	),

	/**
	 *
	 * Return tracks of vehicles on specified trip sorted ascending by captured_timestamp.
	 *
	 * @param request - trip id and captured_timestamp range
	 * Note: timestamps has closed border.
	 * @param columns - selected columns
	 *
	 */
	list<dispatchCommon.Track> getClippedTripTracks(
		1: Session session,
		2: dispatchCommon.TripTrackRequest request,
		3: dispatchCommon.PositionRequestFields columns,
		4: dispatchCommon.Viewport viewport,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	)

	///////END Trip service////////

	/////////Store service///////////
	/**
	 * @return store scheme info
	 *
	 * @param session - user session
	 * @param schemeId - scheme id, not empty, uuid
	 *
	 */
	StoreScheme getStoreScheme (
		1: Session session,
		2: string schemeId,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * get scheme for additional fields with group id and extended object type
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, uuid, not empty
	 * @param extensionForType - extended object type, not empty
	 */
	StoreScheme getAdditionalFieldsScheme(
		1: Session session,
		2: string parentGroupId,
		3: ExtensionForStoreType extensionForType,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
		5: AccessDenied ade,
		6: ObjectNotFound nfe,
	),

	/**
	 * creates store scheme and returns its info
	 *
	 * @param session - user session, uuid
	 * @param parentGroupId - parent group id, uuid, not empty
	 * @param name - scheme name, not empty
	 * @param fields - list of scheme fields, not empty, field id will be ignored
	 * @param description - scheme description
	 *
	 */
	StoreScheme createStoreScheme(
		1: Session session,
		2: string parentGroupId,
		3: string name,
		4: list<StoreField> fields,
		5: string description,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * delete store scheme
	 *
	 * @param session - user session, uuid
	 * @param id - scheme id, uuid not empty
	 *
	 */
	void deleteStoreScheme(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * edit store scheme
	 *
	 * @param session - user session, uuid
	 * @param scheme - edited scheme with changes
	 *
	 */
	void editStoreScheme(
		1: Session session,
		2: StoreScheme scheme,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	//TO BE CONTINUED
	///////END Store service/////////

	///////Addres info service////////
	/**
	 * @return countries available in map service filtered by filter
	 * @param session - user session
	 * @param filter - search filter
	 */
	list<AddressInfoIt> getCountries(
		1: Session session,
		2: AddressFilterInfo filter,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
	),

	/**
	 * @return cities available in map service filtered by filter
	 * @param session - user session
	 * @context - context returned by getCountries call
	 * @param filter - search filter
	 */
	list<AddressInfoIt> getCities(
		1: Session session,
		2: AddressInfoItContext context,
		3: AddressFilterInfo filter,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
	),

	/**
	 * @return streets available in map service filtered by filter
	 * @param session - user session
	 * @context - context returned by getCities call
	 * @param filter - search filter
	 */
	list<AddressInfoIt> getStreets(
		1: Session session,
		2: AddressInfoItContext context,
		3: AddressFilterInfo filter,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
	),

	/**
	 * @return buildings available in map service filtered by filter
	 * @param session - user session
	 * @context - context returned by getStreets call
	 * @param filter - search filter
	 */
	list<AddressInfoIt> getBuildings(
		1: Session session,
		2: AddressInfoItContext context,
		3: AddressFilterInfo filter,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
	),

	/**
	 * @return coordinates of object found by address search
	 * @param session - user session
	 * @context - context returned by getCountries/Cities/Streets/Buildings calls
	 */
	dispatchCommon.GeoPoint getPoint(
		1: Session session,
		2: AddressInfoItContext context,
	) throws (
		1: BadRequest bre,
		2: Busy be,
		3: InternalServerError iee,
		4: Unauthorized uae,
	),
	///////END Addres info service////////

	///////Sensor configuration service////////
	/**
	 * @return existing sensor configurations of monitoring object
	 *
	 * @param session - user session
	 * @param monitoringObjectId - monitoring object id, not empty, uuid
	 *
	 */
	list<SensorConfiguration> getSensorConfigurations(
		1: Session session,
		2: string monitoringObjectId,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * Edits monitoring object sensor configurations.
	 * Fails on invalid expression in one of configuration, duplicate sensor configurations, ...
	 *
	 * @param session - user session, uuid
	 * @param monitoringObjectId - id of a monitoring object, uuid
	 * @param sensors - edited sensor configuration list
	 *
	 */
	void setSensorConfigurations(
		1: Session session,
		2: string monitoringObjectId,
		3: list<SensorConfiguration> sensorConfigurations,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),
	///////END Sensor configuration service////////

	list<TrackSensorConfiguration> getTrackSensorConfigurations(
		1: Session session,
		2: string monitoringObjectId,
	),

	///////Sensor configuration set service////////

	/**
	 * creates sensor configuration set and returns it's
	 *
	 * @param session - user session, uuid
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param name - set name, not empty
	 * @param list<SensorConfiguration> - list of sensor configurations
	 *
	 */
	SensorConfigurationSet createSensorConfigurationSet(
		1: Session session,
		2: string parentGroupId,
		3: string name,
		4: list<SensorConfiguration> sensorConfigurations,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: ObjectNotFound one,
	),

	/**
	 * returns sensor configuration set by its id
	 *
	 * @param session - user session
	 * @param id - set id, not empty, uuid
	 *
	 */
	SensorConfigurationSet getSensorConfigurationSet(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: ObjectNotFound one,
	),

	/**
	 * returns list of sensor configuration sets for parent group
	 *
	 * @param session - user session
	 * @param parentGroupId - parent group id, not empty, uuid
	 * @param recursive - return all sets from subgroups
	 *
	 */
	list<SensorConfigurationSet> getChildSensorConfigurationSet(
		1: Session session,
		2: string parentGroupId,
		3: bool recursive,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * edits existing sensor configuration set
	 *
	 * @param session - user session, uuid
	 * @param sensorConfigurationSet - set with modified params
	 *
	 */
	void editSensorConfigurationSet(
		1: Session session,
		2: SensorConfigurationSet sensorConfigurationSet,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	/**
	 * deletes existing sensor configuration set
	 *
	 * @param session - user session, uuid
	 * @param id - set id, not empty, uuid
	 *
	 */
	void deleteSensorConfigurationSet(
		1: Session session,
		2: string id,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	///////END Sensor configuration set service////////

	/*
	 *
	 * Return chart curve for vehicle sorted ascending by captured_timestamp.
	 *
	 * @param requests - vehicle static id and captured_timestamp range
	 * Note: timestamp has open right border.
	 * @param columns - selected columns
	 * @param lod - level of details for returned chart curve [0..15] 0 is most detailed
	 *
	 */
	list<dispatchCommon.ChartCurve> getMonitoringObjectChart(
		1: Session session,
		2: dispatchCommon.VehicleHistoryTrackRequest request,
		3: list<dispatchCommon.ChartCurveId> columns,
		4: i32 lod,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

    /*
	 *
	 * Returns bounding rects of recent points for selected vehicles.
	 *
	 * @param requests - vehicle static ids and captured_timestamp range for each vehicle
	 *   Note: timestamp has open right border.
	 *
	 */
	list<dispatchCommon.GeoRect> getMonitoringObjectsTracksRects(
		1: Session session,
		2: list<dispatchCommon.VehicleHistoryTrackRequest> requests,
	)throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	)

	/**
	 * change first vehicle's tracker from_timestamp to given value
	 *
	 * @param session - user session, uuid
	 * @param vehicleId - vehicle id
	 * @param timestamp - new time
	 *
	 */
	void changeVehicleCreationTime(
		1: Session session,
		2: string vehicleId,
		3: i64 timestamp,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	list<ReportInfo> getChildrenReports(
		1: Session session,
		2: string parentGroupId,
		3: bool recursive
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
	),

	void sendReport(
		1: Session session,
		2: string email,
		3: ReportRequest parameters,
	) throws (
		1: BadRequest bre,
		2: Busy bse,
		3: InternalServerError ise,
		4: Unauthorized ue,
		5: AccessDenied ade,
		6: ObjectNotFound one,
	),

	ScreenReport buildScreenReport(
		1: Session session,
		2: ReportRequest parameters
	),
}
