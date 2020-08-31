//
//  RealmManager.swift
//  RealmChatDemo
//
//  Created by EbitNHP-IOS on 17/08/20.
//  Copyright © 2020 EbitNHP-i1. All rights reserved.
//

import Foundation
import  RealmSwift

class RealmManager: NSObject {
    
    // A Singleton instance
    static let sharedInstance = RealmManager()
    let realm = try! Realm()
    static let currentSchemaVersion: UInt64 = 2
    // Initialize
    private override init() {
        print("REALM PATH : \(Realm.Configuration.defaultConfiguration.fileURL!)")
        
    }
    
    static func configureMigration() {
        let config = Realm.Configuration(schemaVersion: currentSchemaVersion, migrationBlock: { (migration, oldSchemaVersion) in
             
        })
        Realm.Configuration.defaultConfiguration = config
    }
     
    // delete table
    func deleteDatabase() {
        try! realm.write({
            realm.deleteAll()
        })
    }
    
    // delete particular object
    func deleteObject(objs : Object) {
        try? realm.write ({
            realm.delete(objs)
    })
    }
    
     //Save array of objects to database
    func saveObjects(objs: Object) {
        try? realm.write ({
            // If update = false, adds the object
            realm.add(objs)
        })
    }
    
    // editing the object
    func editObjects(objs: Object) {
        try? realm.write ({
            // If update = true, objects that are already in the Realm will be
            // updated instead of added a new.
            realm.add(objs, update: .all)
        })
    }
    
     //Returs an array as Results<object>?
    func getObjects(type: Object.Type) -> Results<Object>? {
        return realm.objects(type)
    }
    
    func insertMessage(model:[Messages]) {
         
        if self.realm.isInWriteTransaction {
            self.realm.add(model)
        }
        else {
            try! self.realm.write {
                self.realm.add(model)
            }
        }
    }
}

extension RealmManager {
    
    static func getTimestampFromDate(date:Date) -> Int {
        let timeInterval = date.timeIntervalSince1970
        return Int(timeInterval)
    }
    
    static func getCmtTime(time:String) -> String {
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let a_date:Date = formatter.date(from: time) ?? Date()
        formatter.timeZone =  TimeZone.current
        formatter.dateFormat = "hh:mm a"
        
        return formatter .string(from: a_date)
    }
}
