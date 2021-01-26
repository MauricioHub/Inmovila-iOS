//
//  NotificationCell.swift
//  Vilanov
//
//  Created by andres on 3/16/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit

class NotificationCell: UITableViewCell {

    @IBOutlet weak var tituloLabel      : UILabel!
//    @IBOutlet weak var descripcionLabel : UILabel!
    @IBOutlet weak var tipoLabel        : UILabel!
    @IBOutlet weak var fechaLabel       : UILabel!
    @IBOutlet weak var optionsButton: UIButton!
    
    var notificationModel : NotificationModel? {
        didSet{
            if let notification = notificationModel {
                tituloLabel.text        = notification.titulo
//                descripcionLabel.text   = notification.descripcion
                tipoLabel.text          = notification.tipo
                fechaLabel.text         = notification.fecha
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func optionsAction(_ sender: UIButton) {
        if let parent = self.parentViewController as? NotificationListViewController {
            parent.itemSelected = self.notificationModel
            parent.del_cont_show()
        }
    }
}


class NotificationSearchCell: UITableViewCell {
    
    @IBOutlet weak var tituloLabel      : UILabel!
    @IBOutlet weak var descripcionLabel : UILabel!
    @IBOutlet weak var tipoLabel        : UILabel!
    @IBOutlet weak var fechaLabel       : UILabel!
    
    var notificationModel : NotificationModel? {
        didSet{
            if let notification = notificationModel {
                tituloLabel.text        = notification.titulo
                descripcionLabel.text   = notification.descripcion
                tipoLabel.text          = notification.tipo
                fechaLabel.text         = notification.fecha
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}


