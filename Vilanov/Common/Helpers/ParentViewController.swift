//
//  ParentViewController.swift
//  Vilanov
//
//  Created by andres on 3/5/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
