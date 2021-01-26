//
//  UsersListViewController.swift
//  Vilanov
//
//  Created by andres on 3/9/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import Alamofire


struct User: Codable {
    let descripciónUnidad   : String
    let apellido            : String
    let placas              : String
    let usuarioAdm          : Int
    let unidadCantidadHijos : Int
    let idConjunto          : Int
    let unidadCantidadPerros: Int
    let usuarioTel          : String
    let idCiudad            : Int
    let idPais              : Int
    let usuarioLogged       : Int
    let unidadCantidadCarros: Int
    let unidadCantidadGatos : Int
    let idUnidad            : Int
    let idEstado            : Int
    let usuarioFechaNacimiento : String
    let nombre              : String
    let unidadCantidadPadres: Int
    let afinidades          : String
    let descPerfil          : String
    let correoUsuario       : String
    var usuarioProfilePic   : String
    let url_logo            : String
    let descestado_objeto   : String
    let nombreEstado        : String
    let descripcionAdicUnidad : String
    let idPerfil            : Int
    let nombreConjunto      : String
    let nombrePais          : String
    let idestado_usuario    : Int
    let nombreCiudad        : String
    let nombreUsuario       : String
}

class UsersListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goBack(_ sender: UIButton) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func createUserAction(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios_editadd", bundle: nil)
        if let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "usuarios_edit_com") as? usuarios_edit_com {
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(ViewControllerDos, animated: true)
        }
    }
    
    var listItems = [User]()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.initListItems()
        print("obteniendo usuarios")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource   = self
        self.tableView.delegate     = self
    }

}

typealias UsersListTableView = UsersListViewController
extension UsersListTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersListCell", for: indexPath) as! UsersListCell
        cell.user = self.listItems[indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //usuarios_editadd_second
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "usuarios_editadd", bundle: nil)
        if let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "usuarios_editadd_second") as? usuarios_editadd_second {
            ViewControllerDos.userSelected = self.listItems[indexPath.row]
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(ViewControllerDos, animated: true)
        }
    }
}

typealias UsersListHttp = UsersListViewController
extension UsersListHttp {
    
    func initListItems() {
        //https://inmovila-smart-communities.appspot.com/inmovila-rest/v1/users/consulta/{conjunto}/{unidad}/{usuario}
        let url     = EndPointConst.baseUrlApi() + EndPointConst.Users.getList(AppSettings.conjunto, AppSettings.unidad, AppSettings.usuario)
        let headers = Headers().loggedIn()
        let bearer = AppSettings.bearer
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
//                let statusCode = "(\(response.response?.statusCode ?? 777)): "
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let estado      = Int(json[EndPointConst.Response.estado].string ?? "777")!
                        let titulo      = Const.tituloAviso
                        let mensaje     = Const.servidorNoResponde
                        
                        if(estado == 200) {
                            self.listItems.removeAll()
                            let data    = json["data"]
                            if(data.count > 0) {
                                for index in 0...(data.count - 1) {
                                    let user = User(
                                        descripciónUnidad           : data[index]["descripciónUnidad"].string ?? "",
                                        apellido                    : data[index]["apellido"].string ?? "",
                                        placas                      : data[index]["placas"].string ?? "",
                                        usuarioAdm                  : data[index]["usuarioAdm"].int ?? 0,
                                        unidadCantidadHijos         : data[index]["unidadCantidadHijos"].int ?? 0,
                                        idConjunto                  : data[index]["idConjunto"].int ?? 0,
                                        unidadCantidadPerros        : data[index]["unidadCantidadPerros"].int ?? 0,
                                        usuarioTel                  : data[index]["usuarioTel"].string ?? "",
                                        idCiudad                    : data[index]["idCiudad"].int ?? 0,
                                        idPais                      : data[index]["idPais"].int ?? 0,
                                        usuarioLogged               : data[index]["usuarioLogged"].int ?? 0,
                                        unidadCantidadCarros        : data[index]["unidadCantidadCarros"].int ?? 0,
                                        unidadCantidadGatos         : data[index]["unidadCantidadGatos"].int ?? 0,
                                        idUnidad                    : data[index]["idUnidad"].int ?? 0,
                                        idEstado                    : data[index]["idEstado"].int ?? 0,
                                        usuarioFechaNacimiento      : data[index]["usuarioFechaNacimiento"].string ?? "",
                                        nombre                      : data[index]["nombre"].string ?? "",
                                        unidadCantidadPadres        : data[index]["unidadCantidadPadres"].int ?? 0,
                                        afinidades                  : data[index]["afinidades"].string ?? "",
                                        descPerfil                  : data[index]["descPerfil"].string ?? "",
                                        correoUsuario               : data[index]["correoUsuario"].string ?? "",
                                        usuarioProfilePic           : data[index]["usuarioProfilePic"].string ?? "",
                                        url_logo                    : data[index]["url_logo"].string ?? "",
                                        descestado_objeto           : data[index]["descestado_objeto"].string ?? "",
                                        nombreEstado                : data[index]["nombreEstado"].string ?? "",
                                        descripcionAdicUnidad       : data[index]["descripcionAdicUnidad"].string ?? "",
                                        idPerfil                    : data[index]["idPerfil"].int ?? 0,
                                        nombreConjunto              : data[index]["nombreConjunto"].string ?? "",
                                        nombrePais                  : data[index]["nombrePais"].string ?? "",
                                        idestado_usuario            : data[index]["idestado_usuario"].int ?? 0,
                                        nombreCiudad                : data[index]["nombreCiudad"].string ?? "",
                                        nombreUsuario               : data[index]["nombreUsuario"].string ?? ""
                                    )
                                    self.listItems.append(user)
                                }
                            }
                            self.tableView.reloadData()
                        } else if(estado == 404) {
                            print("No se encontraron resultados para la busqueda")
                        }else if(estado == 403) {
                            MyAlert.alert(view: self, title: titulo, message: Const.forviden)
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
}

class UsersListCell: UITableViewCell {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName : UILabel!
    
    var user: User? {
        didSet {
            if let user = user {
                userName.text = user.nombre + " " + user.apellido + (user.usuarioAdm == 1 ? " (Admin)" : "")
            }
        }
    }
    
}
