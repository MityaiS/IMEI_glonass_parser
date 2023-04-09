include "licensecommon.thrift"
namespace cpp dispatch.server.license
namespace java dispatch.server.license

struct ServerStatistics {
	1: i32 companiesCount,
	2: i32 vehiclesCount,
	3: i32 usersCount,
}

service Authenticator {
	licensecommon.License getLicense(
		1:licensecommon.ClientId clientId,
		2:licensecommon.LicenseId licenseId,
		3:ServerStatistics serverStatistics,
	) throws (1:licensecommon.InvalidOperation e),

	// proxy server, specified by proxyId and proxyLicenseId params, gets this token
	// to pass with requests to service provider server, identified by serverId

	// for example, proxy is backend and map server is service, so backend asks token
	// for map server with its client and license ids as proxy params and
	// map server client id as serverId param
	licensecommon.Token getToken(
		1:licensecommon.ClientId proxyId,
		2:licensecommon.LicenseId proxyLicenseId,
		3:licensecommon.ClientId serverId,
		4:ServerStatistics serverStatistics,
	) throws (1:licensecommon.InvalidOperation e),
}
