//
//  usuarios_editadd.swift
//  Vilanov
//
//  Created by Daniel on 27/02/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire
import SDWebImage

class usuarios_editadd: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var height_content_picker    : NSLayoutConstraint!
    @IBOutlet weak var height_date_picker       : NSLayoutConstraint!
    @IBOutlet weak var height_picker            : NSLayoutConstraint!
    @IBOutlet weak var height_content_car       : NSLayoutConstraint!
    
    
    @IBOutlet weak var txtactive    : UIButton!
    @IBOutlet weak var date_picker  : UIDatePicker!
    @IBOutlet weak var PickerView   : UIPickerView!
    @IBOutlet weak var content_car  : UIView!
    
    
    @IBOutlet weak var editarButton : UIButton!
    @IBOutlet weak var pic_user     : UIImageView!
    @IBOutlet weak var txt_name     : UILabel!
    @IBOutlet weak var check_admin  : UIButton!
    @IBOutlet weak var txt_date     : UIButton!
    @IBOutlet weak var txt_adultos  : UIButton!
    @IBOutlet weak var txt_ninos    : UIButton!
    @IBOutlet weak var txt_tel      : UITextField!
    @IBOutlet weak var txt_mail     : UITextField!
    @IBOutlet weak var txt_lugar    : UITextField!
    @IBOutlet weak var txt_cars     : UIButton!
    @IBOutlet weak var txt_perros   : UIButton!
    @IBOutlet weak var txt_gatos    : UIButton!
    @IBOutlet weak var txt_otrosmasc: UITextField!
    
    @IBOutlet weak var collectionView       : UICollectionView!
    @IBOutlet weak var collectionViewHeight : NSLayoutConstraint!
    
    @IBAction func goToNewPassFull(_ sender: UIButton) {
        self.goToChangePass()
    }
    
    @IBAction func editar(_ sender: Any) {
        self.editar()
    }
    
    @IBAction func closeSessionAction(_ sender: UIButton) {
        let siButton = UIAlertAction(title: "Si", style: .destructive) {
            action in
            self.closeSession()
        }
        let noButton = UIAlertAction(title: "No", style: .default, handler: nil)
        MyAlert.alert(view: self, title: Const.tituloAviso, message: Const.cerrarSesion, buttons: [siButton,noButton], style: .alert)
    }
    
    var listItems       : [Affinity]    = []
    let number_pickers  = ["0","1","2","3","4","5","6","7","8","9"]
    var contents_edit   = [UIView?]()
    var isSditing       = false
    
    var userPhone       = ""
    var userMail        = ""
    var userLocation    = ""
    
    var userBirthDate   = ""
    var userIsAdmin     = ""
    var userName        = ""
    var numberParents   = 0
    var numberChildren  = 0
    var numberCars      = 0
    var numberDogs      = 0
    var numberCats      = 0
    var profileOther    = ""
    
    var carPlates       = ""
    var carPlatesArray  : [String] = []
    var affinities      = ""
    var affinitiesArray : [String] = []
    
    let imagePicker             = UIImagePickerController()
    var eleccionImagenCamara    = false
    var fotoUidUrl              = ""
    var fotoPerfil              = ""
    
    var carNumberSelected       = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate    = self
        self.collectionView.dataSource  = self
        self.txt_otrosmasc.delegate     = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapView(gesture:)))
        view.addGestureRecognizer(tapGesture)
        let tapGestureRecognizer_camera = UITapGestureRecognizer(target: self, action: #selector(self.cargarImagen))
        pic_user.isUserInteractionEnabled = true
        pic_user.addGestureRecognizer(tapGestureRecognizer_camera)
        self.cargarDatos()
        self.stylishView()
        self.configurarCollectionView()
        self.initListItems()
        self.generateCars()
        self.txt_lugar.isEnabled = false
    }
    
    func cargarDatos() {
        let birthDate = AppSettings.fechaNacimiento.isEmpty ? "yyyy/mm/dd" : AppSettings.fechaNacimiento
        self.check_admin.isSelected = (AppSettings.adm == 1 ? false : true)
        self.txt_date.setTitle(birthDate, for: .normal)
        self.txt_tel.text    = AppSettings.telefono
        self.txt_mail.text   = AppSettings.correo
        self.txt_lugar.text  = AppSettings.solar
        self.txt_name.text   = "\(AppSettings.nombre) \(AppSettings.apellido)"
        
        self.txt_adultos.setTitle(  String(AppSettings.cantidadadultos),for: .normal)
        self.txt_ninos.setTitle(    String(AppSettings.cantidadhijos),  for: .normal)
        self.txt_cars.setTitle(     String(AppSettings.cantidadcarros), for: .normal)
        self.txt_perros.setTitle(   String(AppSettings.cantidadperros), for: .normal)
        self.txt_gatos.setTitle(    String(AppSettings.cantidadgatos),  for: .normal)
        self.txt_otrosmasc.text = AppSettings.perfilOtros
        
        if let url = URL(string: AppSettings.fotoUidUrl) {
            pic_user.sd_setImage(with: url, placeholderImage: UIImage(named: "usuarios_preuser_pic"), options: .forceTransition, completed: nil)
        }else if !AppSettings.fotoPerfil.isEmpty {
            let fotoPerfil = UIImage(data: (AppSettings.fotoPerfil.fromBase64()?.data(using: String.Encoding.utf8))!)!
            pic_user.image = fotoPerfil
        }
    }
    
    func generateCars() {
        let numsel = AppSettings.carPlatesArray.count
        let subViews = self.content_car.subviews
        for subview in subViews as [UIView] {
            subview.removeFromSuperview()
        }
        
        self.height_content_car.constant = CGFloat((numsel * 40) + (numsel*10))
        for l in 0 ..< numsel {
            let alto = CGFloat(10 + (l * 50))
            let _textField: UITextField = UITextField(frame: CGRect(x: 0, y: alto, width: self.content_car.frame.width, height: 40.00))
            _textField.backgroundColor = UIColor(hex: 0xf2f2f2)
            _textField.placeholder = "Ingresa el número de placa"
            _textField.layer.cornerRadius = 5
            _textField.tag = l
            _textField.delegate = self
            _textField.keyboardType = .asciiCapable
            _textField.autocapitalizationType = .allCharacters
            _textField.text = AppSettings.carPlatesArray[l]
            _textField.isUserInteractionEnabled = false
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 2.0))
            _textField.leftView = leftView
            _textField.leftViewMode = .always
            _textField.textColor =  UIColor(hex: 0x606060)
            _textField.layer.borderColor = UIColor.lightGray.cgColor
            //                _textField.borderStyle = UITextBorderStyle.line
            self.content_car.addSubview(_textField)
            
        }
    }
    
    func stylishView() {
        if (self.pic_user != nil) {
            self.pic_user.layer.cornerRadius = (self.pic_user.frame.size.width) / 2
            self.pic_user.clipsToBounds = true
            self.pic_user.layer.borderWidth = 3.0
            self.pic_user.layer.borderColor = UIColor(hex: 0xf2f2f2).cgColor
        }
        
        date_picker.addTarget(self, action: #selector(usuarios_editadd.datePickerChanged), for: UIControlEvents.valueChanged)
        
        txt_mail.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
        txt_mail.leftViewMode = .always
        txt_mail.layer.cornerRadius = 10
        
        txt_otrosmasc.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
        txt_otrosmasc.leftViewMode = .always
        txt_otrosmasc.layer.cornerRadius = 10
        
        txt_tel.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
        txt_tel.leftViewMode = .always
        txt_tel.layer.cornerRadius = 10
        
        txt_lugar.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 10, height: 2.0))
        txt_lugar.leftViewMode = .always
        txt_lugar.layer.cornerRadius = 10
    }
    
    func dismissAllViews() {
        self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
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
    
    @objc func didTapView(gesture: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func goToChangePass() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "NewPassViewController")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: true)
    }

    func editar() {
        check_admin.isUserInteractionEnabled = false
        contents_edit = [
            //check_admin,
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
            collectionView
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
            MyAlert.alert(view: self, title: "Datos de usaurio", message: "¿Estás seguro de cambiar los datos de \(AppSettings.nombre)?", buttons: [yesButton,noButton], style: .alert)
            
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
        let subViews = self.content_car.subviews
        for textField in subViews as! [UITextField] {
            textField.isUserInteractionEnabled = userInteraction
            textField.backgroundColor = fieldsColor
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    @IBAction func pickershow(_ sender: UIButton) {
        //self.content_picker = 1
        if (sender.tag==2){
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
    
    @IBAction func goBackAction(_ sender: Any) {
        self.goBack()
    }
    
    func goBack() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func pickerhide(_ sender: Any) {
        //self.content_picker.alpha = 0
        self.height_picker.constant=0
        self.height_date_picker.constant=0
        self.height_content_picker.constant=0
        
        self.pickerSelectedNumber()
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return number_pickers[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return number_pickers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if txtactive.tag == 5 {
            self.carNumberSelected = row
        }else {
            self.txtactive.setTitle(number_pickers[row], for: .normal)
        }
//        self.pickerSelectedNumber()
    }
    
    func pickerSelectedNumber() {
        if (self.txtactive.tag == 5) {
            let numsel = self.carNumberSelected
            self.txtactive.setTitle(number_pickers[self.carNumberSelected], for: .normal)
            var cars = [String]()
            let subViews = self.content_car.subviews
            for subview in subViews as! [UITextField]   {
                let  car = subview.text ?? ""
                if( !car.isEmpty ) {
                    cars.append(car)
                }
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
                
                _textField.tag = l
                _textField.delegate = self
                _textField.keyboardType = .asciiCapable
                let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 2.0))
                _textField.leftView = leftView
                _textField.leftViewMode = .always
                _textField.textColor =  UIColor(hex: 0x606060)
                _textField.autocapitalizationType = .allCharacters
                
                _textField.layer.cornerRadius = 5
                
                if cars.indices.contains(l) {
                    _textField.text = cars[l]
                }
                //_textField.delegate = self
                //_textField.borderStyle = UITextBorderStyle.Line
                self.content_car.addSubview(_textField)
                
            }
            
        }
    }
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = !dateFormatter.string(from: datePicker.date).isEmpty ? dateFormatter.string(from: datePicker.date) : "yyyy-mm-dd"
        print (dateFormatter.string(from: datePicker.date))
        self.txtactive.setTitle(date, for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func button_check(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

}


typealias usuarios_editadd_collection = usuarios_editadd
extension usuarios_editadd_collection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

typealias usuarios_editadd_http = usuarios_editadd
extension usuarios_editadd_http {
    
    func saveInVariables() {
        self.userBirthDate  = txt_date.titleLabel!.text!
        self.userPhone      = txt_tel.text!
        self.userMail       = txt_mail.text!
        self.userLocation   = txt_lugar.text!
        self.userIsAdmin    = (check_admin.isSelected ? "0" : "1")
        self.userName       = txt_name.text!
        
        // LLENAR ESTOS CAMPOS CON INFO REAL
        self.numberParents   = Int(self.txt_adultos.titleLabel!.text!) ?? 0
        self.numberChildren  = Int(self.txt_ninos.titleLabel!.text!) ?? 0
        self.numberCars      = Int(self.txt_cars.titleLabel!.text!) ?? 0
        self.numberDogs      = Int(self.txt_perros.titleLabel!.text!) ?? 0
        self.numberCats      = Int(self.txt_gatos.titleLabel!.text!) ?? 0
        self.profileOther    = self.txt_otrosmasc.text!
        
        var cars = [String]()
        let subViews = self.content_car.subviews
        for textField in subViews as! [UITextField] {
            let  car = textField.text ?? ""
            if( !car.isEmpty ) {
                cars.append(car)
            }
        }
        
        self.carPlatesArray  = cars
        self.carPlates       = cars.joined(separator: ",")
        
        var afinidadesArray = [String]()
        for afinidad in listItems {
            if afinidad.checked == 1 {
                afinidadesArray.append(String(afinidad.idafinidades_master))
            }
        }
        self.affinities      = afinidadesArray.joined(separator: ",")
        self.affinitiesArray = afinidadesArray
    }
    
    func saveInAppSettings() {
        AppSettings.nombre          = self.userName
        AppSettings.correo          = self.userMail
        AppSettings.telefono        = self.userPhone
        AppSettings.fechaNacimiento = self.userBirthDate
        AppSettings.cantidadadultos = self.numberParents
        AppSettings.cantidadhijos   = self.numberChildren
        AppSettings.cantidadcarros  = self.numberCars
        AppSettings.carPlates       = self.carPlates
        AppSettings.cantidadperros  = self.numberDogs
        AppSettings.cantidadgatos   = self.numberCats
        AppSettings.afinidades      = self.affinities
        AppSettings.adm             = (check_admin.isSelected ? 0 : 1)
    }
    
    func updateUser() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/update
        self.saveInVariables()
        
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.update
        let headers = Headers().loggedIn()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            
            "nombrecompleto": self.userName,
            "correo"        : self.userMail,
            "telefono"      : self.userPhone,
            "fechanacimiento": self.userBirthDate,
            "adultos"       : "\(self.numberParents)",
            "hijos"         : "\(self.numberChildren)",
            "cantidadcarros": "\(self.numberCars)",
            "placas"        : self.carPlates,
            "cantidadperros": "\(self.numberDogs)",
            "cantidadgatos" : "\(self.numberCats)",
            "afinidades"    : self.affinities,
            "profilepic"    : AppSettings.fotoUidUrl,
            "adm"           : self.userIsAdmin
        ]
        HUD.show(.label(Const.HUD.updateUser))
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
                            let alertC = UIAlertController(title: "Exito!", message: "Tu usuario fue correctamente modificado.", preferredStyle: UIAlertControllerStyle.alert)
                            let defaultAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action) in })
                            alertC.addAction(defaultAction)
                            self.present(alertC, animated: true , completion: nil)
                            self.saveInAppSettings()
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
                                    let afinidadesArray = AppSettings.afinidadesArray
                                    let check = afinidadesArray.contains(String(idAffinity)) ? 1 : 0
                                    let notice = Affinity(
                                        idafinidades_master : idAffinity,
                                        descripcion         : data[index]["descripcion"].string         ?? "",
                                        checked             : check
                                    )
                                    self.listItems.append(notice)
                                }
                            }
                            let height = CGFloat(50 * (self.listItems.count / 2 ))
                            self.collectionViewHeight.constant = height
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
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.updatePicture
        let headers = Headers().loggedIn_www_Form()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            "imagen"        : self.fotoPerfil
        ]
        HUD.show(.label(Const.HUD.updatePicture))
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
                            let data = json["data"]
                            let urlPicture = data["profilepic"].string ?? ""
                            self.fotoUidUrl = urlPicture
                            AppSettings.fotoUidUrl = urlPicture
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

//MARK: - ImagePicker
typealias usuarios_editadd_picker = usuarios_editadd
extension usuarios_editadd_picker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
