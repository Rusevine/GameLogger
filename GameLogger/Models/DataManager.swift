//
//  DataManager.swift
//  GameLogger
//
//  Created by Henry Cooper on 23/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit
import RealmSwift

class DataManager: NSObject {

    
    class func alertForChangesFrom(_ object: Object.Type, completion: @escaping () -> Void) {
        var realm: Realm!
        var notificationToken = NotificationToken()
        
        realm = try! Realm()
        let results = realm.objects(object.self)
        
        notificationToken = results.observe({ _ in
            completion()
        })
        
        
    }
    
}
