//
//  UIColorHelper.swift
//  Vilanov
//
//  Created by andres on 2/28/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    static func with(stringHex: String) -> UIColor {
        var cString:String = stringHex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    class func primary() -> UIColor {
        return UIColor(hex: 0x2599a1)
    }
    
    class func accent() -> UIColor {
        return UIColor(hex: 0x6b696b)
    }
    
    class func neutral() -> UIColor {
        return UIColor(hex: 0x9b9b9b)
    }
    
    class func ternary() -> UIColor {
        return UIColor(hex: 0xCCCCCC)
    }
    
    class func veryLightGray() -> UIColor {
        return UIColor(hex: 0xCCCCCC)
    }
    
    class func grayNormal() -> UIColor {
        return UIColor(hex: 0x999999)
    }
    
    class func backgroundImage() -> UIColor {
        return UIColor(hex: 0xf2f2f2)
    }
    
    public func randomColor() -> UIColor {
        let colors: [UIColor] = [
            UIColor(hex: 0x008080),
            UIColor(hex: 0xffe4e1),
            UIColor(hex: 0xff0000),
            UIColor(hex: 0xffd700),
            UIColor(hex: 0x40e0d0),
            UIColor(hex: 0xff7373),
            UIColor(hex: 0xd3ffce),
            UIColor(hex: 0xe6e6fa),
            UIColor(hex: 0x800000),
            UIColor(hex: 0x20b2aa),
            UIColor(hex: 0x088da5),
            UIColor(hex: 0xc0d6e4),
            UIColor(hex: 0x8a2be2),
            UIColor(hex: 0x3399ff),
            UIColor(hex: 0xfef65b),
            UIColor(hex: 0x6dc066),
            UIColor(hex: 0x191919),
            ]
        
        let color = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        return color
    }
}
