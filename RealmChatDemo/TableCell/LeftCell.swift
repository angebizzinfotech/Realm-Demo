//
//  LeftCell.swift
//  RealmChatDemo
//
//  Created by EbitNHP-i1 on 17/08/2020.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

import UIKit
import RealmSwift

class LeftCell: UITableViewCell {

    let realm = try! Realm()
    
    @IBOutlet var parentView: UIView!
    @IBOutlet var lblText: UILabel!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var statusImg: UIImageView!
    @IBOutlet var startingImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        parentView.layer.cornerRadius = 7
        parentView.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(model:Messages){
        
        if !model.isInvalidated {
            lblText.text = model.messageBody
            lblTime.text = RealmManager.getCmtTime(time: model.time)
            
            if model.is_Read == "0" {
                if self.realm.isInWriteTransaction {
                    model.is_Read = "1"
                    realm.add(model, update: .all)
                }
                else {
                    try! self.realm.write {
                        model.is_Read = "1"
                        realm.add(model, update: .all)
                    }
                }
            }
        }
    }
}
