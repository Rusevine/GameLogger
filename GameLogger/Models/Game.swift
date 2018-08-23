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
    //var screenshots: [UIImage?]
    private var artworkURL: URL?
    private var screenshotsURL: [URL?] = [URL]()
    
    init(withDictionary dictionary: [String:Any]) {
      
       // self.screenshotsURL = [URL]()
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let releaseDate = dictionary["first_release_date"] as? Int {
            self.releaseDate = releaseDate
        }
        
        if let artworkDict = dictionary["cover"] as? [String: Any], let artworkString = artworkDict["url"] as? String  {
            print(artworkString)
            self.artworkURL = URL(string: artworkString)
        }
      if let screenshotsArr : [[String:Any]] = dictionary["screenshots"] as? [[String: Any]]
      {
        for screenshot in screenshotsArr{
          self.screenshotsURL.append(URL(string: screenshot["url"] as! String))
        }
  
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
