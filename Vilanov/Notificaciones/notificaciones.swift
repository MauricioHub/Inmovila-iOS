//
//  notificaciones.swift
//  Vilanov
//
//  Created by Daniel on 09/03/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import CoreData

class NotificationListViewController: UIViewController {

    @IBOutlet weak var detalle_notificaciones: UITableView!
    @IBOutlet weak var title_det_not    : UILabel!
    @IBOutlet weak var line_det_noti    : UIView!
    @IBOutlet weak var but_det_not      : UIButton!
    @IBOutlet weak var notificacion_btn : UIButton!
    @IBOutlet weak var archivado_btn    : UIButton!
    @IBOutlet weak var del_com          : UIView!
    @IBOutlet weak var del_height_cons  : NSLayoutConstraint!
    @IBOutlet weak var view_oculto      : UIView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var keyWord     : String = "1"
    var listItems   : [NotificationModel] = []
    var itemSelected: NotificationModel!
    
    var sectionNames = [String]()
    var sectionItems = [[NotificationModel]]()
    var expandedSectionHeaderNumber: Int = -1
    let kHeaderSectionTag: Int = 6900;
    let kHeaderSectionTag2: Int = 16900;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.del_com_hide()
        self.tableView.dataSource   = self
        self.tableView.delegate     = self
        self.tableView.tableFooterView = UIView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        
        view.addGestureRecognizer(tap)
        
        view.isUserInteractionEnabled = true
        
        self.view.addSubview(view_oculto)
        self.view.sendSubview(toBack: view_oculto)
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        del_com_hide()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.inicializarListaDesdeCoreData()
//        itemSelected = listItems[1]
//        self.delete_archive()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func show_notificaciones(_ button: UIButton) {
        if (detalle_notificaciones.alpha==1) {
            detalle_notificaciones.alpha=0
            
            button.setImage(UIImage(named: "ico_notificacioines_add.png"), for: .normal)
            line_det_noti.backgroundColor =  UIColorFromHex(rgbValue: 0xF2F2F2)
            title_det_not.textColor = UIColorFromHex(rgbValue: 0xDDDDDD)
        } else {
            detalle_notificaciones.alpha=1
            
            button.setImage(UIImage(named: "ico_notificaciones_del"), for: .normal)
            line_det_noti.backgroundColor =  UIColorFromHex(rgbValue: 0xFFFFFF)
            title_det_not.textColor = UIColorFromHex(rgbValue: 0x00ADB5)
        }
    }
    
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
    
    @IBAction func del_cont_show(_ sender: Any) {
        del_cont_show()
    }
    
    func del_cont_show() {
        let heightsv = self.view.frame.size.height/2
        UIView.animate(withDuration: 0.2, animations: {
            self.del_height_cons.constant=heightsv
            self.view.layoutIfNeeded()
            
        },completion: { (finished:Bool) in
            self.del_com.alpha=1
        })
    }
    
    @IBAction func del_com_hide(_ sender: Any) {
        del_com_hide()
    }
    
    func del_com_hide() {
        self.del_com.alpha=0
        let _ = self.view.frame.size.height
        UIView.animate(withDuration: 0.2, animations: {
            self.del_height_cons.constant=0
            self.view.layoutIfNeeded()
            
        })
    }
    
    @IBAction func notificaciones(_ sender: Any) {
        archivado_btn.backgroundColor = UIColor.clear
        notificacion_btn.backgroundColor = UIColorFromHex(rgbValue: 0xFFFFFF)
        keyWord = "1"
        inicializarListaDesdeCoreData()
    }
    
    @IBAction func archivados(_ sender: Any) {
        archivado_btn.backgroundColor = UIColorFromHex(rgbValue: 0xFFFFFF)
        notificacion_btn.backgroundColor = UIColor.clear
        keyWord = "0"
        inicializarListaDesdeCoreData()
    }

    
    @IBAction func `return`(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func deleteNotificationAction(_ sender: UIButton) {
        _ = self.delete(notification: self.itemSelected)
    }
    
    @IBAction func archiveNotificationAction(_ sender: UIButton) {
        self.archive(notification: self.itemSelected)
    }
    
}

//MARK: - TableView
typealias NotificationListTableView = NotificationListViewController
extension NotificationListViewController: UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.del_com_hide()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if sectionNames.count > 0 {
            tableView.backgroundView = nil
            return sectionNames.count
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Actualmente no tienes notificaciones."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "Roboto-Light", size: 13.0)!
            messageLabel.textColor = UIColorFromHex(rgbValue: 0x606060)
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.listItems.count
        if (self.expandedSectionHeaderNumber == section) {
            let arrayOfItems = self.sectionItems[section]
            return arrayOfItems.count;
        } else {
            return 0;
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (self.sectionNames.count != 0) {
            return self.sectionNames[section]
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44.0;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat{
        return 0;
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        //recast your view as a UITableViewHeaderFooterView
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.contentView.backgroundColor = UIColor.white
        header.textLabel?.textColor = UIColor.primary()
        
        if let viewWithTag = self.view.viewWithTag(kHeaderSectionTag + section) {
            viewWithTag.removeFromSuperview()
        }
        let headerFrame = self.view.frame.size
        let size = header.contentView.bounds.size
        let theImageView = UIImageView(frame: CGRect(x: headerFrame.width - 60, y: 5, width: 30, height: 30))
        let libeBottomView = UIView(frame: CGRect(x: 20, y: size.height - 1, width: size.width - 40, height: 1.0) )
        libeBottomView.tag = kHeaderSectionTag2 + section
        libeBottomView.backgroundColor = UIColor.primary()
        theImageView.image = UIImage(named: "ico_notificacioines_add.png")
        theImageView.tag = kHeaderSectionTag + section
        header.addSubview(theImageView)
        header.addSubview(libeBottomView)
        
        // make headers touchable
        header.tag = section
        let headerTapGesture = UITapGestureRecognizer()
        headerTapGesture.addTarget(self, action: #selector(self.sectionHeaderWasTouched(_:)))
        header.addGestureRecognizer(headerTapGesture)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.notificationModel = self.sectionItems[indexPath.section][indexPath.row]
        cell.tag = indexPath.row
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.itemSelected = self.sectionItems[indexPath.section][indexPath.row]
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
    
    // MARK: - Expand / Collapse Methods
    
    @objc func sectionHeaderWasTouched(_ sender: UITapGestureRecognizer) {
        let headerView = sender.view as! UITableViewHeaderFooterView
        let section    = headerView.tag
        let eImageView = headerView.viewWithTag(kHeaderSectionTag + section) as? UIImageView
        let lineView   = headerView.viewWithTag(kHeaderSectionTag2 + section)
        
        if (self.expandedSectionHeaderNumber == -1) {
            self.expandedSectionHeaderNumber = section
            tableViewExpandSection(section, imageView: eImageView!, lineView: lineView!)
        } else {
            if (self.expandedSectionHeaderNumber == section) {
                tableViewCollapeSection(section, imageView: eImageView!, lineView: lineView!)
            } else {
                let cImageView = self.view.viewWithTag(kHeaderSectionTag + self.expandedSectionHeaderNumber) as? UIImageView
                tableViewCollapeSection(self.expandedSectionHeaderNumber, imageView: cImageView!, lineView: lineView!)
                tableViewExpandSection(section, imageView: eImageView!, lineView: lineView!)
            }
        }
    }
    
    func tableViewCollapeSection(_ section: Int, imageView: UIImageView, lineView: UIView) {
        let sectionData = self.sectionItems[section]
        
        self.expandedSectionHeaderNumber = -1;
        if (sectionData.count == 0) {
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (90.0 * CGFloat(Double.pi)) / 180.0)
                imageView.image = UIImage(named: "ico_notificacioines_add.png")
                //lineView.alpha = 1
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.tableView!.beginUpdates()
            self.tableView!.deleteRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func tableViewExpandSection(_ section: Int, imageView: UIImageView, lineView: UIView) {
        let sectionData = self.sectionItems[section]
        
        if (sectionData.count == 0) {
            self.expandedSectionHeaderNumber = -1;
            return;
        } else {
            UIView.animate(withDuration: 0.4, animations: {
                imageView.transform = CGAffineTransform(rotationAngle: (0.0 * CGFloat(Double.pi)) / 180.0)
                imageView.image = UIImage(named: "ico_notificaciones_del")
                //lineView.alpha = 0
            })
            var indexesPath = [IndexPath]()
            for i in 0 ..< sectionData.count {
                let index = IndexPath(row: i, section: section)
                indexesPath.append(index)
            }
            self.expandedSectionHeaderNumber = section
            self.tableView!.beginUpdates()
            self.tableView!.insertRows(at: indexesPath, with: UITableViewRowAnimation.fade)
            self.tableView!.endUpdates()
        }
    }
    
    func delete_archive() {
        if self.itemSelected.activo == "0" {
            _ = self.delete(notification: self.itemSelected)
        }else {
            self.archive(notification: self.itemSelected)
        }
    }
    
}

//MARK: - CoreData
typealias NotificationListCoreData = NotificationListViewController
extension NotificationListViewController {
    
    func inicializarListaDesdeCoreData() {
        let sort = CoreDataManager.OrdenarPor(campos: ["fehca"], ascendente: false)
        var predicates = [NSPredicate]()
        predicates.append(CoreDataManager.Donde(campo: "activo", es: self.keyWord) )
        
        let dtos = CoreDataManager.listaDe(entity: CDNotification.self, multiPredicate: nil, sortDescriptor: sort)
        
        if (dtos != nil) {
            self.listItems.removeAll()
            for detalle in dtos as! [NSManagedObject] {
                if (detalle.value(forKey: "activo")  as? String ?? "0") == self.keyWord {
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
            }
            self.makeCollapsibleSectionsData()
            self.tableView.reloadData()
        } else {
            print("Zero coincidences")
            sectionNames.removeAll()
            sectionItems.removeAll()
            self.tableView.reloadData()
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "Actualmente no tienes notificaciones."
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = .center;
            messageLabel.font = UIFont(name: "Roboto-Light", size: 13.0)!
            messageLabel.textColor = UIColorFromHex(rgbValue: 0x606060)
            messageLabel.sizeToFit()
            self.tableView.backgroundView = messageLabel;
        }
        
        //DATOS DE PRUEBA...
//        listItems = [
//            NotificationModel(titulo: "titulo 50%", descripcion: "ssdfosf ahfskdfh skfhlskfh sklfhklshf klasdklahl", tipo: "avance de obras", fecha: "2019-05-01", mes: "05", anio: "2019", activo: "1", id_noticia: "14", tipo_noticia: "avance"),
//            NotificationModel(titulo: "titulo 10%", descripcion: "ssdfosf ahfskdfh skfhlskfh sklfhklshf klasdklahl", tipo: "avance de obras", fecha: "2019-05-03", mes: "05", anio: "2019", activo: "1", id_noticia: "14", tipo_noticia: "avance"),
//            NotificationModel(titulo: "titulo 80%", descripcion: "ssdfosf ahfskdfh skfhlskfh sklfhklshf klasdklahl", tipo: "avance de obras", fecha: "2019-03-01", mes: "05", anio: "2019", activo: "1", id_noticia: "14", tipo_noticia: "avance"),
//            NotificationModel(titulo: "titulo normal", descripcion: "ssdfosf ahfskdfh skfhlskfh sklfhklshf klasdklahl", tipo: "avance de obras", fecha: "2019-05-01", mes: "05", anio: "2019", activo: "1", id_noticia: "6", tipo_noticia: "inmovila")
//        ]
//        self.makeCollapsibleSectionsData()
        
    }
    
    func save(notification: NotificationModel) {
        let entidad = CDNotification(context: CoreDataStack.managedObjectContext)
        self.configurarEntidad(entidad: entidad, item: notification)
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
    
    func archive(notification: NotificationModel) {
        if delete(notification: notification) {
            var notif = notification
            notif.activo = "0"
            self.save(notification: notif)
            self.inicializarListaDesdeCoreData()
        }else {
            print("No se pudo borrar entidad para luego actualizar")
        }
    }
    
    func delete(notification: NotificationModel) -> Bool {
        var predicates = [NSPredicate]()
        predicates.append(CoreDataManager.Donde(campo: "descripcion", es: notification.descripcion) )
        predicates.append(CoreDataManager.Donde(campo: "fehca", es: notification.fecha))
        let groupedAnd = CoreDataManager.agruparAND(predicates: predicates)
        guard let result = CoreDataManager.borrarObjetos(entity: CDNotification.self, multiPredicate: [groupedAnd]) else {
            return false
        }
        CoreDataStack.saveContext()
        self.inicializarListaDesdeCoreData()
        return result
    }
    
}

typealias NotificationListData = NotificationListViewController
extension NotificationListData {
    
    func makeCollapsibleSectionsData() {
        var year_month = ""
        var new_year_month = ""
        var countSection : Int!
        sectionNames.removeAll()
        sectionItems.removeAll()
        for notif in listItems {
            let date = notif.fecha.toDate("yyyy-MM-dd", region: .local)
            new_year_month = "\(date!.year) - \(date!.monthName(.default))"
            if year_month != new_year_month {
                countSection = (countSection == nil ? 0 : (countSection + 1) )
                sectionNames.append(new_year_month)
                year_month = new_year_month
                if(sectionItems.indices.contains(countSection)) {
                    sectionItems[countSection].append(notif)
                }else {
                    sectionItems.append([notif])
                }
            }else {
                sectionItems[countSection].append(notif)
            }
        }
        //print(sectionNames)
        //print(sectionItems)
        self.tableView.reloadData()
    }
}

//MARK: - TAbleView Interactions
typealias NotificationListInteractions = NotificationListViewController
extension NotificationListInteractions {
    
}
