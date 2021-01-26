//
//  usuarios.swift
//  Vilanov
//
//  Created by Daniel on 24/02/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SDWebImage

class usuariosController: UIViewController{
    //Vista 1
    @IBOutlet weak var emailTextView        : DisenoTextField!
    @IBOutlet weak var passTextField        : DisenoTextField!
    //ventana 2
    @IBOutlet weak var confirmNameTextField : DisenoTextField!
    @IBOutlet weak var confirmEmailTextField: DisenoTextField!
    @IBOutlet weak var confirmPhoneTextField: DisenoTextField!
    //ventana 3
    @IBOutlet weak var pic_user             : UIImageView!
    let imagePicker             = UIImagePickerController()
    var eleccionImagenCamara    = false
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.setDataView_1()
        self.setDataView_2()
        self.setDataView_3()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func recover_pass_load(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "recover_pass_succ")
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type     = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false)
    }
    
    @IBAction func recover_pass(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "recover_pass")
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type     = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false)
    }
    
    
}

//MARK: - Ventana 1
typealias LoginView_1 = usuariosController
extension LoginView_1 {
    
    @IBAction func ir_confirm(_ sender: Any) {
        self.login()
    }
    func setDataView_1() {
        guard let _ = emailTextView else { return }
        self.emailTextView.text = ""
        guard let _ = passTextField else { return }
        self.passTextField.text = ""
    }
    
    func goToView_2() {
        if(self.emailTextView.text!.isEmpty || passTextField.text!.isEmpty) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.mensajeLlenaCampos)
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "login_confirm_datos")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type     = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    
    func goToNewPass() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "NewPassViewController") as! NewPassViewController
        vc.fromLogin = true
        let transition = CATransition()
        transition.duration = 0.4
        transition.type     = kCATransitionMoveIn
        transition.subtype  = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(vc, animated: false)
    }
}

//MARK: - Ventana intemedia para cambiar clave
typealias LoginView_1_5 = usuariosController
extension LoginView_1_5 {
////     esta ventana esta separada ya que no fue prevista desde el inicio (NewPassViewController)
}

//MARK: - Segunda ventana
typealias LoginView_2 = usuariosController
extension LoginView_2 {
    
    func setDataView_2() {
        guard let _ = confirmNameTextField else { return }
        self.confirmNameTextField.text = AppSettings.nombre + " " + AppSettings.apellido
        guard let _ = confirmEmailTextField else { return }
        self.confirmEmailTextField.text = AppSettings.correo
        guard let _ = confirmPhoneTextField else { return }
        self.confirmPhoneTextField.text = AppSettings.telefono
        if(AppSettings.adm == 0) {
            self.confirmNameTextField.isEnabled = false
            self.confirmEmailTextField.isEnabled = false
            self.confirmPhoneTextField.isEnabled = false
        }
    }
    
    @IBAction func ir_loadpic(_ sender: Any) {
        
        let fullName    = self.confirmNameTextField.text!
        let correo      = self.confirmEmailTextField.text!
        let phone       = self.confirmPhoneTextField.text!
        if( fullName.count < 2 || correo.isEmpty || phone.isEmpty) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.mensajeLlenaCampos)
            return
        }
        
        let words = fullName.components(separatedBy: " ")
        if(words.count < 2) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.mensajeNombreIncompleto)
            return
        }
        let lastName = String(words.last ?? "")
        let lastNameArray = words.prefix(words.count - 1)
        let fistName = lastNameArray.joined(separator: " ")
        AppSettings.nombre = fistName
        AppSettings.apellido = lastName
        
        if(!TextValidationHelper.isValidEmail(testStr: correo)) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "El correo electrónico no es válido.")
            return
        }
        
        if(!TextValidationHelper.isValidPhone(value: phone)) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "El número telefónico no es válido.")
            return
        }
        
        AppSettings.correo      = correo
        AppSettings.telefono    = phone
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "login_load_pic")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
}

//MARK: - Tercera ventana (imagen perfil)
typealias LoginView_3 = usuariosController
extension LoginView_3 {
    //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/upload_profile_picture
    
    func setDataView_3() {
        if (self.pic_user != nil) {
            self.pic_user.layer.cornerRadius = (self.pic_user.frame.size.width) / 2
            self.pic_user.clipsToBounds = true
            self.pic_user.layer.borderWidth = 3.0
            self.pic_user.layer.borderColor = UIColor.backgroundImage().cgColor
            
            let tapGestureRecognizer_camera = UITapGestureRecognizer(target: self, action: #selector(self.cargarImagen))
            pic_user.isUserInteractionEnabled = true
            pic_user.addGestureRecognizer(tapGestureRecognizer_camera)
            
            if let url = URL(string: AppSettings.fotoUidUrl) {
                pic_user.sd_setImage(with: url, placeholderImage: UIImage(named: "usuarios_preuser_pic"), options: .forceTransition, completed: nil)
            }
        }
    }
    
    @IBAction func ir_loginform(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "login_form")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    
    @IBAction func `return`(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
}

typealias LoginHttpRequests = usuariosController
extension LoginHttpRequests {
    
    func login() {
        let headers     = Headers.noSession
        let url         = EndPointConst.baseUrlApi() + EndPointConst.Auth.login
        let parameters  = [
            "conjunto"  : "1",
            "usuario"   : self.emailTextView.text!.trimmingCharacters(in: .whitespaces),
            "password"  : self.passTextField.text!.trimmingCharacters(in: .whitespaces),
            "tokenfirebase": AppSettings.regId
        ]
        
        if !Accesibilidad.tieneInternet() {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.sinInternet)
            return
        }
        HUD.show(.label(Const.HUD.loginIn))
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
                HUD.hide()
                let statusCode = "(\(response.response?.statusCode ?? 777)): "
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let estado      = Int(json[EndPointConst.Response.estado].string ?? "777")!
                        let titulo      = Const.tituloAviso
                        let mensaje     = json[EndPointConst.Response.noticias].string ?? Const.sinInternet
                        if( estado == EndPointConst.Status.ok || estado == EndPointConst.Status.created ) {
                            let data        = json["data"]
                            self.loginSuccess(data: data)
                        } else if(estado == EndPointConst.Status.unauthorized) {
                            MyAlert.alertDefault(view: self, titulo: titulo, mensaje: mensaje)
                        }else {
                            MyAlert.alertDefault(view: self, titulo: titulo, mensaje: mensaje)
                            return
                        }
                    }
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
    
    func loginSuccess(data: JSON) {
        AppSettings.bearer          = data["pinletToken"].string ?? ""
        print(data["pinletToken"].string ?? "")
        AppSettings.changePass      = data["cambio_clave"].string ?? "N"
        let residentInfo = data["informacion_residente"]
        AppSettings.cantidadgatos   = residentInfo["cantidadgatos"].int ?? 0
        AppSettings.cantidadcarros  = residentInfo["cantidadcarros"].int ?? 0
        AppSettings.adm             = residentInfo["adm"].int ?? 0
        AppSettings.cantidadperros  = residentInfo["cantidadperros"].int ?? 0
        AppSettings.unidad          = residentInfo["unidad"].int ?? 0
        AppSettings.conjunto        = residentInfo["conjunto"].int ?? 0
        AppSettings.cantidadhijos   = residentInfo["cantidadhijos"].int ?? 0
        AppSettings.cantidadadultos = residentInfo["cantidadadultos"].int ?? 0
        
        AppSettings.fechaNacimiento = residentInfo["fechanacimiento"].string ?? ""
        AppSettings.id_pinlet       = residentInfo["id_pinlet"].string ?? "" // "1_5_andrespaladines@hotmail.com"
        AppSettings.carPlates       = residentInfo["placas"].string ?? ""
        AppSettings.afinidades      = residentInfo["afinidades"].string ?? ""
        AppSettings.solar           = residentInfo["solar"].string ?? ""
        AppSettings.url_logo        = residentInfo["url_logo"].string ?? ""
        
        AppSettings.telefono        = residentInfo["telefono"].string ?? ""
        AppSettings.nombre          = residentInfo["nombre"].string ?? ""
        AppSettings.usuario         = residentInfo["usuario"].string ?? ""
        AppSettings.apellido        = residentInfo["apellido"].string ?? ""
        AppSettings.fotoUidUrl      = residentInfo["imagenperfil"].string ?? ""

        let correo = AppSettings.id_pinlet.components(separatedBy: "_").last ?? ""
        AppSettings.correo = correo
        let carsArray       = AppSettings.carPlates.components(separatedBy: ",")
        AppSettings.carPlatesArray  = carsArray
        let affinitiesArray = AppSettings.afinidades.components(separatedBy: ",")
        AppSettings.afinidadesArray = affinitiesArray
        UserDefaults.standard.synchronize()
//        self.goToView_2()
        self.goToNewPass()
    }
    
    func updateProfilePicture() {
        if !Accesibilidad.tieneInternet() {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.sinInternet)
            return
        }
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/upload_profile_picture
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.updatePicture
        let headers = Headers().loggedIn_www_Form()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            "imagen"        : AppSettings.fotoPerfil
        ]
        HUD.show(.label(Const.HUD.updatePicture))
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
                            let data = json["data"]
                            let urlPicture = data["profilepic"].string ?? ""
                            AppSettings.fotoUidUrl = urlPicture
                            let alertC = UIAlertController(title: "Éxito!", message: "Foto de perfil actualizada.", preferredStyle: UIAlertControllerStyle.alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
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
                    } else {
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.servidorNoResponde)
                        print("\(fecha): No se obtuvo una del servidor...")

                    }

                    break
                }
            }
        }
    }
}

//MARK: - ImagePicker
typealias LoginImagePicker = usuariosController
extension LoginImagePicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func cargarImagen() {
        
        var alertaBotones = [UIAlertAction]()
        alertaBotones.append(UIAlertAction(title: Const.botonCancelar, style: .cancel) {action in})
        alertaBotones.append(UIAlertAction(title: Const.galeria, style: .default) { action in
            self.abrirGaleria()
        })
        alertaBotones.append(UIAlertAction(title: Const.camara, style: .default) { action in
            self.abrirCamara()
        })
        let img = UIImage(named: "usuarios_preuser_pic")
        //Now check if the img has changed or not:
        if pic_user.image != img {
            alertaBotones.append(UIAlertAction( title : Const.camaraEliminar,
                                                style : .default) { action in
                                                    self.eliminarImagen()
            })
        }
        MyAlert.alert(view: self, title: Const.tituloAviso, message: Const.message_confirm, buttons: alertaBotones, style: .actionSheet)
    }
    
    func abrirGaleria() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func abrirCamara() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        eleccionImagenCamara = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func eliminarImagen() {
        pic_user.image = UIImage(named: "usuarios_preuser_pic")
        AppSettings.fotoPerfil = ""
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.dismiss(animated: true, completion: nil)
        var  guardaImagen: UIImage?
        imagePicker.dismiss(animated: true, completion: nil)
        //        imgImagen.contentMode = UIView.ContentMode.center
        
        if let image = info[UIImagePickerControllerEditedImage] as! UIImage? {
            self.pic_user.contentMode = .scaleAspectFit
            self.pic_user.image = image
            AppSettings.fotoPerfil = UIImageHelper.imageToBase64(image: image, width: 400)!
            self.updateProfilePicture()
        } else {
            print("Something went wrong")
        }
        
        if eleccionImagenCamara {
            guardaImagen = info[UIImagePickerControllerEditedImage] as! UIImage?
            UIImageWriteToSavedPhotosAlbum(guardaImagen!, nil, nil, nil)
            eleccionImagenCamara = false
        }
    }
    
    
}

