//
//  EndPointConst.swift
//  Vilanov
//
//  Created by andres on 2/24/19.
//

import Foundation

class EndPointConst {
    
    static func baseUrl() -> String {
        var retorno = ""
        #if DEBUG
        retorno = "https://inmovila.la"
        #endif
        #if RELEASE
        retorno = "https://inmovila.la"
        #endif
        return retorno
    }
    
    static func baseUrlApi() -> String {
        var retorno = ""
        #if DEBUG
        retorno = "https://inmovila-smart-communities.appspot.com/inmovila-rest"
        #endif
        
        #if RELEASE
        retorno = "https://inmovila-smart-communities.appspot.com/inmovila-rest"
        #endif
        return retorno
    }
    
    static let versionApi           : String = "/v1"
    static let version2Api          : String = ""
    static let appQueries           : String = "/appquerys"
    static let imagesUrl            : String = "https://inmovila.la/admin/images/"
    
    class Noticias {
        private static let notices = "/noticias.php"
        //?empresa=Vilanova&tipo=Interes&id=noticias
        static func get(_ empresa: String, _ tipo: String, _ id: String) -> String {
            return notices + "?empresa=\(empresa)&tipo=\(tipo)&id=\(id)"
        }
        //https://inmovila.la/appquerys/noticias.php?empresa=Vilanova&tipo=Interes&id=imgnoticias&id_noticia=id_noticia
        static func getImages(_ empresa: String, _ tipo: String, _ id: String, _ id_noticia: String) -> String {
            return notices + "?empresa=\(empresa)&tipo=\(tipo)&id=imgnoticias&id_noticia=\(id_noticia)"
        }
    }

    // https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/login
    class Auth {
        static let login : String = versionApi + "/login"
        static let logout: String = versionApi + "/logout"
    }
    
    class Affinities {
        static let get : String = versionApi + "/afinidades/"
    }
    
    class Users {
        private static let users : String = "/users"
        static let update : String = versionApi + users + "/update"
        static let updateSecundario : String = versionApi + users + "/updatesecundario"
        static let updatePicture : String = versionApi + users + "/upload_profile_picture"
        static let updatePictureSecundario : String = versionApi + users + "/upload_profile_picturesecundario"
        // /consulta/{conjunto}/{unidad}/{usuario}
        static func getList(_ conjunto: Int, _ unidad: Int, _ usuario: String) -> String {
            let returnString = versionApi + users + "/consulta/\(conjunto)/\(unidad)/\(usuario)"
            return returnString
        }
        
        static let create : String = versionApi + users + "/crear_usuario"
        static let delete : String = versionApi + users + "/delete"
        static let newPass: String = versionApi + users + "/reset_password"

    }

    
    
    class Status {
        static let ok           = 200
        static let created      = 201
        static let badRequest   = 400
        static let unauthorized = 401
        static let forbidden    = 403
        static let notFound     = 404
        static let conflict     = 409
    }
    
    class Response {
        static let estado       : String = "estado"
        static let noticias     : String = "noticias"
        static let data         : String = "data"
        static let titulo       : String = "titulo"
        static let mensaje      : String = "mensaje"
    }
}

//-----------------------------------------------------------------------------------------------
class Headers {
    static let noSession : [String:String] = [
        "Content-Type"  : "application/x-www-form-urlencoded",
        "Accept"        : "application/json"
    ]
    
    func loggedIn() -> [String:String] {
        let loggedIn : [String:String] = [
            "Authorization" : "Bearer " + AppSettings.bearer,
            "Accept"        : "application/json",
            ]
        return loggedIn
    }
    
    func loggedIn_www_Form() ->  [String:String] {
        let loggedIn_www_Form : [String:String] = [
            "Authorization" : "Bearer " + AppSettings.bearer,
            "Content-Type"  : "application/x-www-form-urlencoded",
            "Accept"        : "application/json"
        ]
        return loggedIn_www_Form
    }
    
    static let loggedInJsnToJsn : [String:String] = [
        "Content-Type"  : "application/json",
        "Accept"        : "application/json",
        "Authorization" : "Bearer " + AppSettings.bearer
    ]
}
