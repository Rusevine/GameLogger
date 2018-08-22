//
//  NetworkManager.swift
//  GameLogger
//
//  Created by Henry Cooper on 22/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    // MARK: - Method for preset collection view
        // MARK: - Method for searching
    
    class func getDataFor(searchTerm: String, completion: @escaping ([Game]) -> ()) {
        
        var games: [Game] = []
        
        let urlString = "https://api-endpoint.igdb.com/games/?search=\(searchTerm)&fields=name,first_release_date,cover"
        
        guard let percentEncodingString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        guard let gameURL = URL(string: percentEncodingString) else { return }
        
        var gameRequest = URLRequest(url: gameURL)
        gameRequest.setValue("3855e34ce36dcb0a762eda82cac2f050", forHTTPHeaderField: "user-key")
        gameRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: gameRequest) { (data, response, error) in
            
            if error != nil {
                print("Data task error: \(error!.localizedDescription)")
            }
            
            guard let responseData = data else {
                print("Error getting response data")
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: responseData),
                let mainArray = json as? [[String:Any]] else {
                print("Error serialising JSON")
                return
            }
            
            for dict in mainArray {
                let newGame = Game(withDictionary: dict)
                games.append(newGame)
            }
            
            completion(games)
                    
        }
        task.resume()
        
    }
    
    // MARK: - Method for downloading image
    
    class func downloadImageFrom(_ url: URL, completion: @escaping (UIImage) -> ()) {
        let task = URLSession.shared.downloadTask(with: url) { (url, urlResponse, error) in
            
            if error != nil {
                print("Error downloading from URL")
                return
            }
            
            guard let url = url else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            guard let imageToReturn = UIImage(data: data) else { return }
            
            completion(imageToReturn)
        }
        task.resume()
    }
    

}
