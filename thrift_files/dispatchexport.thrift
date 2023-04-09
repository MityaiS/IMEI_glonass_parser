
namespace java cz.navitel.dispatch.exportservice
namespace cpp dispatch.exportservice

enum Format { PDF, RTF, XLSX, DOCX }

exception InvalidConversionFormat {}
exception InvalidConfiguration {
    1: string message,
}

exception MissingConfiguration {}
exception ConversionError {
	1: optional string message,
}

service ExportService {
	/// MissingConfiguration is routinely thrown if export server lost its cache (restart, entry replaced).
	binary convert(1:Format format, 2:string configurationId, 3:binary xmlData)
	   throws(1:MissingConfiguration missingError, 2:ConversionError convError),
	/// Server computes configuration identifier and returns it
	string putConfiguration(1:Format format, 2:string name, 3:binary data)
	   throws(1:InvalidConversionFormat typeError, 2:InvalidConfiguration convError),
}
