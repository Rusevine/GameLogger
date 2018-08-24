//
//  SavedGame.swift
//  GameLogger
//
//  Created by Henry Cooper on 23/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit
import RealmSwift

class GameToSave: Object {

    @objc dynamic var name: String = ""
    @objc dynamic var imageData: Data = Data()
    @objc dynamic var havePlayed: Bool = false
    @objc dynamic var wantToPlay: Bool = false
    
    convenience init(withGame game: Game) {
        self.init()
        guard let name = game.name else { return }
        self.name = name
        guard let artwork = game.artwork else { fatalError() }
        guard let jpegRepresentation = UIImageJPEGRepresentation(artwork, 1) else { return }
        let data = Data(jpegRepresentation)
        self.imageData = data
    }
    
    
}
