namespace cpp dispatch.server.protocols
namespace java dispatch.server.protocols

enum ClientType {
	Unknown,
	Dispatch,
	MapServer,
	TrackReceiver,
}

struct ClientVersion {
	1: i32 majorVersion,
	2: i32 minorVersion,
}

struct ClientId {
	1: ClientType type,
	2: ClientVersion version,
}

struct LicenseId {
	1: string computerId,
	2: string licenseKey,
}

struct License {
	// contains thrift binary buffer of unsecured client specific license data, like DispatchLicenseData
	1: binary license,
	// contains crypted thrift binary buffer of license
	2: binary data,
	3: i32 dataCRC,
}

struct Token {
	// contains crypted thrift binary buffer currently of TokenData
	1: binary data,
	2: i32 dataCRC,
}

struct ClientAuthData {
	1: ClientId clientId,
	2: LicenseId licenseId,
	3: Token token,
}

enum ErrorType {
	AuthorizationFailed,
	InvalidProtocol,
	InternalServerError,
	ServerBusy,
}

exception InvalidOperation {
	1: ErrorType error,
}

//contains in common.License.license and common.License.data for dispatch client
struct DispatchLicenseData {
	1: i32 version,
	2: LicenseId id,
	3: string expiration, // in ISO 8601 format
	4: i32 trackersLimit,
	5: i32 usersLimit,
	6: optional bool chatAccess = true,
	7: optional bool putOnControlAccess = true,
	8: optional bool driverDiagramAccess = true
}

//contains in common.Token.data
struct TokenData {
	1: i32 version,
	2: LicenseId license,
	3: string expiration, // in ISO 8601 format
}
