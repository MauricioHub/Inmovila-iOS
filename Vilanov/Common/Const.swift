//
//  Const.swift
//  Vilanov
//
//  Created by andres on 2/28/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation

class Const {
    static let tituloAviso              = "Aviso!"
    static let sinInternet              = "No se pudo establecer una conexión, intenta otra vez en unos minutos."
    static let mensajeNombreIncompleto  = "Debes ingresar un nombre y un apellido."
    static let mensajeLlenaCampos       = "Debes llenar todos los campos para continuar."
    static let sinAutorizacion          = "No tienes los permisos necesarios para realizar esta acción.\nInicia sesión nuevamente e inténtalo otra vez."
    
    static let timeout                  = "No pudimos establecer una conexión con el servidor (timeout)"
    static let servidorNoResponde       = "No se obtuvo información del servidor"
    static let noInternetTitulo         = "Estás desconectado"
    static let noInternet               = "Por favor verifica tu conexión y vuelve a intentar"
    static let requestFail              = "La petición al servidor no se pudo realizar (Request fail)"
    static let forviden                 = "Acceso no autorizado. Intente iniciar sesión nuevamente."
    static let cerrarSesion             = "¿Estás seguro de serrar tu sesión?"
    static let cerrarSesionFallido      = "Ocurrió un problema al tratar de cerrar sesión, intenta nuevamente en un momento."
    static let botonOkEntiendo      : String = "Ok, entiendo."
    static let botonAceptar         : String = "Aceptar"
    static let botonCancelar        : String = "Cancelar"
    static let botonEliminar        : String = "Eliminar"
    static let botonRegistrar       : String = "Registrar"
    static let botonEditar          : String = "Editar"
    
    static let tituoAlerta          : String = "Alerta"
    static let mostrar              : String = "Mostrar"
    
    static let galeria              : String = "Galería"
    static let camara               : String = "Cámara"
    static let camaraEliminar       : String = "Eliminar"
    static let message_confirm      : String = "¿Deseas enviar la imagen?"
    static let noAdminUserAccess    : String = "Solo un usuario administrador tiene acceso a esta opción."
    
    static let avatarSize           : Int = 400
    
    class HUD {
        static let loginIn          : String = "Iniciando sesión..."
        static let updatePicture    : String = "Actualizando imagen..."
        static let updateUser       : String = "Actualizando usuario..."
        static let createUser       : String = "Creando nuevo usuario..."
        static let newPass          : String = "Cambiando contraseña..."
    }
}
