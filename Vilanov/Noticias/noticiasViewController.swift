//
//  noticiasViewController.swift
//  Vilanov
//
//  Created by Daniel on 28/11/18.
//  Copyright © 2018 Inmovila. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class noticiasViewController: UIViewController {
    
    @IBOutlet weak var titulolabel      : UILabel!
    @IBOutlet weak var tableView        : UITableView!
    
    @IBAction func `return`(_ sender: Any) {
        return_screen()
    }
//    var childViewControllerForStatusBarStyle: UIViewController?
    
    var tipo                        : Int = 1
    let embededTableViewIdentifier  : String = "embededNoticiasTable"
    var noticiaSeleccionada         : NoticeModel!
    var listItems                   = [NoticeModel]()
    let noticeCellIdentifier        = "NoticeCell"
    var tipoNoticia                 : String = "interes"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch tipo {
        case 1:
            titulolabel?.text="Inmovila";
            tipoNoticia = "inmovila"
        case 2:
            titulolabel?.text="Avances de obra";
            tipoNoticia = "avance"
        case 3:
            titulolabel?.text="Avances de obra";
            tipoNoticia = "avance"
        case 4:
            titulolabel?.text="Noticias";
            tipoNoticia = "interes"
        default:
            titulolabel?.text="Noticias";
            tipoNoticia = "interes"
        }
        
        // Do any additional setup after loading the view.
        
        self.initListItems()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func return_screen(){
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
}

//MARK: - TableView Delegate
typealias noticiasTableView = noticiasViewController
extension noticiasTableView: UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .pad:
            //tableView.estimatedRowHeight = 300
            //tableView.rowHeight = 300
            return 330
            // It's an iPad
            // It's an iPhone
        // It's an AppleTV
        default:
            // Who knows
            //tableView.estimatedRowHeight = 170
            //tableView.rowHeight = 170
            return 190
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let notice = self.listItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: noticeCellIdentifier, for: indexPath) as! NoticeCell
        cell.notice = notice
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "noticias", bundle: nil)
        let viewNameId = (listItems[indexPath.row].tipo == "avance" ? "NoticiaDetalleAvances" : "NoticiaDetalle")
        
        let VC_2 = storyBoard.instantiateViewController(withIdentifier: viewNameId) as! NoticiaDetalleViewController
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        
        let currentCell = tableView.cellForRow(at: indexPath) as! NoticeCell
        
        if let image = currentCell.bannerImageView.image {
            VC_2.currentImage  = image
        }
        if let progress = currentCell.stringProgress {
            VC_2.progress       = currentCell.progressBar.progress
            VC_2.stringProgress = progress
            VC_2.stringPhrase   = currentCell.stringPhrase
        }
        
        VC_2.currentItem   = listItems[indexPath.row]
        self.present(VC_2, animated: false)
    }
    
}

//MARK: - Peticiones Http
typealias noticiasHttp = noticiasViewController
extension noticiasHttp {
    
    func initListItems() {
        if !Accesibilidad.tieneInternet() {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.sinInternet)
            return
        }
        let url = EndPointConst.baseUrl() + EndPointConst.appQueries + EndPointConst.Noticias.get("Vilanova", tipoNoticia, "noticias")
        let headers = Headers.noSession
        
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
                let _ = "(\(response.response?.statusCode ?? 777)): "
                debugPrint(response)
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let estado      = Int(json[EndPointConst.Response.estado].string ?? "777")!
                        let titulo      = Const.tituloAviso
                        let mensaje     = Const.servidorNoResponde
                        
                        if(response.response?.statusCode == 200) {
                            let data    = json
                            if(data.count > 0) {
                                self.listItems.removeAll()
                                
                                for index in 0...(data.count - 1) {
                                    let notice = NoticeModel(
                                        id_noticia      : data[index]["id_noticia"].string      ?? "",
                                        titulo          : data[index]["titulo"].string          ?? "",
                                        imgintermedia   : data[index]["imgintermedia"].string   ?? "",
                                        previewapp      : data[index]["previewapp"].string      ?? "",
                                        banner          : data[index]["banner"].string          ?? "",
                                        previa          : data[index]["previa"].string          ?? "",
                                        detalle         : data[index]["detalle"].string         ?? "",
                                        detalle2        : data[index]["detalle2"].string        ?? "",
                                        resumen         : data[index]["resumen"].string         ?? "",
                                        tipo            : self.tipoNoticia,
                                        fecha           : data[index]["fecha"].string           ?? ""
                                    )
                                    self.listItems.append(notice)
                                }
                            }
                            
                            self.tableView.reloadData()
//                            self.refrescar.endRefreshing()

                        } else if(estado == 401) {
//                            self.refrescar.endRefreshing()
                            
                        }else {
                            MyAlert.alert(view: self, title: titulo, message: mensaje)
//                            self.refrescar.endRefreshing()
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
    
}
