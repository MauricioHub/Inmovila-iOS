//
//  usuarios_editadd_second.swift
//  Vilanov
//
//  Created by Daniel on 27/02/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SDWebImage

class usuarios_editadd_second: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var height_delete_content    : NSLayoutConstraint!
    @IBOutlet weak var height_content_picker    : NSLayoutConstraint!
    @IBOutlet weak var height_date_picker       : NSLayoutConstraint!
    @IBOutlet weak var height_picker            : NSLayoutConstraint!
    @IBOutlet weak var height_content_car       : NSLayoutConstraint!

    
    @IBOutlet weak var editarButton : UIButton!
    @IBOutlet weak var pic_user     : UIImageView!
    @IBOutlet weak var date_picker  : UIDatePicker!
    @IBOutlet weak var txtactive    : UIButton!
    @IBOutlet weak var PickerView   : UIPickerView!
    @IBOutlet weak var content_car  : UIView!
    @IBOutlet weak var txt_name     : UILabel!
    
    @IBOutlet weak var delet_com    : UIView!
    @IBOutlet weak var check_admin  : UIButton!
    @IBOutlet weak var txt_date     : UIButton!
    @IBOutlet weak var txt_adultos  : UIView!
    @IBOutlet weak var txt_ninos    : UIView!
    @IBOutlet weak var txt_tel      : UITextField!
    @IBOutlet weak var txt_mail     : UITextField!
    @IBOutlet weak var txt_lugar    : UITextField!
    @IBOutlet weak var txt_cars     : UIView!
    @IBOutlet weak var txt_perros   : UIView!
    @IBOutlet weak var txt_gatos    : UIView!
    @IBOutlet weak var txt_otrosmasc: UIView!
    @IBOutlet weak var check_gym    : UIView!
    @IBOutlet weak var check_cine   : UIView!
    @IBOutlet weak var check_yoga   : UIView!
    @IBOutlet weak var check_mascotas: UIView!
    
    @IBOutlet weak var collectionView       : UICollectionView!
    @IBOutlet weak var collectionViewHeight : NSLayoutConstraint!
    
    var userSelected    : User!
    var listItems       : [Affinity]    = []
    let number_pickers  = ["0","1","2","3","4","5","6","7","8","9"]
    var contents_edit   = [UIView?]()
    var isSditing       = false
    
    var userPhone       = ""
    var userMail        = ""
    var userLocation    = ""
    var affinities      = ""
    var userBirthDate   = ""
    var userIsAdmin     = ""
    var userName        = ""
    var affinitiesArray : [String] = []
    
    let imagePicker             = UIImagePickerController()
    var eleccionImagenCamara    = false
    var fotoUidUrl              = ""
    var fotoPerfil              = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        self.cargarDatos()
        self.stylishView()
        self.configurarCollectionView()
        self.initListItems()
        self.txt_lugar.isEnabled = false
    }
    
    func cargarDatos() {
        let birthDate = userSelected.usuarioFechaNacimiento.isEmpty ? "yyyy/mm/dd" : userSelected.usuarioFechaNacimiento
        check_admin.isSelected = (userSelected.usuarioAdm == 1 ? false : true)
        txt_date.setTitle(birthDate, for: .normal)
        txt_tel.text    = userSelected.usuarioTel
        txt_mail.text   = userSelected.correoUsuario
        txt_lugar.text  = userSelected.descripciónUnidad
        txt_name.text   = "\(userSelected.nombre) \(userSelected.apellido)"
        
        if let url = URL(string: userSelected.usuarioProfilePic) {
            pic_user.sd_setImage(with: url, placeholderImage: UIImage(named: "usuarios_preuser_pic"), options: .forceTransition, completed: nil)
        }
        
    }
    
    func stylishView() {
        if (self.pic_user != nil) {
            self.pic_user.layer.cornerRadius = (self.pic_user.frame.size.width) / 2
            self.pic_user.clipsToBounds = true
            self.pic_user.layer.borderWidth = 3.0
            self.pic_user.layer.borderColor = UIColor(hex: 0xf2f2f2).cgColor
            let tapGestureRecognizer_camera = UITapGestureRecognizer(target: self, action: #selector(self.cargarImagen))
            pic_user.isUserInteractionEnabled = true
            pic_user.addGestureRecognizer(tapGestureRecognizer_camera)
        }
        
        if (self.date_picker != nil) {
            date_picker.addTarget(self, action: #selector(usuarios_formController.datePickerChanged), for: UIControlEvents.valueChanged)
        }
        
        if (self.txt_lugar != nil) {
            txt_mail.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
            txt_mail.leftViewMode = .always
            txt_mail.layer.cornerRadius = 10

            txt_tel.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
            txt_tel.leftViewMode = .always
            txt_tel.layer.cornerRadius = 10

            txt_lugar.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
            txt_lugar.leftViewMode = .always
            txt_lugar.layer.cornerRadius = 10
        }
        //txtpo.leftViewMode = .always
        /*txtpm.leftView = leftView
         txtpm.leftViewMode = .always
         txtpt.leftView = leftView
         txtpt.leftViewMode = .always
         txtpl.leftView = leftView
         txtpl.leftViewMode = .always*/
    }
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        self.goBackFunc()
    }
    
    @IBAction func editar(_ sender: Any) {
        contents_edit = [
            check_admin,
            txt_date,
            txt_adultos,
            txt_ninos,
            txt_tel,
            txt_mail,
//            txt_lugar,
            txt_cars,
            txt_perros,
            txt_gatos,
            txt_otrosmasc,
            check_gym,
            check_cine,
            check_yoga,check_mascotas
        ]
        var fieldsColor     : UIColor!
        var userInteraction : Bool!
        if isEditing {
            let yesButton = UIAlertAction(title: "Si", style: .default) {
                action in
                self.updateUser()
            }
            let noButton = UIAlertAction(title: "No", style: .default) {
                action in
                self.cargarDatos()
                self.initListItems()
            }
            MyAlert.alert(view: self, title: "Datos de usaurio", message: "¿Estás seguro de cambiar los datos de \(userSelected.nombre)?", buttons: [yesButton,noButton], style: .alert)
            
            fieldsColor = UIColor.clear
            userInteraction = false
            self.isEditing = false
            self.editarButton.setTitle("Editar", for: .normal)
        }else {
            fieldsColor = UIColor(hex: 0xf2f2f2)
            userInteraction = true
            self.isEditing  = true
            self.editarButton.setTitle("Finalizar", for: .normal)
        }
        
        for l in 0 ..< contents_edit.count {
            contents_edit[l]?.isUserInteractionEnabled = userInteraction
            if (l<(contents_edit.count-4)) {
                contents_edit[l]?.backgroundColor = fieldsColor
            }
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func pickershow(_ sender: UIButton) {
        //self.content_picker = 1
        if (sender.tag == 2) {
            self.height_date_picker.constant = 100
            self.height_picker.constant = 0
        } else {
            self.height_picker.constant = 100
            self.height_date_picker.constant = 0
        }
        self.height_content_picker.constant=150
        txtactive = sender
        let numsel = Int((self.txtactive.titleLabel?.text)!) ?? 0
        self.PickerView.selectRow(numsel, inComponent: 0, animated: false)
    }
    
    func goBackFunc() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func pickerhide(_ sender: Any) {
        //self.content_picker.alpha = 0
        self.height_picker.constant         = 0
        self.height_date_picker.constant    = 0
        self.height_content_picker.constant = 0
        
        if (self.txtactive.tag == 5) {
            let numsel = Int((self.txtactive.titleLabel?.text)!) ?? 0
            
            let subViews = self.content_car.subviews
            for subview in subViews as [UIView]   {
                subview.removeFromSuperview()
            }
            
            self.height_content_car.constant = CGFloat((numsel * 40) + (numsel*10))
            for l in 0 ..< numsel {
                let alto = CGFloat(10 + (l * 50))
                let _textField: UITextField = UITextField(frame: CGRect(x: 0, y: alto, width: self.content_car.frame.width, height: 40.00))
                _textField.backgroundColor = UIColor(hex: 0xf2f2f2)
                _textField.placeholder = "Ingresa el número de placa"
                _textField.layer.cornerRadius = 5
                _textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
                _textField.leftViewMode = .always
                
                _textField.layer.cornerRadius = 5
                
                //_textField.delegate = self
                //_textField.borderStyle = UITextBorderStyle.Line
                self.content_car.addSubview(_textField)
                
            }
            
        }
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return number_pickers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return number_pickers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtactive.setTitle(number_pickers[row], for: .normal)
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //dateFormatter.dateStyle = DateFormatter.Style.medium
        
        //dateFormatter.timeStyle = DateFormatter.Style.none
        
        //dateTextField.text = dateFormatter.string(from: sender.datePicker)
        let date = dateFormatter.string(from: datePicker.date) != nil ? dateFormatter.string(from: datePicker.date) : "yyyy/mm/dd"
        self.txtactive.setTitle(date, for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func button_check(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func del_cont_show(_ sender: Any) {
        let heightsv = self.view.frame.size.height/2
        UIView.animate(withDuration: 0.5, animations: {
            self.height_delete_content.constant=heightsv
            self.view.layoutIfNeeded()
            
        },completion: { (finished:Bool) in
            self.delet_com.alpha=1
        })
    }
    
    @IBAction func del_cont_hide(_ sender: Any) {
        self.hideDeleteView()
    }
    
    @IBAction func del_cont_usuario(_ sender: Any) {
        self.deleteUser()
        self.hideDeleteView()
    }
    
    func hideDeleteView() {
        self.delet_com.alpha=0
        let _ = self.view.frame.size.height
        UIView.animate(withDuration: 0.5, animations: {
            self.height_delete_content.constant=0
            self.view.layoutIfNeeded()
            
        })
    }
}


typealias usuarios_editadd_second_collection = usuarios_editadd_second
extension usuarios_editadd_second_collection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func configurarCollectionView() {
        collectionView.reloadData()
        
        let width       = ( (self.view.bounds.size.width - 60) / 2 )
        var height      : CGFloat!
        height          = (collectionView.layer.bounds.size.height - 15) / 2
        let size        = CGSize(width: width, height: height)
        let cellSize    = size
        let layout      = UICollectionViewFlowLayout()
        
        layout.scrollDirection          = .vertical
        layout.itemSize                 = cellSize
        layout.sectionInset             = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing       = 10.0
        layout.minimumInteritemSpacing  = 5
        collectionView.isPagingEnabled  = false
        collectionView.bounces          = false
        
        collectionView.setCollectionViewLayout(layout, animated: false)
        self.view.layoutIfNeeded()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AffinityCollectionCell", for: indexPath) as! AffinityCollectionCell
        cell.affinity = self.listItems[indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
}

typealias usuarios_editadd_second_http = usuarios_editadd_second
extension usuarios_editadd_second_http {
    
    func saveInDevice() {
        
        //check_admin.isSelected = (userSelected.usuarioAdm == 1 ? false : true)
        self.userBirthDate  = txt_date.titleLabel!.text!
        self.userPhone      = txt_tel.text!
        self.userMail       = txt_mail.text!
        self.userLocation   = txt_lugar.text!
        self.userIsAdmin    = (check_admin.isSelected ? "0" : "1")
        self.userName       = txt_name.text!
        
        var afinidadesArray = [String]()
        for afinidad in listItems {
            if afinidad.checked == 1 {
                afinidadesArray.append(String(afinidad.idafinidades_master))
            }
        }
        self.affinities      = afinidadesArray.joined(separator: ",")
        self.affinitiesArray = afinidadesArray
    }
    
    func deleteUser() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/delete
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.delete
        let headers = Headers().loggedIn()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            "Usuario_eliminar": userSelected.nombreUsuario,
            "usuario_eliminar": userSelected.nombreUsuario
        ]
        HUD.show(.label(Const.HUD.updateUser))
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
                            let alertC = UIAlertController(title: "Exito!", message: "Tu usuario fue borrado correctamente.", preferredStyle: UIAlertControllerStyle.alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                                self.goBackFunc()
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
    
    func updateUser() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/update
        self.saveInDevice()
        
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.updateSecundario
        let headers = Headers().loggedIn()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : self.userSelected.nombreUsuario,
            
            "nombrecompleto": self.userName,
            "correo"        : self.userMail,
            "telefono"      : self.userPhone,
            "fechanacimiento": self.userBirthDate,
            "adultos"       : "\(self.userSelected.unidadCantidadPadres)",
            "hijos"         : "\(self.userSelected.unidadCantidadHijos)",
            "cantidadcarros": "\(self.userSelected.unidadCantidadCarros)",
            "placas"        : self.userSelected.placas,
            "cantidadperros": "\(self.userSelected.unidadCantidadPerros)",
            "cantidadgatos" : "\(self.userSelected.unidadCantidadGatos)",
            "afinidades"    : self.affinities,
            "profilepic"    : self.userSelected.usuarioProfilePic,
            "adm"           : self.userIsAdmin
        ]
        HUD.show(.label(Const.HUD.updateUser))
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
                            let alertC = UIAlertController(title: "Exito!", message: "Tu usuario fue correctamente modificado.", preferredStyle: UIAlertControllerStyle.alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
                                self.goBackFunc()
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
    
    func initListItems() {
        let url     = EndPointConst.baseUrlApi() + EndPointConst.Affinities.get
        let headers = Headers.noSession
        HUD.show(.label(Const.HUD.updateUser))
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
                let statusCode = "(\(response.response?.statusCode ?? 777)): "
                HUD.hide()
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let titulo      = Const.tituloAviso
                        let mensaje     = Const.servidorNoResponde
                        let estado      = Int(json[EndPointConst.Response.estado].string ?? "777")!
                        
                        if(response.response?.statusCode == 200) {
                            let data    = json["data"]
                            if(data.count > 0) {
                                self.listItems.removeAll()

                                for index in 0...(data.count - 1) {
                                    let idAffinity = data[index]["idafinidades_master"].int    ?? 0
                                    let afinidadesArray = self.userSelected.afinidades.components(separatedBy: "/")
                                    let check = afinidadesArray.contains(String(idAffinity)) ? 1 : 0
                                    let notice = Affinity(
                                        idafinidades_master : idAffinity,
                                        descripcion         : data[index]["descripcion"].string         ?? "",
                                        checked             : check
                                    )
                                    self.listItems.append(notice)
                                }
                            }
                            self.collectionViewHeight.constant = CGFloat(50 * (self.listItems.count / 2 ))
                            self.collectionView.reloadData()
                        }else if(estado == 403) {
                            MyAlert.alertDefault(view: self, titulo: titulo, mensaje: Const.sinAutorizacion)
                            return
                        }else {
                            MyAlert.alert(view: self, title: titulo, message: mensaje)
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
    
    func updateProfilePicture() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/upload_profile_picture
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.updatePictureSecundario
        let headers = Headers().loggedIn_www_Form()
        let parametros = [
            "conjunto"      : "\(userSelected.idConjunto)",
            "unidad"        : "\(userSelected.idUnidad)",
            "usuario"       : userSelected.nombreUsuario,
            "imagen"        : self.fotoPerfil
        ]
        HUD.show(.label(Const.HUD.updatePicture))
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
                            let data = json["data"]
                            let urlPicture = data["profilepic"].string ?? ""
                            self.fotoUidUrl = urlPicture
                            self.userSelected.usuarioProfilePic = self.fotoUidUrl
                            let alertC = UIAlertController(title: "Éxito!", message: "Foto de perfil actualizada.", preferredStyle: UIAlertControllerStyle.alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in
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

//MARK: - ImagePicker
typealias usuarios_editadd_second_picker = usuarios_editadd_second
extension usuarios_editadd_second_picker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
            self.fotoPerfil = UIImageHelper.imageToBase64(image: image, width: 400)!
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

