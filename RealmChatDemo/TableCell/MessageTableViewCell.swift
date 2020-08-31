//
//  MessageTableViewCell.swift
//  RealmChatDemo
//
//  Created by EbitNHP-IOS on 17/08/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet weak var imgUser1: UIImageView!
    @IBOutlet weak var imgUser2: UIImageView!
    @IBOutlet weak var lblMesssageBody: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblMesssageBody.layer.cornerRadius = 5
        lblMesssageBody.layer.borderWidth = 1
        lblMesssageBody.layer.borderColor = UIColor.darkGray.cgColor
        lblMesssageBody.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
