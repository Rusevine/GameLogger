//
//  DetailViewController.swift
//  GameLogger
//
//  Created by Wiljay Flores on 2018-08-22.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit
import RealmSwift

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
  
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var playedButton: UIButton!
    @IBOutlet weak var wantToPlayButton: UIButton!

  
    var game : Game?
//    var realm: Realm!
//    var results: Results<GameToSave>?
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
 
  

  
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
//        realm = try! Realm()
    }
    
    // MARK: - Custom Methods
    
    func setViews() {
        playedButton.layer.cornerRadius = 10
        wantToPlayButton.layer.cornerRadius = 10
        if let game = game {
            gameNameLabel.text = game.name
            gameNameLabel.adjustsFontSizeToFitWidth = true
        }
        getGameScreenshots()
    }
    
    func getGameScreenshots() {
        if let game = game {
            DispatchQueue.global(qos: .background).async {
                NetworkManager.getScreenshots(game: game)
                DispatchQueue.main.async {
                    self.imageCollectionView.reloadData()
                }
            }
        }
    }
    
    @IBAction func havePlayedPushed(_ sender: Any) {
        guard let game = game else { fatalError() }
        DataManager.addGame(game) { (success, error) in
            if let error = error {
                self.presentAlertWithMessage(error)
            }
        }
    }
    
    @IBAction func wantToPlayPushed(_ sender: Any) {
//        guard let game = game else { fatalError() }
//
//        if let results = results {
//            for result in results {
//                if game.name == result.name {
//
//                    let message: String!
//                    let controller: UIAlertController!
//                    let okay = UIAlertAction(title: "OK", style: .default, handler: nil)
//
//                    if result.wantToPlay {
//                        message = "You have already selected this game"
//                    } else {
//                        message = "You have selected this as a game you have played. Selection impossible!"
//                    }
//
//                    controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//                    controller.addAction(okay)
//                    present(controller, animated: true, completion: nil)
//                    return
//                }
//            }
//        }
//
//        let gameToSave = GameToSave(withGame: game)
//        gameToSave.wantToPlay = true
//        try! realm.write {
//            realm.add(gameToSave)
//        }
    }

    
}

// MARK: - Collection View Data Source

extension DetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let screenshots = game?.screenshots else { return 0 }
        return screenshots.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailViewCell", for: indexPath) as! DetailCollectionViewCell
        if let screenshots = game?.screenshots {
           cell.imageView.image = screenshots[indexPath.row]
        }
        return cell
    }
}

extension UIViewController {
    func presentAlertWithMessage(_ error: NSError) {
        let message = error.userInfo["message"] as? String ?? "No error message"
        let controller = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}



