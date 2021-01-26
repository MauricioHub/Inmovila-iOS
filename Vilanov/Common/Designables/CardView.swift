//
//  CardView.swift
//  Vilanov
//
//  Created by andres on 3/7/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//
import UIKit

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius         : CGFloat = 3
    @IBInspectable var shadowOffsetWidth    : Int = 0
    @IBInspectable var shadowOffsetHeight   : Int = 3
    @IBInspectable var shadowColor          : UIColor? = UIColor.black
    @IBInspectable var shadowOpacity        : Float = 0.5
    @IBInspectable var borderWidth          : CGFloat = 0.0
    @IBInspectable var borderColor          : UIColor? = UIColor.darkGray
    
    override func layoutSubviews() {
        layer.borderWidth = self.borderWidth
        layer.borderColor = self.borderColor?.cgColor
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        layer.masksToBounds = true
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}
