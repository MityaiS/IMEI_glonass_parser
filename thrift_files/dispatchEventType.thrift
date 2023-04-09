namespace cpp dispatch.server.thrift.backend
namespace java dispatch.server.thrift.backend
// NOTE: use different namespace for python
// NOTE: because otherwise py-thrift generator overrides dispatchbackend.thrift output
namespace py dispatch.server.thrift.backend.eventtype

enum EventType {
	Stop = 1,
	GeoFenceEntry = 2,
	GeoFenceLeave = 3,
	GeoFenceSpeedingBegin = 4,
	GeoFenceSpeedingEnd = 5,
	SpeedingBegin = 6,
	SpeedingEnd = 7,
	Start = 8,
	DeviceAlarm = 11,
	TripScheduled = 14,
	TripStart = 15,
	TripEnd = 16,
	TripAborted = 17,
	TripDeleted = 18,
	TripOverlap = 19,
	RouteDeviation = 20,
	RouteReturn = 21,
	TripPointEntry = 22,
	TripPointLeave = 23,
	TripPointSkip = 24,
	// ScheduleLate = 25, obsolete, now LateArrivalOnTrip = 75 and LateDepartureOnTrip = 77
	// ScheduleAdvance = 26, obsolete, now EarlyArrivalOnTrip = 74 and EarlyDepartureOnTrip = 76
	ScheduleReturn = 27,
	TripPointOutOfTurn = 28,
	SensorBegin = 29,
	SensorEnd = 30,
	InactivityBegin = 31,
	InactivityEnd = 32,
	DelayedInGeofence = 33,
	//LeaveGeofenceOnTime = 34, inner event, obsolete
	FuelAdditionBegin = 35,
	FuelAdditionEnd = 36,
	FuelRemovalBegin = 37,
	FuelRemovalEnd = 38,
	DeviceConnected = 39,
	DeviceDisconnected = 40,
	TooCloseBegin = 41,
	TooCloseEnd = 42,
	TooFarBegin = 43,
	TooFarEnd = 44,
	SpeedingOnRoadBegin = 45,
	SpeedingOnRoadEnd = 46,
	HarshAccelerationBegin = 47,
	HarshAccelerationEnd = 48,
	HarshBrakingBegin = 49,
	HarshBrakingEnd = 50,
	HarshTurnBegin = 51,
	HarshTurnEnd = 52,
	SpeedingPenaltyBegin = 53,
	SpeedingPenaltyEnd = 54,
	RoughRoadBegin = 55,
	RoughRoadEnd = 56,
	GeoFenceSensorBegin = 57,
	GeoFenceSensorEnd = 58,
	AlarmBegin = 59,
	AlarmEnd = 60,
	MaintenanceDone = 61,
	MaintenanceOverdue = 62,
	FuelOverConsumptionBegin = 63,
	FuelOverConsumptionEnd = 64,
	MaintenanceSoon = 65,
	AbsenceFromTrip = 66,
	SoonTripEnd = 67,
	DisconnectedOnTripBegin = 68,
	DisconnectedOnTripEnd = 69,
	UnscheduledStopOnTripBegin = 70,
	UnscheduledStopOnTripEnd = 71,
	AlarmOnTripBegin = 72,
	AlarmOnTripEnd = 73,
	EarlyArrivalOnTrip = 74,
	LateArrivalOnTrip = 75,
	EarlyDepartureOnTrip = 76,
	LateDepartureOnTrip = 77,
	SwitchingToAlternativeRoute = 78,
	TripCanceled = 79,
	TripPointShift = 80,
	TripVehicleAssignment = 81
	TripVehicleWithdrawal = 82,
	TrackerBroken = 83,
	NoMovementBegin = 85,
	NoMovementEnd = 86,
	RoadAccident = 87,

	PhotoEvent = 10000,
}

/*
 * Trip event types:
 *  TripScheduled
 *  TripStart
 *  TripEnd
 *  TripAborted
 *  TripDeleted
 *  TripOverlap
 *  RouteDeviation
 *  RouteReturn
 *  TripPointEntry
 *  TripPointLeave
 *  TripPointSkip
 *  ScheduleReturn
 *  TripPointOutOfTurn
 *  AbsenceFromTrip
 *  SoonTripEnd
 *  DisconnectedOnTripBegin
 *  DisconnectedOnTripEnd
 *  UnscheduledStopOnTripBegin
 *  UnscheduledStopOnTripEnd
 *  AlarmOnTripBegin
 *  AlarmOnTripEnd
 *  EarlyArrivalOnTrip
 *  LateArrivalOnTrip
 *  EarlyDepartureOnTrip
 *  LateDepartureOnTrip
 *  SwitchingToAlternativeRoute
 *  TripCanceled
 *  TripPointShift
 *  TripVehicleAssignment
 *  TripVehicleWithdrawal
 */
