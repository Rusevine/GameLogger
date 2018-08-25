//
//  DataManager.swift
//  GameLogger
//
//  Created by Henry Cooper on 24/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    enum GameStatus: String {
        case wantToPlay = "wantToPlay"
        case havePlayed = "havePlayed"
    }

    private let userDefaults = UserDefaults.standard

    class func getImageFromData(_ data: Data) -> UIImage {
        guard let imageToReturn = UIImage(data: data) else { fatalError() }
        return imageToReturn
    }
    
     func addGame(_ game: Game, status: GameStatus) {
        switch status {
        case .havePlayed:
            addGameToPlayed(game)
        case .wantToPlay:
            addGameToWantToPlay(game)
        }
    }
    
    func fetchGamesWithStatus(_ status: GameStatus, completion: @escaping ([Game]?) -> ()) {
        switch status {
        case .havePlayed:
            let havePlayedIds = havePlayed()
            NetworkManager.getGameFromIds(havePlayedIds) { (returnedGames) in
                completion(returnedGames)
            }
        case .wantToPlay:
            let wantToPlayIds = wantToPlay()
            NetworkManager.getGameFromIds(wantToPlayIds) { (returnedGames) in
                completion(returnedGames)
            }
        }
    }
    
    func gameAlreadyLogged(_ game: Game) -> Bool {
        let gameId = game.gameId
        if isGamePlayed(gameId) || isGameWantToPlay(gameId) { return true }
        else { return false }
    }
    
    
    //Saving to UserDefaults
    
     private func wantToPlay() -> [Int] {
        guard let wantToPlayArray = userDefaults.array(forKey: GameStatus.wantToPlay.rawValue) else {
            let wantToPlay = [Int]()
            userDefaults.set(wantToPlay, forKey: GameStatus.wantToPlay.rawValue)
            userDefaults.synchronize()
            return wantToPlay
        }
        return wantToPlayArray as! [Int]
    }
    
     private func havePlayed() -> [Int] {
        guard let havePlayedArray = userDefaults.array(forKey: GameStatus.havePlayed.rawValue) else {
            let havePlayed = [Int]()
            userDefaults.set(havePlayed, forKey: GameStatus.havePlayed.rawValue)
            userDefaults.synchronize()
            return havePlayed
        }
        return havePlayedArray as! [Int]
    }
    
    private func isGamePlayed(_ id: Int) -> Bool {
        let havePlayedArray = havePlayed()
        guard havePlayedArray.count > 0 else { return false }
        for gameId in havePlayedArray {
            if id == gameId {
                return true
            }
        }
        return false
    }
    
    private func isGameWantToPlay(_ id: Int) -> Bool {
        let wantToPlayArray = wantToPlay()

        if isGamePlayed(id) || wantToPlayArray.count == 0  {
            return false
        }
        
        for gameId in wantToPlayArray {
            if id == gameId {
                return true
            }
        }
        return false
    }
    
    private func addGameToPlayed(_ game: Game) {
        var havePlayedArray = havePlayed()
        havePlayedArray.append(game.gameId)
        userDefaults.set(havePlayedArray, forKey: GameStatus.havePlayed.rawValue)
        userDefaults.synchronize()
    }
    
    private func addGameToWantToPlay(_ game: Game) {
        var wantToPlayArray = wantToPlay()
        wantToPlayArray.append(game.gameId)
        userDefaults.set(wantToPlayArray, forKey: GameStatus.wantToPlay.rawValue)
        userDefaults.synchronize()
    }
    
    
       
}
