//
//  usuarios_edit_com.swift
//  Vilanov
//
//  Created by Daniel on 27/02/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SDWebImage

class usuarios_edit_com: UIViewController {

    //Second ViewController
    @IBOutlet weak var pic_user         : UIImageView!
    @IBOutlet weak var qr_user          : UIImageView!
    @IBOutlet weak var userNameLabel    : UILabel!
    @IBOutlet weak var userAdderssLabel : UILabel!
    
    //First ViewController
    @IBOutlet weak var userName     : DisenoTextField!
    @IBOutlet weak var userPhone    : DisenoTextField!
    @IBOutlet weak var userEmail    : DisenoTextField!
    @IBOutlet weak var button_check : UIButton!
    
    var isAdmin = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(self.pic_user != nil) {
            self.pic_user.layer.cornerRadius    = (self.pic_user.frame.size.width / 2)
            self.pic_user.clipsToBounds         = true
            self.pic_user.layer.borderWidth     = 3.0
            self.pic_user.layer.borderColor     = UIColor(hex: 0xf2f2f2).cgColor
            if let url = URL(string: AppSettings.fotoUidUrl) {
                pic_user.sd_setImage(with: url, placeholderImage: UIImage(named: "usuarios_preuser_pic"), options: .forceTransition, completed: nil)
            }else if !AppSettings.fotoPerfil.isEmpty {
                let fotoPerfil = UIImage(data: (AppSettings.fotoPerfil.fromBase64()?.data(using: String.Encoding.utf8))!)!
                pic_user.image = fotoPerfil
            }
            self.userNameLabel.text = AppSettings.nombre + " " + AppSettings.apellido
            self.userAdderssLabel.text = AppSettings.solar
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func button_check(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func goBackAction(_ sender: UIButton) {
        self.goBack()
    }
    
    @IBAction func dismissView(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func createUserAction(_ sender: Any) {
        if(!TextValidationHelper.isValidEmail(testStr: userEmail.text!)) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "El correo electrónico no es válido.")
            return
        }
        
        if(!TextValidationHelper.isValidPhone(value: userPhone.text!)) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "El número telefónico no es válido.")
            return
        }
        
        var username = userName.text!
        username = username.replacingOccurrences(of: " ", with: " ")
        let userArray = username.components(separatedBy: " ")
        if( userArray.count <= 1) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "Ingresa un nombre y un apellido")
            return
        }
        
        self.isAdmin = (button_check.isSelected ? "0" : "1")
        self.createUser()
    }
    
    @IBAction func ir_editadd_user(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios_editadd", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "editadd")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: true)
    }
    
    @IBAction func closeSessionAction(_ sender: UIButton) {
        let siButton = UIAlertAction(title: "Si", style: .destructive) {
            action in
            self.closeSession()
        }
        let noButton = UIAlertAction(title: "No", style: .default, handler: nil)
        MyAlert.alert(view: self, title: Const.tituloAviso, message: Const.cerrarSesion, buttons: [siButton,noButton], style: .alert)
    }
    
    func dismissAllViews() {
        ( self.dismiss(animated: true, completion: nil) )
    }

    func eraseSessionData() {
        let regId = AppSettings.regId
        if let bundle = Bundle.main.bundleIdentifier {
            UserDefaults.standard.removePersistentDomain(forName: bundle)
            UserDefaults.standard.synchronize()
            AppSettings.regId = regId
            AppSettings.bearer = ""
            AppSettings.mostrarMenuPrincipal = true
        }
//        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
    }
    
    func goBack() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
}

typealias usuarios_edit_com_http = usuarios_edit_com
extension usuarios_edit_com_http {
    
    func createUser() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/crear_usuario
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.create
        let headers = Headers().loggedIn()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            "usuariocreado" : self.userEmail.text!,
            "administrador" : self.isAdmin,
            "nombrecompleto": self.userName.text!,
            "telefono"      : self.userPhone.text!,
        ]
        HUD.show(.label(Const.HUD.createUser))
        Alamofire.request(url, method: .post, parameters: parametros, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
                HUD.hide()
                let fecha = Date().description
                let statusCode = "(\(response.response?.statusCode ?? 777)): "
                switch response.result {
                case .success :
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let titulo      = Const.tituloAviso
                        let mensaje     = Const.servidorNoResponde
                        let estado      = Int(json[EndPointConst.Response.estado].string ?? "777")!
                        if( estado == 200 || estado == 201 ) {
                            let alertC = UIAlertController(title: "Exito!", message: "Tu usuario fue creado correctamente.", preferredStyle: UIAlertControllerStyle.alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                                self.goBack()
                            })
                            alertC.addAction(defaultAction)
                            self.present(alertC, animated: true , completion: nil)
                            
                        }else {
                            MyAlert.alertDefault(view: self, titulo: titulo, mensaje: mensaje)
                            return
                        }
                    }
                    break
                    
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.timeout)
                    }else {
                        print("Peticion fallida")
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.sinInternet)
                    }
                    break
                }
            }
        }
    }
    
    func closeSession() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/crear_usuario
        let url = EndPointConst.baseUrlApi() + EndPointConst.Auth.logout
        let headers = Headers().loggedIn()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            ]
        HUD.show(.label(Const.HUD.createUser))
        Alamofire.request(url, method: .post, parameters: parametros, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
                HUD.hide()
                switch response.result {
                case .success :
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let titulo      = Const.tituloAviso
                        let mensaje     = Const.servidorNoResponde
                        let estado      = Int(json[EndPointConst.Response.estado].string ?? "777")!
                        if( estado == 200 || estado == 201 ) {
                            self.dismissAllViews()
                            self.eraseSessionData()
                        }else {
                            let btnAccept = UIAlertAction(title: Const.botonOkEntiendo, style: .default, handler: {
                                action in
//                                self.dismissAllViews()
//                                self.eraseSessionData()
                            })
                            MyAlert.alert(view: self, title: Const.tituloAviso, message: Const.cerrarSesionFallido, buttons: [btnAccept], style: .alert)
                            print("No Pudo cerrar sesion..")
                        }
                    }
                    break
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.timeout)
                    }else {
                        print("Peticion fallida")
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.sinInternet)
                    }
                    break
                }
            }
        }
    }
}
