

struct Session {
    1: string id, //uuid
}

exception BadRequest {
    1: string message, //error info for debug
}

exception InternalServerError {
    1: string message, //error info for debug
}

exception Busy {
    1: string message, //error info for debug
}

exception AccessDenied {
    1: string message, //error info for debug
}

exception UserLicenseExpired {
    1: string message, //error info for debug
}

exception TrialIsNotActivated {
    1: string message, //error info for debug
}

exception LoginFailed {
    1: string message, //error info for debug
}

service DispatchBackend{

    Session login(
        1:string userLoginName,
        2:string password,
        3:bool longSession,
    )
    throws (
        1:BadRequest bre,
        2:Busy bse,
        3:InternalServerError ise,
        4:AccessDenied ade,
        5:UserLicenseExpired ule,
        6:TrialIsNotActivated tne,
        7:LoginFailed lfe,
    ),
}