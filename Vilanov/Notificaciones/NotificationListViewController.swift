//
//  NotificationListViewController.swift
//  Vilanov
//
//  Created by andres on 3/16/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import CoreData
import SwiftDate

struct NotificationModel {
    let titulo      : String
    let descripcion : String
    let tipo        : String
    let fecha       : String
    let mes         : String
    let anio        : String
    var activo      : String
    let id_noticia  : String
    let tipo_noticia: String
}

class NotificationResultListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func goBackAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    var keyWord : String = ""
    var listItems : [NotificationModel] = []
    var itemSelected : NotificationModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource   = self
        self.tableView.delegate     = self
    }
    override func viewDidAppear(_ animated: Bool) {
        self.inicializarListaDesdeCoreData()
    }

}

//MARK: - TableView
typealias NotificationResultListTableView = NotificationResultListViewController
extension NotificationResultListTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationSearchCell", for: indexPath) as! NotificationSearchCell
        cell.notificationModel = self.listItems[indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemSelected = self.listItems[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        
        let text = self.itemSelected.titulo.trimmingCharacters(in: .whitespacesAndNewlines)
        let storyBoard : UIStoryboard = UIStoryboard(name: "noticias", bundle: nil)
        let viewNameId = (self.itemSelected.tipo_noticia == "avance" ? "NoticiaDetalleAvances" : "NoticiaDetalle")
        
        let VC_2 = storyBoard.instantiateViewController(withIdentifier: viewNameId) as! NoticiaDetalleViewController
        if viewNameId == "NoticiaDetalleAvances" {
            let words = text.components(separatedBy: " ")
            let stringValue = String(words.last ?? "")
            let stringPhrase = words.prefix(words.count - 1).joined(separator: " ")
            let value = stringValue.replacingOccurrences(of: "%", with: "")
            guard let FloatValue = Float(value) else { return }
            let progress = (FloatValue/100)
            VC_2.progress       = progress
            VC_2.stringProgress = value
            VC_2.stringPhrase   = stringPhrase
        }
        
        let notice = NoticeModel(
            id_noticia      : self.itemSelected.id_noticia,
            titulo          : text,
            imgintermedia   : "",
            previewapp      : "",
            banner          : "",
            previa          : "",
            detalle         : self.itemSelected.descripcion,
            detalle2        : self.itemSelected.descripcion,
            resumen         : self.itemSelected.descripcion,
            tipo            : self.itemSelected.tipo_noticia,
            fecha           : self.itemSelected.fecha
        )
        VC_2.currentItem = notice
        
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(VC_2, animated: false)
    }
    

}


//MARK: - CoreData
typealias NotificationResultListCoreData = NotificationResultListViewController
extension NotificationResultListCoreData {
    
    func inicializarListaDesdeCoreData() {
        let sort = CoreDataManager.OrdenarPor(campos: ["fehca"], ascendente: false)
        var predicates = [NSPredicate]()
        predicates.append(CoreDataManager.Donde(campo: "descripcion", contiene: self.keyWord, caseSensitive: false))
        predicates.append(CoreDataManager.Donde(campo: "titulo", contiene: self.keyWord, caseSensitive: false))
        predicates.append(CoreDataManager.Donde(campo: "mes", contiene: self.keyWord, caseSensitive: false))
        predicates.append(CoreDataManager.Donde(campo: "anio", contiene: self.keyWord, caseSensitive: false))
        predicates.append(CoreDataManager.Donde(campo: "fehca", contiene: self.keyWord, caseSensitive: false))
        predicates.append(CoreDataManager.Donde(campo: "tipo", contiene: self.keyWord, caseSensitive: false))
        let predicateOR = CoreDataManager.agruparOR(predicates: predicates)
        
        let dtos = CoreDataManager.listaDe(entity: CDNotification.self, multiPredicate: [predicateOR], sortDescriptor: sort)
        
        if (dtos != nil) {
            self.listItems.removeAll()
            for detalle in dtos as! [NSManagedObject] {
                let item = NotificationModel(
                    titulo      : detalle.value(forKey: "titulo")  as? String ?? "",
                    descripcion : detalle.value(forKey: "descripcion")  as? String ?? "",
                    tipo        : detalle.value(forKey: "tipo")  as? String ?? "",
                    fecha       : detalle.value(forKey: "fehca")  as? String ?? "",
                    mes         : detalle.value(forKey: "mes")  as? String ?? "",
                    anio        : detalle.value(forKey: "anio")  as? String ?? "",
                    activo      : detalle.value(forKey: "activo")  as? String ?? "0",
                    id_noticia  : detalle.value(forKey: "id_noticia")  as? String ?? "0",
                    tipo_noticia: detalle.value(forKey: "tipo_noticia")  as? String ?? "0"
                    )
                self.listItems.append(item)
            }
            self.tableView.reloadData()
        } else {
            print("Fetching Failed")
        }
    }
    

    func guardarHistorialEnCoreData() {
        if self.listItems.count == 0 {
            return
        }
        if !CoreDataManager.truncarObjetos(entity: CDNotification.self) {
            print("Sin datos para truncar")
        }
        self.guardar()
    }

    func guardar() {
        for detalleDesdeArray in self.listItems {
            let detalle = CDNotification(context: CoreDataStack.managedObjectContext)
            self.configurarEntidad(entidad: detalle, item: detalleDesdeArray)
        }
    }

    func configurarEntidad(entidad: CDNotification, item: NotificationModel) {
        let date = item.fecha.toDate("yyyy-MM-dd", region: .local)
        let year = "\(date!.year)"
        let month = "\(date!.month)"
        entidad.fehca       = item.fecha
        entidad.descripcion = item.descripcion
        entidad.titulo      = item.titulo
        entidad.tipo        = item.tipo
        entidad.anio        = year
        entidad.mes         = month
        let resultado = CoreDataStack.saveContextBool() ? "\(item.fecha) guardada." : "asistencia #\(item.fecha) NO pudo guardarse."
        print(resultado)
    }
}
