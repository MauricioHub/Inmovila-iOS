//
//  uiLabelAlign.swift
//  Vilanov
//
//  Created by Daniel Santander on 5/13/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable

class uiLabelAlign: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func drawText(in rect: CGRect) {
        if let text = text as NSString? {
            func defaultRect(for maxSize: CGSize) -> CGRect {
                let size = text
                    .boundingRect(
                        with: maxSize,
                        options: NSStringDrawingOptions.usesLineFragmentOrigin,
                        attributes: [
                            NSAttributedStringKey.font: font
                        ],
                        context: nil
                    ).size
                let rect = CGRect(
                    origin: .zero,
                    size: CGSize(
                        width: min(frame.width, ceil(size.width)),
                        height: min(frame.height, ceil(size.height))
                    )
                )
                return rect
                
            }
            switch contentMode {
            case .top, .bottom, .left, .right, .topLeft, .topRight, .bottomLeft, .bottomRight:
                let maxSize = CGSize(width: frame.width, height: frame.height)
                var rect = defaultRect(for: maxSize)
                switch contentMode {
                case .bottom, .bottomLeft, .bottomRight:
                    rect.origin.y = frame.height - rect.height
                default: break
                }
                switch contentMode {
                case .right, .topRight, .bottomRight :
                    rect.origin.x = frame.width - rect.width
                default: break
                }
                switch contentMode {
                case  .bottom:
                    rect.origin.x = (frame.width - rect.width)/2
                default: break
                }
                super.drawText(in: rect)
            default:
                super.drawText(in: rect)
            }
        } else {
            super.drawText(in: rect)
        }
    }

}
