//
//  invitados.swift
//  Vilanov
//
//  Created by Daniel Santander on 7/6/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit


class invitados: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detalle_notificaciones: UITableView!
    @IBOutlet weak var title_det_not    : UILabel!
    @IBOutlet weak var line_det_noti    : UIView!
    @IBOutlet weak var but_det_not      : UIButton!
    @IBOutlet weak var notificacion_btn : UIButton!
    @IBOutlet weak var archivado_btn    : UIButton!
    @IBOutlet weak var del_com          : UIView!
    @IBOutlet weak var del_height_cons  : NSLayoutConstraint!
    @IBOutlet weak var view_oculto      : UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self
        self.tableView.dataSource=self
        self.tableView.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        
        
        view.isUserInteractionEnabled = true
        
        self.view.addSubview(view_oculto)
        self.view.sendSubview(toBack: view_oculto)
    }
    
    @IBAction func `return`(_ sender: Any) {
        return_screen()
    }
    
    @IBAction func regresar_lista(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "eventos")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    func return_screen(){
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "inicial", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "view_2")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    
    @IBAction func crear_invitado(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "invitados", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "nuevo_invitado")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    @IBAction func crear_evento(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "nuevo_evento")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    @IBAction func crear_evento_invi(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "nuevo_evento_invi")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    
    @IBAction func detalle_evento(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "detalle_evento")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    @IBAction func eventos_lista(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "eventos_lista")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
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
    
    @IBAction func delshow(_ sender: Any) {
        
        del_cont_show()
    }
    @IBAction func del_cont_show(_ sender: Any) {
        del_cont_show()
    }
    
    func del_cont_show() {
        
        self.del_com.alpha=1
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
        
    }
    
    @IBAction func archivados(_ sender: Any) {
        archivado_btn.backgroundColor = UIColorFromHex(rgbValue: 0xFFFFFF)
        notificacion_btn.backgroundColor = UIColor.clear
       
    }
    
    
    
    
    @IBAction func deleteNotificationAction(_ sender: UIButton) {
     
    }
    
    @IBAction func archiveNotificationAction(_ sender: UIButton) {
     
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



extension invitados: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //println(tasks[indexPath.row])
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "eventos_lista")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        if (indexPath[1]==0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "invitadoCell") as! invitadosCell
            cell.loadCell()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "invitadoCellgarita") as! invitadosCell
            cell.loadCell()
            return cell
        }
        
    }
    
    
}


class new_invitados: UIViewController, UITextViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    @IBOutlet weak var txtactive    : UIButton!
    @IBOutlet weak var height_content_picker: NSLayoutConstraint!
    @IBOutlet weak var PickerView: UIPickerView!
    @IBOutlet weak var servicio_btn: UIButton!
    @IBOutlet weak var invitado_btn: UIButton!
    let dias_array  = ["0","1","2","3","4","5","6","7","8","9","10","11","12"]
    let number_pickers  = ["0","1","2","3","4","5","6","7","8","9","10","11","12"]
    var Array_picker = [String]()
    @IBOutlet weak var comentarios: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        comentarios.delegate = self
        comentarios.text = "Escriba su comentario"
        comentarios.textColor = UIColor.lightGray
        self.PickerView.delegate = self
        
    }
    
    @IBAction func `return`(_ sender: Any) {
        return_screen()
    }
    
    func return_screen(){
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return Array_picker[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return Array_picker.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.txtactive.setTitle(Array_picker[row], for: .normal)
        
    }
    
    
    
    @IBAction func pickershowd(_ sender: UIButton) {
        self.height_content_picker.constant=150
        txtactive = sender
        Array_picker=[]
        for n in 1...31 {
            Array_picker.append(String(n))
        }
        
        self.PickerView.reloadAllComponents()
        txtactive=sender
        
    }
    @IBAction func pickershowm(_ sender: UIButton) {
        self.height_content_picker.constant=150
        txtactive = sender
        Array_picker=[]
        for n in 1...12 {
            Array_picker.append(String(n))
        }
        self.PickerView.reloadAllComponents()
        txtactive=sender
        
    }
    @IBAction func pickershowa(_ sender: UIButton) {
        self.height_content_picker.constant=150
        txtactive = sender
        Array_picker=[]
        for n in 1950...2050 {
            Array_picker.append(String(n))
        }
        
        self.PickerView.reloadAllComponents()
        txtactive=sender
        
    }
    @IBAction func pickershowh(_ sender: UIButton) {
        self.height_content_picker.constant=150
        txtactive = sender
        Array_picker=[]
        for n in 1...24 {
            Array_picker.append(String(n))
        }
        
        self.PickerView.reloadAllComponents()
        txtactive=sender
        
    }
    @IBAction func pickershowmin(_ sender: UIButton) {
        self.height_content_picker.constant=150
        txtactive = sender
        Array_picker=[]
        for n in 1...60 {
            Array_picker.append(String(n))
        }
        
        self.PickerView.reloadAllComponents()
        txtactive=sender
        
    }
    @IBAction func pickerhide(_ sender: Any) {
        //self.content_picker.alpha = 0
        
        self.height_content_picker.constant=0
        
    }
    @IBAction func lista_evento_invi(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "felicidades_evento")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    @IBAction func ir_anunciar(_ sender: Any) {
        
        
            let storyBoard : UIStoryboard = UIStoryboard(name: "invitados", bundle: nil)
            let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "anunciar")
            let transition = CATransition()
            transition.duration = 0.4
            transition.type = kCATransitionMoveIn
            transition.subtype = kCATransitionFromRight
            self.view.window!.layer.add(transition, forKey: kCATransition)
            self.present(ViewControllerDos, animated: false)
        
        
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if comentarios.text != "" {
            comentarios.text = ""
            
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if comentarios.text == "" {
            
            comentarios.text = "Escriba su comentario"
            comentarios.textColor = UIColor.lightGray
        }
    }
    
    
    @IBAction func invitados(_ sender: Any) {
        servicio_btn.backgroundColor = UIColor.clear
        invitado_btn.backgroundColor = UIColorFromHex(rgbValue: 0x00ACB4)
        invitado_btn.setTitleColor(UIColorFromHex(rgbValue: 0xFFFFFF), for: .normal)
        servicio_btn.setTitleColor(UIColorFromHex(rgbValue: 0x606060), for: .normal)
    }
    
    
    @IBAction func finalizar_eve_invi(_ sender: Any) {
        servicio_btn.backgroundColor = UIColor.clear
        invitado_btn.backgroundColor = UIColorFromHex(rgbValue: 0x00ACB4)
        invitado_btn.setTitleColor(UIColorFromHex(rgbValue: 0xFFFFFF), for: .normal)
        servicio_btn.setTitleColor(UIColorFromHex(rgbValue: 0x606060), for: .normal)
    }
    @IBAction func servicio(_ sender: Any) {
        servicio_btn.backgroundColor = UIColorFromHex(rgbValue: 0x00ACB4)
        invitado_btn.backgroundColor = UIColor.clear
        servicio_btn.setTitleColor(UIColorFromHex(rgbValue: 0xFFFFFF), for: .normal)
        invitado_btn.setTitleColor(UIColorFromHex(rgbValue: 0x606060), for: .normal)
    }
    func UIColorFromHex(rgbValue:UInt32, alpha:Double=1.0)->UIColor {
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:CGFloat(alpha))
    }
}
class felicidad: UIViewController, UITextViewDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func finalizar_click(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "eventos", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "eventos_lista")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    @IBAction func finalizar_click_i(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "invitados", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "invitados")
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: false)
    }
    @IBAction func `return`(_ sender: Any) {
        return_screen()
    }
    
    func return_screen(){
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
}
