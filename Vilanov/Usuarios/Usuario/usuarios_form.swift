//
//  usuarios_formViewController.swift
//  Vilanov
//
//  Created by Daniel on 25/02/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import PKHUD
import Alamofire

struct Affinity {
    let idafinidades_master : Int
    let descripcion         : String
    var checked             : Int
}

class usuarios_formController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var PickerView       : UIPickerView!
    @IBOutlet weak var txtadultos       : UITextField!
    
    @IBOutlet weak var txtactive        : UIButton!
    @IBOutlet weak var content_picker   : UIView!
    @IBOutlet weak var height_picker    : NSLayoutConstraint!
    
    @IBOutlet weak var height_content_picker: NSLayoutConstraint!
    @IBOutlet weak var content_car          : UIView!
    @IBOutlet weak var height_date_picker   : NSLayoutConstraint!
    @IBOutlet weak var height_content_car   : NSLayoutConstraint!
    @IBOutlet weak var date_picker          : UIDatePicker!
    @IBOutlet weak var collectionView       : UICollectionView!
    @IBOutlet weak var collectionViewHeight : NSLayoutConstraint!
    
    @IBOutlet weak var btnBirthDate     : UIButton!
    @IBOutlet weak var btnAdultsNumber  : UIButton!
    @IBOutlet weak var btnChildrenNumber: UIButton!
    @IBOutlet weak var btnCarsNumber    : UIButton!
    @IBOutlet weak var btnDogsNumber    : UIButton!
    @IBOutlet weak var btnCatsNumber    : UIButton!
    @IBOutlet weak var txtOtros         : UITextField!
    
    var listItems           : [Affinity]    = []
    var affinities          : [Int:String]  = [:]
    let number_pickers      = ["0","1","2","3","4","5","6","7","8","9"]
    var carNumberSelected   = 0
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        date_picker.addTarget(self, action: #selector(usuarios_formController.datePickerChanged), for: UIControlEvents.valueChanged)
        txtOtros.delegate = self
        PickerView.delegate = self
        btnBirthDate.setTitle(AppSettings.fechaNacimiento, for: .normal)
        btnAdultsNumber.setTitle("\(AppSettings.cantidadadultos)", for: .normal)
        btnChildrenNumber.setTitle("\(AppSettings.cantidadhijos)", for: .normal)
        btnCarsNumber.setTitle("\(AppSettings.cantidadcarros)", for: .normal)
        btnDogsNumber.setTitle("\(AppSettings.cantidadperros)", for: .normal)
        btnCatsNumber.setTitle("\(AppSettings.cantidadgatos)", for: .normal)
        txtOtros.text = "\(AppSettings.perfilOtros)"
        self.generateCars()
        self.configurarCollectionView()
        self.initListItems()
    }
    
    @IBAction func pickershow(_ sender: UIButton) {
        //self.content_picker = 1
        if (sender.tag == 2) {
            self.height_date_picker.constant    = 100
            self.height_picker.constant         = 0
        } else {
            self.height_picker.constant         = 100
            self.height_date_picker.constant    = 0
        }
        self.height_content_picker.constant = 150
        txtactive   = sender
        let numsel  = Int(self.txtactive.titleLabel?.text ?? "0") ?? 0
        self.PickerView.selectRow(numsel, inComponent: 0, animated: false)
    }
    
    @IBAction func `return`(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type     = kCATransitionPush
        transition.subtype  = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func pickerhide(_ sender: Any) {
        //self.content_picker.alpha = 0
        self.height_picker.constant         = 0
        self.height_date_picker.constant    = 0
        self.height_content_picker.constant = 0
        
        self.pickerSelectedItemGenerator()
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
    }
    
    
    func pickerSelectedItemGenerator() {
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
                _textField.tag = l
                _textField.delegate = self
                _textField.layer.cornerRadius = 5
                let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 2.0))
                _textField.leftView = leftView
                _textField.leftViewMode = .always
                _textField.textColor =  UIColor(hex: 0x606060)
                if cars.indices.contains(l) {
                    _textField.text = cars[l]
                }
                //                _textField.borderStyle = UITextBorderStyle.line
                self.content_car.addSubview(_textField)
                
            }
        }
    }
   
    
    @objc func datePickerChanged(datePicker:UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        //dateFormatter.dateStyle = DateFormatter.Style.medium
        
        //dateFormatter.timeStyle = DateFormatter.Style.none
        
        //dateTextField.text = dateFormatter.string(from: sender.datePicker)
        let date = dateFormatter.string(from: datePicker.date) //!= nil ? dateFormatter.string(from: datePicker.date) : "yyyy-mm-dd"
        self.txtactive.setTitle(date, for: .normal)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField != txtOtros && textField != txtadultos {
//            self.car_plates[textField.tag] = textField.text
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField != txtOtros && textField != txtadultos {
//            self.car_plates[textField.tag] = textField.text
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    @IBAction func finalizarAction(_ sender: UIButton) {
        self.updateUser()
    }
    
    func saveInDevice() {
        AppSettings.fechaNacimiento = btnBirthDate.titleLabel!.text!
        AppSettings.cantidadadultos = Int(btnAdultsNumber.titleLabel!.text!) ?? 0
        AppSettings.cantidadhijos   = Int(btnChildrenNumber.titleLabel!.text!) ?? 0
        AppSettings.cantidadcarros  = Int(btnCarsNumber.titleLabel!.text!) ?? 0
        AppSettings.cantidadperros  = Int(btnDogsNumber.titleLabel!.text!) ?? 0
        AppSettings.cantidadgatos   = Int(btnCatsNumber.titleLabel!.text!) ?? 0
        AppSettings.perfilOtros     = txtOtros.text!
        
        var cars = [String]()
        let subViews = self.content_car.subviews
        for textField in subViews as! [UITextField] {
            let  car = textField.text ?? ""
            if( !car.isEmpty ) {
                cars.append(car)
            }
        }

        AppSettings.carPlatesArray  = cars
        AppSettings.carPlates       = cars.joined(separator: ",")
        
        var affinitiesArray = [String]()
        for affinity in listItems {
            if affinity.checked == 1 {
                affinitiesArray.append(String(affinity.idafinidades_master))
            }
        }
        AppSettings.afinidades      = affinitiesArray.joined(separator: ",")
        AppSettings.afinidadesArray = affinitiesArray
    }
    
    func eraseFromDevice() {
        AppSettings.fechaNacimiento = ""
        AppSettings.cantidadadultos = 0
        AppSettings.cantidadhijos   = 0
        AppSettings.cantidadcarros  = 0
        AppSettings.cantidadperros  = 0
        AppSettings.cantidadgatos   = 0
        AppSettings.perfilOtros     = ""
        AppSettings.carPlatesArray  = []
        AppSettings.carPlates       = ""
        AppSettings.afinidadesArray = []
        AppSettings.afinidades      = ""
    }

    func dismissAllViews() {
        (
            self.presentingViewController?
                .presentingViewController?
                .presentingViewController?
                .presentingViewController?
                .presentingViewController?
                .dismiss(animated: true, completion: nil)
        )
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
            let leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 5.0, height: 2.0))
            _textField.leftView = leftView
            _textField.leftViewMode = .always
            _textField.textColor =  UIColor(hex: 0x606060)
            _textField.layer.borderColor = UIColor.lightGray.cgColor
            //                _textField.borderStyle = UITextBorderStyle.line
            self.content_car.addSubview(_textField)
            
        }
    }
    
}

//MARK: - CollectionView
typealias usuarios_formCollection = usuarios_formController
extension usuarios_formCollection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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


//MARK: - Peticiones Http
typealias usuarios_formHttp = usuarios_formController
extension usuarios_formHttp {
    
    func initListItems() {
        if !Accesibilidad.tieneInternet() {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.sinInternet)
            return
        }
        let url     = EndPointConst.baseUrlApi() + EndPointConst.Affinities.get
        let headers = Headers.noSession
        HUD.show(.label(Const.HUD.updateUser))
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON {
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
                        let mensaje     = Const.servidorNoResponde
                        
                        if(response.response?.statusCode == 200) {
                            let data    = json["data"]
                            if(data.count > 0) {
                                self.listItems.removeAll()
                                
                                for index in 0...(data.count - 1) {
                                    let idAffinity = data[index]["idafinidades_master"].int    ?? 0
                                    let affinities = AppSettings.afinidadesArray
                                    let check = affinities.contains(String(idAffinity)) ? 1 : 0
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
                        } else if(estado == 401) {
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
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.servidorNoResponde)
                    }
                    break
                }
            }
        }
    }
    
    
    func updateUser() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/update
        self.saveInDevice()
        
        let url = EndPointConst.baseUrlApi() + EndPointConst.Users.update
        let headers = Headers().loggedIn()
        let parametros = [
            "conjunto"      : "\(AppSettings.conjunto)",
            "unidad"        : "\(AppSettings.unidad)",
            "usuario"       : AppSettings.usuario,
            "nombrecompleto": AppSettings.apellido + " " + AppSettings.nombre,
            "correo"        : AppSettings.correo,
            "telefono"      : AppSettings.telefono,
            "fechanacimiento": AppSettings.fechaNacimiento,
            "adultos"       : "\(AppSettings.cantidadadultos)",
            "hijos"         : "\(AppSettings.cantidadhijos)",
            "cantidadcarros": "\(AppSettings.cantidadcarros)",
            "placas"        : AppSettings.carPlates,
            "cantidadperros": "\(AppSettings.cantidadperros)",
            "cantidadgatos" : "\(AppSettings.cantidadgatos)",
            "afinidades"    : AppSettings.afinidades,
            "profilepic"    : AppSettings.fotoUidUrl,
            "adm"           : "\(AppSettings.adm)"
        ]
        print(headers)
//        print(parametros)
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
                                self.dismissAllViews()
                            })
                            alertC.addAction(defaultAction)
                            self.present(alertC, animated: true , completion: nil)
                            
                        }else {
                            MyAlert.alertDefault(view: self, titulo: titulo, mensaje: mensaje)
                            self.eraseFromDevice()
                            return
                        }
                    }
                    break
                    
                case .failure(let error):
                    if error._code == NSURLErrorTimedOut {
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.timeout)
                    }else {

                    MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.servidorNoResponde)
                    self.eraseFromDevice()
                    print("\(fecha): No se obtuvo una del servidor...")
                    }
                    break
                }
            }
        }
    }
}


class AffinityCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var labelAffinity: UILabel!
    @IBOutlet weak var buttonAffinity: UIButton!
    @IBAction func click_check(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.changeCheckStatus()
    }
    
    var affinity : Affinity? {
        didSet {
            if let affinity = affinity {
                labelAffinity.text = affinity.descripcion
                buttonAffinity.isSelected = (affinity.checked == 1 ? false : true)
            }
        }
    }
    
    func changeCheckStatus() {
        if let parent = self.parentViewController as? usuarios_formController {
            if affinity?.checked == 1 {
                parent.listItems[self.tag].checked = 0
            }else {
                parent.listItems[self.tag].checked = 1
            }
        }else if let parent = self.parentViewController as? usuarios_editadd {
            if affinity?.checked == 1 {
                parent.listItems[self.tag].checked = 0
            }else {
                parent.listItems[self.tag].checked = 1
            }
            
        }else if let parent = self.parentViewController as? usuarios_editadd_second {
            if affinity?.checked == 1 {
                parent.listItems[self.tag].checked = 0
            }else {
                parent.listItems[self.tag].checked = 1
            }
            
        }else {
            print("NO ALCANZO AL ViewController: Padre")
        }
        
    }
    
}
