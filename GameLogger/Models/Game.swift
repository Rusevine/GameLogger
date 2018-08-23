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
    var releaseDate: Int?
    var artwork: UIImage?
    var screenshots: [UIImage]?
    var screenshotsURLs: [URL]?
    private var artworkURL: URL?
  
    
    init(withDictionary dictionary: [String:Any]) {
      
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let releaseDate = dictionary["first_release_date"] as? Int {
            self.releaseDate = releaseDate
        }
        
        if let artworkDict = dictionary["cover"] as? [String: Any], let artworkString = artworkDict["url"] as? String  {
            self.artworkURL = URL(string: artworkString)
        }
      
        if let screenshotsArr : [[String:Any]] = dictionary["screenshots"] as? [[String: Any]] {
            var tempScreenshotURLs = [URL]()
            screenshots = []
            for screenshot in screenshotsArr {
                let suffix = screenshot["url"] as! String
                let screenshotUrl = "https:\(suffix)"
                if let url = URL(string: screenshotUrl) {
                    tempScreenshotURLs.append(url)
                }
            }
            screenshotsURLs = tempScreenshotURLs
        }
        super.init()
    }
    
    func getArtwork(onLoad: @escaping ((UIImage) -> Void)) {
        
        if let artwork = artwork {
          onLoad(artwork)
        } else {
            guard let artworkURL = artworkURL else {
                artwork = #imageLiteral(resourceName: "noimage")
                onLoad(artwork!)
                return
            }
            NetworkManager.downloadImageFrom(artworkURL) { (image) in
                self.artwork = image
                onLoad(image)
            }
        }
    }
}


