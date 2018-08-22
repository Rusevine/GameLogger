//
//  Game.swift
//  GameLogger
//
//  Created by Henry Cooper on 22/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

@objc class Game: NSObject {
    
    var name: String?
    var rating: Int?
    var releaseDate: Int?
    var averageTimeToBeat: Int?
    var artwork: UIImage?
    private var artworkURL: URL?
    
    init(dictionary: [String:Any]) {
        
        guard let name = dictionary["name"] as? String else {
            self.name = "Unnamed"
            return
        }
        
        guard let rating = dictionary["total_rating"] as? Int else {
            self.rating = 0
            return
        }
        
        guard let releaseDate = dictionary["first_release_date"] as? Int else {
            self.releaseDate = 0
            return
        }
        
        guard let timeToBeatDict = dictionary["time_to_beat"] as? [String:Int], let timeToBeat = timeToBeatDict["normally"] else {
            self.averageTimeToBeat = 0
            return
        }
        
        guard let artworkDict = dictionary["cover"] as? [String: String], let artworkURL = artworkDict["url"] else {
            self.artworkURL = nil
            return
        }
        
        self.name = name
        self.rating = rating
        self.releaseDate = releaseDate
        self.averageTimeToBeat = timeToBeat
        self.artworkURL = URL(string: artworkURL)
    }

}
