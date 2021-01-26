//
//  NoticiaDetalleViewController.swift
//  Vilanov
//
//  Created by andres on 2/25/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import Alamofire
import SwiftDate

struct NoticiaDetalleImagenes {
    let imagen : String
    let descripcion : String
}

class NoticiaDetalleViewController: UIViewController, UIScrollViewDelegate {

    //Vista Detalle normal
    @IBOutlet weak var imgnoticia       : UIImageView!
    @IBOutlet weak var viewbuttonreturn : UIView!
    @IBOutlet weak var viewscroll       : UIView!
    @IBOutlet weak var scroll           : UIScrollView!
    @IBOutlet weak var textView         : UITextView!
    @IBOutlet weak var titleLabel       : UILabel!
    @IBOutlet weak var imgIntermedia    : UIImageView!
    @IBOutlet weak var detalle2         : UITextView!
    @IBOutlet weak var imgIntermediaWidth: NSLayoutConstraint!
    @IBOutlet weak var detalle2Height: NSLayoutConstraint!
    
    
    // Vista Detalle Avances
    @IBOutlet weak var detail_date_v    : UIView!
    @IBOutlet weak var date_view        : UIView!
    @IBOutlet weak var progressBar      : UIProgressView!
    @IBOutlet weak var TituloTexto      : UILabel!
    @IBOutlet weak var tituloPorcentaje : UILabel!
    @IBOutlet weak var collectionView   : UICollectionView!
    @IBOutlet weak var collectionFechas : UICollectionView!
    @IBOutlet weak var imagenPlaceholderFondo: UIImageView!
    @IBOutlet weak var pageControl      : UIPageControl!
    @IBOutlet weak var btnFechaPrincipal: RoundedButtonWithShadow!
    
    @IBOutlet weak var fechaLabel: UILabel!
    
    @IBAction func `return`(_ sender: Any) {
        return_screen()
    }
    
    @IBAction func date_detail_hide(_ sender: Any) {
        UIView.animate(withDuration: 1, animations: {
            self.date_view.alpha = 1
        })
        
    }
    
    @IBAction func date_detail(_ sender: UIButton) {
        UIView.animate(withDuration: 1, animations: {
            self.date_view.alpha = 0
        })
    }

    @IBAction func returnAvance(_ sender: Any) {
        return_screen()
    }
    
    var listaItems      : [NoticiaDetalleImagenes] = []
    var listaFechas     : [String] = []
    var stringPhrase    : String = ""
    var stringProgress  : String = "0%"
    var progress        : Float = 0.0
    var currentItem     : NoticeModel!
    var currentImage    : UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.imgnoticia != nil {
            self.setData()
            self.scroll?.delegate = self
        }
        if detail_date_v != nil {
            self.setDataAvance()
        }
        if self.collectionView != nil {
            self.setCollectionView()
        }
    }
    
    func setData() {
        self.imgnoticia.image = currentImage
        if(currentItem.imgintermedia.isEmpty) {
            self.imgIntermediaWidth.constant = 0
            self.imgIntermedia.isHidden = true
        }else {
            self.imgIntermedia.sd_setImage(with: URL(string:EndPointConst.imagesUrl+currentItem.imgintermedia)!, placeholderImage: UIImage(named: "im_placeholder_house")!, options: .progressiveDownload, completed: nil)
        }
        
        self.titleLabel.text = currentItem.titulo
        
        let date = currentItem.fecha.toDate("yyyy-MM-dd", region: .local)
        let anio = String(date!.year)
        let mes = String(format: "%02d", date!.month)
        let dia = String(format: "%02d", date!.day)
        self.fechaLabel.text = "\(dia)-\(mes)-\(anio)"
        self.setTextViewTextSize()
    }
    
    func setTextViewTextSize() {
        self.textView.attributedText = currentItem.detalle.htmlToAttributedString
        self.textView.textColor = UIColor(hex: 0x606060)
        self.textView.textAlignment = .justified
        self.textView.font = UIFont(name: "Roboto-Light", size: 15.0)
        
        if(currentItem.detalle2.isEmpty) {
            self.detalle2Height.constant = 0
            self.detalle2.text = ""
            self.detalle2.isHidden = true
        }else {
            self.detalle2.attributedText = currentItem.detalle2.htmlToAttributedString
            self.detalle2.textColor = UIColor(hex: 0x606060)
            self.detalle2.textAlignment = .justified
            self.detalle2.font = UIFont(name: "Roboto-Light", size: 15.0)
        }
        

    }
    
    func return_screen() {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        //        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
    }
    
}

//MARK: - Avance de obra
typealias NoticiaDetalleAvance = NoticiaDetalleViewController
extension NoticiaDetalleAvance: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func setDataAvance() {
        self.progressBar.progress   = progress
        self.TituloTexto.text       = stringPhrase
        self.tituloPorcentaje.text  = " " + stringProgress + "%"
    }
    
    func setCollectionView() {
        self.initListItems()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        if self.collectionFechas != nil {
            self.collectionFechas.dataSource = self
            self.collectionFechas.delegate = self
            self.btnFechaPrincipal.titleLabel?.textAlignment = .center
        }
        
        self.configurarCollectionView()
    }
    
    func configurarCollectionView() {
        collectionView.reloadData()
        let width   = self.view.bounds.size.width - 1
        let height  = width * (4/6)
//        if self.collectionFechas != nil {
//            height  = imagenPlaceholderFondo.bounds.size.height
//        }else {
//            height = imgnoticia.bounds.size.height
//        }
        let collHeight = collectionView.bounds.size.height
        var verticalInsets: CGFloat = 1.0
        if( height < (collHeight/2)) {
            verticalInsets = 150.0
        }
//        let size = CGSize(width: width, height: height)
        let size = CGSize(width: width, height: collectionView.bounds.size.height)
        let cellSize = size
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = cellSize
        layout.sectionInset = UIEdgeInsets(top: verticalInsets, left: 0, bottom: verticalInsets, right: 10)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        collectionView.setCollectionViewLayout(layout, animated: false)
        self.view.layoutIfNeeded()
        //        self.contentView.setNeedsLayout()
        collectionView.reloadData()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            let visibleItems: NSArray = collectionView.indexPathsForVisibleItems as NSArray
            let currentItem: IndexPath = visibleItems.object(at: 0) as! IndexPath
            pageControl.currentPage = currentItem.row
            
            if self.collectionFechas != nil {
                let item = listaItems[currentItem.row]
                let stringDate = StringBtnStyle.changeDateStyle(date: item.descripcion)
                let amountText = StringBtnStyle.btnAttigutedText(string: stringDate)
                self.btnFechaPrincipal.setAttributedTitle(amountText, for: .normal)
                self.btnFechaPrincipal.titleLabel?.textAlignment = .center
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scroll != nil {
            if (scroll.contentOffset.y>=imgnoticia.frame.height){
                viewbuttonreturn.alpha=0.7
            } else {
                viewbuttonreturn.alpha=0
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView {
            return self.listaItems.count
        }else {
            return self.listaFechas.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.collectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvanceCollectionCell", for: indexPath) as! AvanceCollectionCell
            cell.noticeImage = self.listaItems[indexPath.row]
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvanceFechaCollectionCell", for: indexPath) as! AvanceFechaCollectionCell
            cell.rowNumber = indexPath.row
            cell.dateString = self.listaFechas[indexPath.row]
            return cell
        }
    }
}



//MARK: - Peticiones Http
typealias noticiasDetalleHttp = NoticiaDetalleViewController
extension noticiasDetalleHttp {
    
    func initListItems() {
        if !Accesibilidad.tieneInternet() {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.sinInternet)
            return
        }
        let url = EndPointConst.baseUrl() + EndPointConst.appQueries + EndPointConst.Noticias.getImages("Vilanova", currentItem!.tipo, "noticias", "\(currentItem!.id_noticia)")
        let headers = Headers.noSession
        print(url)
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: headers).responseJSON {
            response in
            DispatchQueue.main.async {
                let statusCode = "(\(response.response?.statusCode ?? 777)): "
                switch response.result {
                case .success:
                    if let data = response.data, let utf8Text = String(data: data, encoding: .utf8) {
                        let json = JSON(data: (utf8Text.data(using: .utf8)!))
                        let titulo      = json[EndPointConst.Response.noticias][EndPointConst.Response.titulo].string ?? Const.tituloAviso
                        let mensaje     =  Const.servidorNoResponde
                        
                        if(response.response?.statusCode == 200) {
                            let data    = json
                            print(json)
                            if(data.count > 0) {
                                self.pageControl.numberOfPages = data.count
                                self.listaItems.removeAll()
                                self.listaFechas.removeAll()
                                for index in 0...(data.count - 1) {
                                    let notice = NoticiaDetalleImagenes(
                                        imagen      : data[index]["imagen"].string      ?? "",
                                        descripcion : data[index]["descripcion"].string ?? ""
                                    )
                                    self.listaItems.append(notice)
                                    self.listaFechas.append(data[index]["descripcion"].string ?? "")
                                }
                                
                            }
                            self.collectionView.reloadData()
                            if self.collectionFechas != nil {
                                self.collectionFechas.reloadData()
                                let stringDate = StringBtnStyle.changeDateStyle(date: self.listaItems[0].descripcion)
                                let amountText = StringBtnStyle.btnAttigutedText(string: stringDate)
                                self.btnFechaPrincipal.setAttributedTitle(amountText, for: .normal)
                                self.btnFechaPrincipal.titleLabel?.textAlignment = .center
                            }
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
                        MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: Const.requestFail)
                    }
                    break
                }
            }
        }
    }
    
}

import SDWebImage
class AvanceCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imagenAvance: UIImageView!
    
    var noticeImage : NoticiaDetalleImagenes? {
        didSet {
            if let noticeImage = noticeImage {
                self.setImageWith(noticeImage.imagen)
            }
        }
    }
    
    func setImageWith(_ name: String) {
        let urlString = EndPointConst.imagesUrl + name
        let url = URL(string: urlString)
        
        self.imagenAvance.sd_setImage(with: url, completed: {
            (placeHolder, error, imgCacheType, url) in
            //print(url ?? "NO ULR!")
        })
    }
}

class AvanceFechaCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var btnFecha: UIButton!
    @IBAction func btnFechaAction(_ sender: UIButton) {
        self.goToItemSelected()
    }
    
    var rowNumber: Int!
    var dateString : String? {
        didSet {
            if let dateString = dateString {
                let stringDate = StringBtnStyle.changeDateStyle(date: dateString)
                let amountText = StringBtnStyle.btnAttigutedText(string: stringDate, color: .primary())
                btnFecha.setAttributedTitle(amountText, for: .normal)
                btnFecha.titleLabel?.textAlignment = .center
                
            }
        }
    }
    
    func goToItemSelected() {
        if let padreController = self.parentViewController as? NoticiaDetalleViewController {
            padreController.collectionView.scrollToItem(at: IndexPath(item: rowNumber, section: 0), at: .centeredHorizontally, animated: true)
            padreController.pageControl.currentPage = rowNumber
        }else {
            print("NO ALCANZO AL ViewController: NoticiaDetalleViewController")
        }
    }
}


class StringBtnStyle {
    static func changeDateStyle(date: String) -> String {
        let isoDate = date
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM"
        dateFormatter2.dateFormat = "dd\nMM\nyyyy"
        dateFormatter.locale = Locale.current
        guard let datez = dateFormatter.date(from:isoDate) else { return "" }
        return dateFormatter2.string(from: datez)
    }
    
    static func changeDateStyle2(date: String) -> String {
        let isoDate = date
        let dateFormatter = DateFormatter()
        let dateFormatter2 = DateFormatter()
        dateFormatter.dateFormat = "yyyy-dd-MM"
        dateFormatter2.dateFormat = " dd\n MM\nyyyy"
        dateFormatter.locale = Locale.current
        guard let datez = dateFormatter.date(from:isoDate) else { return "" }
        return dateFormatter2.string(from: datez)
    }
    
    static func btnAttigutedText(string: String, color: UIColor = UIColor.white) -> NSMutableAttributedString {
        if string.count < 6 {
            return NSMutableAttributedString.init(string: string)
        }
        let amountText = NSMutableAttributedString.init(string: string)
        amountText.setAttributes(
            [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: color
            ],
            range: NSMakeRange(0, 6)
        )
        return amountText
    }
    
    static func btnAttigutedText2(string: String, lenght: Int, color: UIColor = UIColor.white) -> NSMutableAttributedString {
        if string.count < lenght {
            return NSMutableAttributedString.init(string: string)
        }
        let amountText = NSMutableAttributedString.init(string: string)
        amountText.setAttributes(
            [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: 15),
                NSAttributedStringKey.foregroundColor: color
            ],
            range: NSMakeRange(0, lenght)
        )
        return amountText
    }
}
