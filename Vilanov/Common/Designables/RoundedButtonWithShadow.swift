//
//  RoundedButtonWithShadow.swift
//  Vilanov
//
//  Created by andres on 3/4/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedButtonWithShadow: UIButton {
    
    @IBInspectable var corners                  : CGFloat = 0
    @IBInspectable var shadowOffsetWidth        : Int = 0
    @IBInspectable var shadowOffsetHeight       : Int = 3
    @IBInspectable var shadowColor              : UIColor? = UIColor.black
    @IBInspectable var shadowOpacity            : Float = 0.5
    @IBInspectable var titleColor               : UIColor? = UIColor.white
    @IBInspectable var titleColorFocus          : UIColor? = UIColor.accent()
    @IBInspectable var titleColorHighlight      : UIColor? = UIColor.accent()
    @IBInspectable var roundedBackgroundColor   : UIColor? = UIColor.primary()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(corners == 0) {
            corners = ( self.bounds.size.height / 2 )
        }
        layer.cornerRadius = corners
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: corners)
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        self.setTitleColor(titleColor, for: UIControlState.normal)
        self.setTitleColor(titleColorHighlight, for: UIControlState.highlighted)
        self.setTitleColor(titleColorFocus, for: UIControlState.focused)
        self.backgroundColor = roundedBackgroundColor
        
    }
}
