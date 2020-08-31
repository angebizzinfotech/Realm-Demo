//
//  Users.swift
//  RealmChatDemo
//
//  Created by EbitNHP-IOS on 17/08/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

import UIKit
import RealmSwift

class Users: Object {
    @objc dynamic var id = Int()
    @objc dynamic var name = ""
    @objc dynamic var lastMessage = ""
    @objc dynamic var unreadCount = 0
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //Increment ID
    func IncrementaID() -> Int{
        let realm = try! Realm()
        if let retNext = realm.objects(Users.self).sorted(byKeyPath: "id").last?.id {
            return retNext + 1
        }else{
            return 1
        }
    }
}
