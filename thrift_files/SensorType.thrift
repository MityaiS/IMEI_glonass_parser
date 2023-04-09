namespace cpp dispatch.server.thrift.backend
namespace java dispatch.server.thrift.backend
// NOTE: use different namespace for python
// NOTE: because otherwise py-thrift generator overrides dispatchbackend.thrift output
namespace py dispatch.server.thrift.backend.sensortype

// Suffixes
// Mv - millivolts
// Hz - hertz
// L - litres
// C - degrees Celsius
// Kg - kilograms
// Kgm3 - kg/m3

enum SensorType {
	PrimaryIgnition = 2,
	Speed = 5,
	GpsFix = 10,
	ExternalPower = 17, // boolean
	ExternalPowerMv = 18,
	AccelerationX = 21, // ms2
	AccelerationY = 22, // ms2
	AccelerationZ = 23, // ms2
	AlarmButton = 24,
	TiltAlarm = 33,
	CrashAlarm = 34,
	CoolantTemperature = 35,
	EngineRpm = 36,
	FuelPercent = 37,
	Mileage = 38, // kilometers
	TotalFuelConsumed = 39, // litres
	EngineHours = 41,
	InputChunkSize = 48,
	InputPackageSize = 49,
	OutputChunkSize = 50,
	OutputPackageSize = 51,
	PrimaryFuelFlowSupplyL = 52,
	PrimaryFuelFlowReturnL = 53,
	PrimaryFuelTank = 62,
	LLSFuelLevelL = 64, // array field
	LLSFuelLevelPercent = 65, // array field
	LLSFuelLevelRelative = 66, // array field
	LLSFuelTemperatureC = 67, // array field
	LLSFuelFrequencyHz = 68, // array field
	LLSFuelDensityKgm3 = 69, // array field
	LLSFuelWeightKg = 70, // array field
	AnalogInput = 71, // array field
	OneWireInput = 72, // array field
	DigitalInput = 73, // array field
	SensorInput = 74, // array field
	CanInput = 75, // array field
	VolgateMv = 76, // array field
	PulseCounter = 77, // array field
	FrequencyHz = 78, // array field
	LoadAxle = 79, // kilograms, array field
	CustomTemperaturesC = 94, // array field
	DoorsOpened = 96, // array field, each one is boolean
	LockState = 97,
	SecondaryFuelTank = 98,
	SecondaryIgnition = 99,
	SecondaryFuelFlowSupplyL = 100,
	SecondaryFuelFlowReturnL = 101,
	BatteryChargePercents = 115,
	CoordinatesSource = 119, // 1 - GPS/GLONASS, 2 - Network(mobile), ...
	PassengersCounter = 142, // array field
	MaxPositiveAccelerationX = 147, // ms2
	MaxNegativeAccelerationX = 148, // ms2
	MaxPositiveAccelerationY = 149, // ms2
	MaxNegativeAccelerationY = 150, // ms2
	MaxPositiveAccelerationZ = 151, // ms2
	MaxNegativeAccelerationZ = 152, // ms2
	InsideTemperatureC = 153,
	HoodOpened = 154, // boolean
	TrunkOpened = 155, // boolean
	BrakePedalPushed = 156, // boolean
	ParkingBrakeActivated = 157, // boolean
	FuelingL = 158,
	FuelingDurationSeconds = 159,
	FuelUsedDeltaL = 160,
	IsMotion = 161, // boolean
	RoadAccidentAlarm = 162,
}
