//
//  AppSettings.swift
//  Vilanov
//
//  Created by andres on 2/24/19.
//

import Foundation
import UIKit

//MARK: User Settings
@objc protocol AppSettingsConfigurable {
    
    //MARK: - get set INTS
    static var expiresIn                : Int { get set }
    static var confPorCorreo            : Int { get set }
    static var confPorPush              : Int { get set }
    static var traceRouteId             : Int { get set }
    static var cantidadgatos            : Int { get set }
    static var cantidadcarros           : Int { get set }
    static var adm                      : Int { get set }
    static var cantidadperros           : Int { get set }
    static var unidad                   : Int { get set }
    static var conjunto                 : Int { get set }
    static var cantidadhijos            : Int { get set }
    static var cantidadadultos          : Int { get set }
    
    //MARK: - STRINGS Authorizations
    static var id_pinlet                : String { get set } //"1_5_andrespaladines@hotmail.com"
    static var placas                   : String { get set }
    
    static var solar                    : String { get set }
    static var url_logo                 : String { get set }
    static var apinNotificationId       : String { get set }
    static var authorizationLogin       : String { get set }
    static var bearer                   : String { get set }
    static var refreshToken             : String { get set }
    static var tokenType                : String { get set }
    static var primerLogin              : String { get set }
    static var tipoAsistencia           : String { get set }
    static var regId                    : String { get set }
    static var promoTiempoExpira        : String { get set }
    static var changePass               : String { get set }
    static var perfilOtros              : String { get set }
    
    //MARK: - Datos Usuario
    static var usuario                  : String { get set }
    static var nombre                   : String { get set }
    static var apellido                 : String { get set }
    static var cedula                   : String { get set }
    static var telefono                 : String { get set }
    static var fechaNacimiento          : String { get set }
    static var correo                   : String { get set }
    static var fotoPerfil               : String { get set }
    static var fotoUidUrl               : String { get set }
    static var apiSeguimientoId         : String { get set }
    static var uidUsuario               : String { get set }
    
    //MARK: - Safe Route
    static var activeRoute              : String { get set }
    static var startLat                 : String { get set }
    static var startLon                 : String { get set }
    static var endLat                   : String { get set }
    static var endLon                   : String { get set }
    
    //MARK: - Strings Recuperacion Clave
    static var correoCambioClave        : String { get set }
    static var correoRecuperacion       : String { get set }
    static var correoRegistro           : String { get set }
    
    //MARK: - Strings Vehiculo unico
    static var color                    : String { get set }
    static var marca                    : String { get set }
    static var subMarca                 : String { get set }
    static var modelo                   : String { get set }
    static var placa                    : String { get set }
    
    //MARK: - Strings Generales
    static var paisId                   : Int    { get set }
    static var codRol                   : String { get set }
    static var confirmed                : String { get set }
    static var nombrePais               : String { get set }
    static var codPais                  : String { get set }
    static var idUsuario                : String { get set }
    static var idSeguimiento            : String { get set }
    static var idPlataforma             : Int    { get set }
    static var bloque                   : String { get set }
    static var tipoUsuario              : String { get set }
    static var tipoComunidad            : String { get set }
    static var comunidad                : String { get set }
    static var manzana                  : String { get set }
    static var villa                    : String { get set }
    static var bodega                   : String { get set }
    static var latitud                  : String { get set }
    static var longitud                 : String { get set }
    static var idPanico                 : String { get set }
    static var logStrings               : String { get set }
    static var cuenta                   : String { get set }
    static var planCodigo               : String { get set }
    static var planDescripcion          : String { get set }
    //MARK: - STRINGS Preferences
    static var recibeEmail              : Int { get set }
    static var recibePush               : Int { get set }
    
    
    //MARK: - STRINGS Configuraciones app
    static var minimumDistanceConsult   : String { get set }
    static var speeding                 : String { get set }
    static var rangeArrival             : String { get set }
    static var apiMap                   : String { get set }
    static var paymentezUrlServer       : String { get set }
    static var paymentezClientAppCode   : String { get set }
    static var paymentezClientSecretKey : String { get set }
    static var paymentezServerAppCode   : String { get set }
    static var paymentezServerSecretKey : String { get set }
    
    
    //MARK: - TIMERS
    static var timerCoordenadas         : Timer? { get set }
    static var timerCoordenadasPanico   : Timer? { get set }
    
    
    //MARK: - BOOLEANS
    static var estaServerRegistered     : Bool { get set }
    static var estaLoggeado             : Bool { get set }
    static var estaTimerPanico          : Bool { get set }
    static var correoValidado           : Bool { get set }
    static var planActivo               : Bool { get set }
    static var esAviso                  : Bool { get set }
    static var becomesFromBackgound     : Bool { get set }
    static var firstOpen                : Bool { get set }
    static var mostrarMenuPrincipal     : Bool { get set }
    
    
    //MARK: - Varios
    static var seguimiento              : [String:Any]      { get set }
    static var imgPublicacionesCached   : [Int:UIImage]     { get set }
    static var imgAvatars               : [String:String]   { get set }
    static var carPlates                : String            { get set }
    static var carPlatesArray           : [String]          { get set }
    static var afinidades               : String            { get set }
    static var afinidadesArray          : [String]          { get set }
    
    //MARK: - PinletViejo
    static var pinletConjunto           : String { get set }
    static var pinletUnidad             : String { get set }
    static var pinletUsuario            : String { get set }
    static var actualPassword           : String { get set }
    
    //MARK: - Dates
    static var loginDate                : Date?  { get set }
}


class AppSettings: NSObject {
    
    fileprivate static func updateDefaults(for key: String, value: Any) {
        // Save value into UserDefaults
        UserDefaults.standard.set(value, forKey: key)
    }
    
    fileprivate static func value<T>(for key: String) -> T? {
        // Get value from UserDefaults
        return UserDefaults.standard.value(forKey: key) as? T
    }
}

extension AppSettings: AppSettingsConfigurable {
    
    //MARK: - get set INTS
    static var cantidadgatos: Int {
        get { return AppSettings.value(for: #keyPath(cantidadgatos)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(cantidadgatos), value: newValue) }
    }
    
    static var cantidadcarros: Int {
        get { return AppSettings.value(for: #keyPath(cantidadcarros)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(cantidadcarros), value: newValue) }
    }
    
    static var adm: Int {
        get { return AppSettings.value(for: #keyPath(adm)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(adm), value: newValue) }
    }
    
    static var cantidadperros: Int {
        get { return AppSettings.value(for: #keyPath(cantidadperros)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(cantidadperros), value: newValue) }
    }
    
    static var unidad: Int {
        get { return AppSettings.value(for: #keyPath(unidad)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(unidad), value: newValue) }
    }
    
    static var conjunto: Int {
        get { return AppSettings.value(for: #keyPath(conjunto)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(conjunto), value: newValue) }
    }
    
    static var cantidadhijos: Int {
        get { return AppSettings.value(for: #keyPath(cantidadhijos)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(cantidadhijos), value: newValue) }
    }
    
    static var cantidadadultos: Int {
        get { return AppSettings.value(for: #keyPath(cantidadadultos)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(cantidadadultos), value: newValue) }
    }
    
    static var expiresIn: Int {
        get { return AppSettings.value(for: #keyPath(expiresIn)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(expiresIn), value: newValue) }
    }
    
    static var confPorCorreo: Int {
        get { return AppSettings.value(for: #keyPath(confPorCorreo)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(confPorCorreo), value: newValue) }
    }
    
    static var confPorPush: Int {
        get { return AppSettings.value(for: #keyPath(confPorPush)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(confPorPush), value: newValue) }
    }
    
    
    //MARK: - get set STRINGS
    
    static var perfilOtros: String {
        get { return AppSettings.value(for: #keyPath(perfilOtros)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(perfilOtros), value: newValue) }
    }
    
    static var id_pinlet: String {
        get { return AppSettings.value(for: #keyPath(id_pinlet)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(id_pinlet), value: newValue) }
    }
    
    static var placas: String {
        get { return AppSettings.value(for: #keyPath(placas)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(placas), value: newValue) }
    }
    
    static var afinidades: String {
        get { return AppSettings.value(for: #keyPath(afinidades)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(afinidades), value: newValue) }
    }
    
    
    
    static var solar: String {
        get { return AppSettings.value(for: #keyPath(solar)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(solar), value: newValue) }
    }
    
    static var url_logo: String {
        get { return AppSettings.value(for: #keyPath(url_logo)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(url_logo), value: newValue) }
    }
    
    static var apinNotificationId: String {
        get { return AppSettings.value(for: #keyPath(apinNotificationId)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(apinNotificationId), value: newValue) }
    }
    
    static var authorizationLogin: String {
        get { return AppSettings.value(for: #keyPath(authorizationLogin)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(authorizationLogin), value: newValue) }
    }
    
    static var bearer: String {
        get { return AppSettings.value(for: "tokenSession") ?? "" }
        set { AppSettings.updateDefaults(for: "tokenSession", value: newValue) }
    }
    
    static var refreshToken: String {
        get { return AppSettings.value(for: #keyPath(refreshToken)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(refreshToken), value: newValue) }
    }
    
    static var tokenType: String {
        get { return AppSettings.value(for: #keyPath(tokenType)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(tokenType), value: newValue) }
    }
    
    static var primerLogin: String {
        get { return AppSettings.value(for: #keyPath(primerLogin)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(primerLogin), value: newValue) }
    }
    
    static var tipoAsistencia: String {
        get { return AppSettings.value(for: #keyPath(tipoAsistencia)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(tipoAsistencia), value: newValue) }
    }
    
    static var uidUsuario: String {
        get { return AppSettings.value(for: #keyPath(uidUsuario)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(uidUsuario), value: newValue) }
    }
    
    static var activeRoute: String {
        get { return AppSettings.value(for: #keyPath(activeRoute)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(activeRoute), value: newValue) }
    }
    
    static var startLat: String {
        get { return AppSettings.value(for: #keyPath(startLat)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(startLat), value: newValue) }
    }
    
    static var startLon: String {
        get { return AppSettings.value(for: #keyPath(startLon)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(startLon), value: newValue) }
    }
    
    static var endLat: String {
        get { return AppSettings.value(for: #keyPath(endLat)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(endLat), value: newValue) }
    }
    
    static var endLon: String {
        get { return AppSettings.value(for: #keyPath(endLon)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(endLon), value: newValue) }
    }
    
    static var correo: String {
        get { return AppSettings.value(for: #keyPath(correo)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(correo), value: newValue) }
    }
    
    static var idSeguimiento: String {
        get { return AppSettings.value(for: #keyPath(idSeguimiento)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(idSeguimiento), value: newValue) }
    }
    
    static var idPlataforma: Int {
        get { return AppSettings.value(for: #keyPath(idPlataforma)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(idPlataforma), value: newValue) }
    }
    
    static var regId: String {
        get { return AppSettings.value(for: #keyPath(regId)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(regId), value: newValue) }
    }
    
    static var promoTiempoExpira: String {
        get { return AppSettings.value(for: #keyPath(promoTiempoExpira)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(promoTiempoExpira), value: newValue) }
    }
    
    static var changePass: String {
        get { return AppSettings.value(for: #keyPath(changePass)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(changePass), value: newValue) }
    }
    
    static var paisId: Int {
        get { return AppSettings.value(for: #keyPath(paisId)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(paisId), value: newValue) }
    }
    
    
    //MARK: - STRINGS Generales
    
    static var codRol: String {
        get { return AppSettings.value(for: #keyPath(codRol)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(codRol), value: newValue)}
    }
    
    static var confirmed: String {
        get { return AppSettings.value(for: #keyPath(confirmed)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(confirmed), value: newValue)}
    }
    
    static var apellido: String {
        get { return AppSettings.value(for: #keyPath(apellido)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(apellido), value: newValue) }
    }
    
    static var marca: String {
        get { return AppSettings.value(for: #keyPath(marca)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(marca), value: newValue) }
    }
    
    static var subMarca: String {
        get { return AppSettings.value(for: #keyPath(subMarca)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(subMarca), value: newValue) }
    }
    
    static var modelo: String {
        get { return AppSettings.value(for: #keyPath(modelo)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(modelo), value: newValue) }
    }
    
    static var placa: String {
        get { return AppSettings.value(for: #keyPath(placa)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(placa), value: newValue) }
    }
    
    static var correoCambioClave: String {
        get { return AppSettings.value(for: #keyPath(correoCambioClave)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(correoCambioClave), value: newValue) }
    }
    
    static var correoRegistro: String {
        get { return AppSettings.value(for: #keyPath(correoRegistro)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(correoRegistro), value: newValue) }
    }
    
    static var correoRecuperacion: String {
        get { return AppSettings.value(for: #keyPath(correoRecuperacion)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(correoRecuperacion), value: newValue) }
    }
    
    static var bloque: String {
        get { return AppSettings.value(for: #keyPath(bloque)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(bloque), value: newValue) }
    }
    
    static var tipoUsuario: String {
        get { return AppSettings.value(for: #keyPath(tipoUsuario)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(tipoUsuario), value: newValue) }
    }
    
    static var tipoComunidad: String {
        get { return AppSettings.value(for: #keyPath(tipoComunidad)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(tipoComunidad), value: newValue) }
    }
    
    static var comunidad: String {
        get { return AppSettings.value(for: #keyPath(comunidad)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(comunidad), value: newValue) }
    }
    
    static var manzana: String {
        get { return AppSettings.value(for: #keyPath(manzana)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(manzana), value: newValue) }
    }
    
    static var villa: String {
        get { return AppSettings.value(for: #keyPath(villa)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(villa), value: newValue) }
    }
    
    static var bodega: String {
        get { return AppSettings.value(for: #keyPath(bodega)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(bodega), value: newValue) }
    }
    
    static var latitud: String {
        get { return AppSettings.value(for: #keyPath(latitud)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(latitud), value: newValue) }
    }
    
    static var longitud: String {
        get { return AppSettings.value(for: #keyPath(longitud)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(longitud), value: newValue) }
    }
    
    static var idPanico: String {
        get { return AppSettings.value(for: #keyPath(idPanico)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(idPanico), value: newValue) }
    }
    
    static var logStrings: String {
        get { return AppSettings.value(for: #keyPath(logStrings)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(logStrings), value: newValue) }
    }
    
    static var cuenta: String {
        get { return AppSettings.value(for: #keyPath(cuenta)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(cuenta), value: newValue) }
    }
    
    static var planCodigo: String {
        get { return AppSettings.value(for: #keyPath(planCodigo)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(planCodigo), value: newValue) }
    }
    
    static var planDescripcion: String {
        get { return AppSettings.value(for: #keyPath(planDescripcion)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(planDescripcion), value: newValue) }
    }
    
    static var recibeEmail: Int {
        get { return AppSettings.value(for: #keyPath(recibeEmail)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(recibeEmail), value: newValue)}
    }
    
    static var recibePush: Int {
        get { return AppSettings.value(for: #keyPath(recibePush)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(recibePush), value: newValue)}
    }
    
    static var traceRouteId: Int {
        get { return AppSettings.value(for: #keyPath(traceRouteId)) ?? 0 }
        set { AppSettings.updateDefaults(for: #keyPath(traceRouteId), value: newValue) }
    }
    
    static var minimumDistanceConsult: String {
        get { return AppSettings.value(for: #keyPath(minimumDistanceConsult)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(minimumDistanceConsult), value: newValue)}
    }
    
    static var speeding: String {
        get { return AppSettings.value(for: #keyPath(speeding)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(speeding), value: newValue)}
    }
    
    static var rangeArrival: String {
        get { return AppSettings.value(for: #keyPath(rangeArrival)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(rangeArrival), value: newValue)}
    }
    
    static var apiMap: String {
        get { return AppSettings.value(for: #keyPath(apiMap)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(apiMap), value: newValue)}
    }
    
    static var paymentezUrlServer: String {
        get { return AppSettings.value(for: #keyPath(paymentezUrlServer)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(paymentezUrlServer), value: newValue)}
    }
    
    static var paymentezClientAppCode: String {
        get { return AppSettings.value(for: #keyPath(paymentezClientAppCode)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(paymentezClientAppCode), value: newValue)}
    }
    
    static var paymentezClientSecretKey: String {
        get { return AppSettings.value(for: #keyPath(paymentezClientSecretKey)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(paymentezClientSecretKey), value: newValue)}
    }
    
    static var paymentezServerAppCode: String {
        get { return AppSettings.value(for: #keyPath(paymentezServerAppCode)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(paymentezServerAppCode), value: newValue)}
    }
    
    static var paymentezServerSecretKey: String {
        get { return AppSettings.value(for: #keyPath(paymentezServerSecretKey)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(paymentezServerSecretKey), value: newValue)}
    }
    
    static var color: String {
        get { return AppSettings.value(for: #keyPath(color)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(color), value: newValue) }
    }
    
    static var nombrePais: String {
        get { return AppSettings.value(for: #keyPath(nombrePais)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(nombrePais), value: newValue) }
    }
    
    static var codPais: String {
        get { return AppSettings.value(for: #keyPath(codPais)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(codPais), value: newValue) }
    }
    
    static var usuario: String {
        get { return AppSettings.value(for: #keyPath(usuario)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(usuario), value: newValue) }
    }
    
    static var idUsuario: String {
        get { return AppSettings.value(for: #keyPath(idUsuario)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(idUsuario), value: newValue) }
    }
    
    static var nombre: String {
        get { return AppSettings.value(for: #keyPath(nombre)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(nombre), value: newValue) }
    }
    
    static var cedula: String {
        get { return AppSettings.value(for: #keyPath(cedula)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(cedula), value: newValue) }
    }
    
    static var telefono: String {
        get { return AppSettings.value(for: #keyPath(telefono)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(telefono), value: newValue) }
    }
    
    static var fechaNacimiento: String {
        get { return AppSettings.value(for: #keyPath(fechaNacimiento)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(fechaNacimiento), value: newValue) }
    }
    
    static var fotoPerfil: String {
        get { return AppSettings.value(for: #keyPath(fotoPerfil)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(fotoPerfil), value: newValue) }
    }
    
    static var fotoUidUrl: String {
        get { return AppSettings.value(for: #keyPath(fotoUidUrl)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(fotoUidUrl), value: newValue) }
    }
    
    static var apiSeguimientoId: String {
        get { return AppSettings.value(for: #keyPath(apiSeguimientoId)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(apiSeguimientoId), value: newValue) }
    }
    
    //MARK: - get set TIMERS
    static var timerCoordenadas: Timer? {
        get { return AppSettings.value(for: #keyPath(timerCoordenadas)) ?? nil }
        set { AppSettings.updateDefaults(for: #keyPath(timerCoordenadas), value: newValue!)}
    }
    
    static var timerCoordenadasPanico: Timer? {
        get { return AppSettings.value(for: #keyPath(timerCoordenadasPanico)) ?? nil }
        set { AppSettings.updateDefaults(for: #keyPath(timerCoordenadasPanico), value: newValue!)}
    }
    
    
    //MARK: - get set BOOLEANS
    static var estaServerRegistered: Bool {
        get { return AppSettings.value(for: #keyPath(estaServerRegistered)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(estaServerRegistered), value: newValue)}
    }
    
    static var estaLoggeado: Bool {
        get { return AppSettings.value(for: #keyPath(estaLoggeado)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(estaLoggeado), value: newValue)}
    }
    
    static var estaTimerPanico: Bool {
        get { return AppSettings.value(for: #keyPath(estaTimerPanico)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(estaTimerPanico), value: newValue)}
    }
    
    static var correoValidado: Bool {
        get { return AppSettings.value(for: #keyPath(correoValidado)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(correoValidado), value: newValue) }
    }
    
    static var planActivo: Bool {
        get { return AppSettings.value(for: #keyPath(planActivo)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(planActivo), value: newValue) }
    }
    
    static var esAviso: Bool {
        get { return AppSettings.value(for: #keyPath(esAviso)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(esAviso), value: newValue) }
    }
    
    static var becomesFromBackgound: Bool {
        get { return AppSettings.value(for: #keyPath(becomesFromBackgound)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(becomesFromBackgound), value: newValue) }
    }
    
    static var firstOpen: Bool {
        get { return AppSettings.value(for: #keyPath(firstOpen)) ?? false }
        set { AppSettings.updateDefaults(for: #keyPath(firstOpen), value: newValue) }
    }
    
    static var mostrarMenuPrincipal: Bool {
        get { return AppSettings.value(for: "mostrarMenuPrincipal") ?? false }
        set { AppSettings.updateDefaults(for: "mostrarMenuPrincipal", value: newValue) }
    }
    
    //MARK: - get set VARIOS
    static var seguimiento: [String:Any] {
        get { return AppSettings.value(for: #keyPath(seguimiento)) ?? [String:AnyObject]() }
        set { AppSettings.updateDefaults(for: #keyPath(seguimiento), value: newValue) }
    }
    static var imgPublicacionesCached: [Int:UIImage] {
        get { return AppSettings.value(for: #keyPath(imgPublicacionesCached)) ?? [Int:UIImage]() }
        set { AppSettings.updateDefaults(for: #keyPath(imgPublicacionesCached), value: newValue) }
    }
    
    static var imgAvatars: [String:String] {
        get { return AppSettings.value(for: #keyPath(imgAvatars)) ?? [String:String]() }
        set { AppSettings.updateDefaults(for: #keyPath(imgAvatars), value: newValue) }
    }
    
    static var carPlatesArray: [String] {
        get { return AppSettings.value(for: #keyPath(carPlatesArray)) ?? [String]() }
        set { AppSettings.updateDefaults(for: #keyPath(carPlatesArray), value: newValue) }
    }
    
    static var afinidadesArray: [String] {
        get { return AppSettings.value(for: #keyPath(afinidadesArray)) ?? [String]() }
        set { AppSettings.updateDefaults(for: #keyPath(afinidadesArray), value: newValue) }
    }
    
    static var carPlates: String {
        get { return AppSettings.value(for: #keyPath(carPlates)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(carPlates), value: newValue) }
    }
    
    
    
    ////MARK: - PinletViejo
    static var pinletConjunto: String {
        get { return AppSettings.value(for: #keyPath(pinletConjunto)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(pinletConjunto), value: newValue)}
    }
    static var pinletUnidad: String {
        get { return AppSettings.value(for: #keyPath(pinletUnidad)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(pinletUnidad), value: newValue)}
    }
    static var pinletUsuario: String {
        get { return AppSettings.value(for: #keyPath(pinletUsuario)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(pinletUsuario), value: newValue)}
    }
    static var actualPassword: String {
        get { return AppSettings.value(for: #keyPath(actualPassword)) ?? "" }
        set { AppSettings.updateDefaults(for: #keyPath(actualPassword), value: newValue)}
    }
    
    //MARK: - Dates
    static var loginDate: Date? {
        get { return AppSettings.value(for: #keyPath(loginDate)) ?? nil }
        set { AppSettings.updateDefaults(for: #keyPath(loginDate), value: newValue!)}
    }
}

//MARK: FOMRA DE USO:
/*
 SET:
 AppSettings.pinletUsuario = "usuario"
 
 GET:
 let usuario = AppSettings.pinletUsuario
 */
