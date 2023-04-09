namespace cpp dispatch.server.prolongation
namespace java dispatch.server.prolongation

// какой пользователь и для какой компании совершает покупку
struct PersonalInfo {
	1:string companyId, // уникальная непустая строка, идентифицирующая компанию в ДС
	2:string userId,    // уникальная непустая строка, идентифицирующая пользователя в ДС
}

struct PersonalAdditionalInfo {
	1:string companyName, // Название компании
	2:string userLogin, // Логин пользователя, не бывает пустым
	3:string userWelcomeName, // ФИО, может быть пустой строкой
}

// лицензионные лимиты компании
struct LicenseLimits {
	// срок окончания лицензии в формате iso8601
	1:optional string licenseEndDatetime,
}

// дополнительная информации о лицензии
struct LicenseInfo {
	1:LicenseLimits limits,
	// флаг, что лицензия триальная
	2:bool isTrial,
}

// агрегат персональной информации и информации по лимитам
struct ClientInfo {
	1:PersonalInfo personal,
	2:LicenseInfo license,
	3:PersonalAdditionalInfo additional,
}

// как именно надо проапгрейдить лицензию
struct LimitUpgrade {
	// на сколько дней продлить лицензию
	1:i32 licenseProlongation,
}

// информация о покупке
struct PurchaseInfo {
	// уникальный идентификатор площадки (Плейстор, Авангейт, Пэйпро и т. д.), где куплен продукт
	1:string marketId,
	// уникальная транзакция покупки на площадке
	2:string marketTx,
}

enum ErrorType {
	AuthorizationFailed,
	InvalidProtocol,
	InternalServerError,
	ServerBusy,
	NonExpiringLicense,
}

exception InvalidOperation {
	1: ErrorType error,
}

/**
* Сервис апгрейда лицензий. Все его методы - синхронные.
*/
service Prolongator {

	/**
	 * получить информацию о покупателе по токену
	 *
	 * @param apiKey - идентифицирующий пользователя токен. Годным токеном будет как "обычный",
	 *                 так и "ограниченный" токен. Последний выдаётся просрочившим платёж пользователям
	 *                 и валиден только для этого вызова.
	 *
	 * возвращает агрегат персональной информации и информации по лимитам
	 * или выбрасывает исключение с кодом ошибки (например, когда apiKey не валиден)
	 */
	ClientInfo getClientInfo(
		1:string apiKey,
	) throws (1:InvalidOperation e),

	/**
	 * раздвинуть лицензионные лимиты для данной компании. Этот запрос может повторяться
	 * с одним и тем же purchase (см. ниже), пока диспетчерская система не даст содержательный ответ на запрос
	 * (положительный или отрицательный)
	 *
	 * @param personal - пара пользователь / компания. Если она стала невалидной,
	 *                   сервер выбросит исключение типа AuthorizationFailed
	 * @param upgrade  - как именно надо проапгрейдить лицензию
	 * @param purchase - информация о покупке
	 *
	 * @returns актуальная информация о компании в случае успешного продления
	 * @throws исключение с кодом ошибки в противном случае
	 */
	LicenseInfo extendLimits(
		1:PersonalInfo personal,
		2:LimitUpgrade upgrade,
		3:PurchaseInfo purchase,
	) throws (1:InvalidOperation e),
}
