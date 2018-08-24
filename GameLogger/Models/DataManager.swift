//
//  DataManager.swift
//  GameLogger
//
//  Created by Henry Cooper on 24/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit
import RealmSwift

class DataManager: NSObject {

    class func getImageFromData(_ data: Data) -> UIImage {
        guard let imageToReturn = UIImage(data: data) else { fatalError() }
        return imageToReturn
    }
    
    class func addGame(_ game: Game, completion: (Bool, NSError?)->()) {
        let realm = try! Realm()
        let results = realm.objects(GameToSave.self)
        
        for result in results {
            if game.name == result.name {
                let message = "You have already added this game"
                let error = NSError(domain: "", code: 200, userInfo: ["message" : message])
                completion(false, error)
                return
            }
        }
        
        let gameToSave = GameToSave(withGame: game)
        gameToSave.havePlayed = true
        try! realm.write {
            realm.add(gameToSave)
        }
        completion(true, nil)
    }
    
}
