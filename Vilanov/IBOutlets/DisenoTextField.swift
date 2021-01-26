//
//  DisenoTextField.swift
//  Vilanov
//
//  Created by Daniel on 27/11/18.
//  Copyright © 2018 Inmovila. All rights reserved.
//

import UIKit


class DisenoTextField: UITextField {

    @IBInspectable var leftImagen: UIImage?{
        didSet{
            UpdateView()
        }
    }
    @IBInspectable var rightImagen: UIImage?{
        didSet{
            UpdateView()
        }
    }
    @IBInspectable var leftPadding: CGFloat = 0{
        didSet{
            UpdateView()
        }
    }
    func UpdateView(){
        layer.cornerRadius = 5
        if let image = leftImagen {
            layer.borderWidth = 0.5
            layer.borderColor = UIColor.lightGray.cgColor
            leftViewMode = .always
            let imageView = UIImageView(frame:CGRect(x:leftPadding,y:0,width:20,height:20))
            imageView.image = image
            let width = leftPadding + 20
            let view = UIView(frame:CGRect(x:0,y:0,width:width,height:20))
            view.addSubview(imageView)
            
            leftView = view
        } else if let image = rightImagen{
            layer.borderWidth = 0
            rightViewMode = .always
            let imageView = UIImageView(frame:CGRect(x:0,y:0,width:20,height:20))
            imageView.image = image
            let width = leftPadding + 20
            let view = UIView(frame:CGRect(x:0,y:0,width:width,height:20))
            self.backgroundColor = UIColor.clear
            
            view.addSubview(imageView)
            
            rightView = view
            
            
        } else {
            leftViewMode = .never
        }
    }

}



class FormTextField: UITextField {
    
    @IBInspectable var borderColor: UIColor? {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderCorner: CGFloat = 0 {
        didSet {
            layer.cornerRadius = borderCorner
            leftViewMode = .always
            
            
            let view = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
            //view.addSubview(imageView)
            
            leftView = view
        }
    }
}
