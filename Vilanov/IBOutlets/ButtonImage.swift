//
//  ButtonImage.swift
//  Vilanov
//
//  Created by Daniel on 14/12/18.
//  Copyright © 2018 Inmovila. All rights reserved.
//

import UIKit



class ButtonImage: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageView?.frame.size.height=15
            imageView?.frame.size.width=15
            
            let top = (bounds.height-((imageView?.frame.height)! +  (titleLabel?.frame.height)!)) / 2
            let title =  ((imageView?.frame.size.width)! )
            if (titleLabel?.text=="Inicio"){
                imageEdgeInsets = UIEdgeInsets(top: top-3, left: 0, bottom: -((titleLabel?.frame.height)!+5), right: -((titleLabel?.frame.width)!+25))
            } else {
                imageEdgeInsets = UIEdgeInsets(top: top-3, left: 0, bottom: -((titleLabel?.frame.height)!+5), right: -((titleLabel?.frame.width)!+15))
            }
            titleEdgeInsets = UIEdgeInsets(top: 35, left: -(title+15), bottom: top-3, right: 0)
            print(title)
            
            
            
        }
        
    }


}
