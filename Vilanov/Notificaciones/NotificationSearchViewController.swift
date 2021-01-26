//
//  NoticiasBusquedaViewController.swift
//  Vilanov
//
//  Created by andres on 3/16/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit

class NotificationSearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: DisenoTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goBackAction(_ sender: Any) {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionMoveIn
        transition.subtype = kCATransitionFromTop
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func ir_notificaciones(_ sender: Any) {
        let text = searchTextField.text!
        if(text.isEmpty) {
            MyAlert.alertDefault(view: self, titulo: Const.tituloAviso, mensaje: "Debes agregar un texto para poder realizar la búsqueda.")
            return
        }
        let storyBoard : UIStoryboard = UIStoryboard(name: "notificaciones", bundle: nil)
        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "NotificationResultListViewController") as! NotificationResultListViewController
        ViewControllerDos.keyWord = text
//        let ViewControllerDos = storyBoard.instantiateViewController(withIdentifier: "NotificationListViewController") as! NotificationResultLis

        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.window!.layer.add(transition, forKey: kCATransition)
        self.present(ViewControllerDos, animated: true)
    }

}
