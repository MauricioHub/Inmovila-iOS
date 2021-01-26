//
//  NewPassViewController.swift
//  Vilanov
//
//  Created by andres on 3/15/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import Alamofire
import PKHUD

class NewPassViewController: UIViewController {

    @IBOutlet weak var nombreLabel: UILabel!
    @IBOutlet weak var newPassLabel         : DisenoTextField!
    @IBOutlet weak var newPassConfirmLabel  : DisenoTextField!
    @IBAction func continueAction(_ sender: UIButton) {
        self.validateFields()
    }
    @IBAction func goBackAction(_ sender: UIButton) {
        self.goBack()
    }
    
    var fromLogin = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.nombreLabel.text = "Hola \(AppSettings.nombre)"
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func validateFields() {
        let pass_1  = self.newPassLabel.text!
        let pass_2  = self.newPassConfirmLabel.text!
        if(!TextValidationHelper.isPasswordSame(password: pass_1, confirmPassword: pass_2)) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "El número telefónico no es válido.")
            return
        }
        if pass_1.count < 3 {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "Ingresa una contraseña con tres dígitos como mínimo.")
            return
        }
        self.changePass(with: pass_1)
    }
    
    func finishNewPass() {
        if fromLogin {
            self.goToView_2()
        }else {
            self.goBack()
        }
    }
    
    func goBack() {
        if fromLogin {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromTop
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: nil)
        }else {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromLeft
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.dismiss(animated: false, completion: nil)
        }
    }

    func goToView_2() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "login_confirm_datos")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type     = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
}

typealias NewPassHttp = NewPassViewController
extension NewPassHttp {
    
    func changePass(with pass: String) {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/delete
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.newPass
        let headers = Headers().loggedIn()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            "password"      : pass
        ]
        HUD.show(.label(Const.HUD.newPass))
        Alamofire.request(url, method: .post, parameters: parametros, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
                HUD.hide()
                let statusCode = "(\(response.response?.statusCode ?? 777)): "
                let fecha = Date().description
                switch response.result {
                case .success :
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let titulo      = Const.tituloAviso
                        let mensaje     = Const.servidorNoResponde
                        let estado      = Int(json[EndPointConst.Response.estado].string ?? "777")!
                        if( estado == 200 || estado == 201 ) {
                            let data            = json["data"]
                            AppSettings.bearer  = data["pinletToken"].string ?? ""
                            UserDefaults.standard.synchronize()
                            let alertC = UIAlertController(title: "Cambio de clave", message: "Cambiaste la clave con éxito.", preferredStyle: UIAlertControllerStyle.alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                                self.finishNewPass()
                            })
                            alertC.addAction(defaultAction)
                            self.present(alertC, animated: true , completion: nil)
                            
                        }else if(estado == 403) {
                            MyAlert.alertDefault(view: self, titulo: titulo, mensaje: Const.sinAutorizacion)
                            return
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
    
}
