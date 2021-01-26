//
//  MyAlert.swift
//  Vilanov
//
//  Created by andres on 2/24/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation
import UIKit

class MyAlert{
    
    static public func alertDefault(view: UIViewController ,titulo: String, mensaje: String){
        let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        view.present(alertController, animated: true)
    }
    
    static public func alert(view: UIViewController ,title: String , message: String, buttons:[UIAlertAction]? = nil, style: UIAlertControllerStyle = .alert) {
        var alertStyle : UIAlertControllerStyle?
        if style != .actionSheet {
            alertStyle = style
        }else {
            alertStyle = alertStyleByDevice()
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle!)
        
        if let buttons = buttons {
            for (key) in buttons {
                alert.addAction(key)
            }
        }else {
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        }

        DispatchQueue.main.async {
            view.present(alert, animated: true, completion: nil)
        }
    }
    
    private static func alertStyleByDevice() -> UIAlertControllerStyle {
        let deviceIdiom = UIScreen.main.traitCollection.userInterfaceIdiom
        switch (deviceIdiom) {
        case .phone:
            return .actionSheet
        default:
            return .alert
        }
    }
    
}
