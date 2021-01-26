//
//  NoticeCell.swift
//  Vilanov
//
//  Created by andres on 2/25/19.
//  Copyright © 2019 Inmovila. All rights reserved.
//

import UIKit
import PINRemoteImage
import SDWebImage

class NoticeCell: UITableViewCell {

    @IBOutlet weak var bannerImageView  : UIImageView!
    @IBOutlet weak var tituloLabel      : UILabel!
    @IBOutlet weak var progressBar      : UIProgressView!
    @IBOutlet weak var fechaLabel       : UILabel!
    
    var stringPhrase        : String!
    var stringProgress      : String!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    var notice : NoticeModel? {
        didSet {
            if let notice = notice {
                let hide = (notice.tipo != "avance" ? true : false)
                self.progressBar.isHidden = hide
                self.setProgress(hide)
                self.tituloLabel.text = notice.titulo
                self.fechaLabel.text = notice.fecha.replacingOccurrences(of: "-", with: "/")
                self.setImageWith(notice.previewapp)
            }
        }
    }
    
    func setImageWith(_ name: String) {
        let urlString = EndPointConst.imagesUrl + name
        let url = URL(string: urlString)
        
        self.bannerImageView.sd_setImage(with: url, completed: {
            (placeHolder, error, imgCacheType, url) in
            print("im_placeholder_house")
        })
    }
    
    func setProgress(_ isHidden: Bool) {
        if isHidden { return }
        let text = notice!.titulo.trimmingCharacters(in: .whitespacesAndNewlines)
        let words = text.components(separatedBy: " ")
        let stringValue = String(words.last ?? "")
        self.stringPhrase = words.prefix(words.count - 1).joined(separator: " ")
        let value = stringValue.replacingOccurrences(of: "%", with: "")
        self.stringProgress = value
        guard let FloatValue = Float(value) else { return }
        self.progressBar.progress = (FloatValue/100)
    }
    
}
