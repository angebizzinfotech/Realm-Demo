//
//  Messages.swift
//  RealmChatDemo
//
//  Created by EbitNHP-IOS on 17/08/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

import UIKit
import RealmSwift

class Messages: Object {
    
    @objc dynamic var id = Int()
    @objc dynamic var messageBody = ""
    @objc dynamic var time = ""
    @objc dynamic var is_Read:String = "0"
    @objc dynamic var sender_id = Int()
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
    //Incrementa ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(Messages.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        }else{
            return 1
        }
    }
}
