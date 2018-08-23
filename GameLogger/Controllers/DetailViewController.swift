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
    var realm: Realm!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
 
  

  
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        realm = try! Realm()
    }
    
    // MARK: - Custom Methods
    
    func setViews() {
        playedButton.layer.cornerRadius = 10
        wantToPlayButton.layer.cornerRadius = 10
        if let game = game {
            gameNameLabel.text = game.name
            gameNameLabel.adjustsFontSizeToFitWidth = true
            let roundedRating = game.gameRating?.rounded()
            ratingLabel.text = "Rating: \(String(describing: roundedRating!))"
            descriptionLabel.text = "Description: \(String(describing: game.summary!))"
            
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
        let gameToSave = HavePlayedGame(withGame: game)
        try! realm.write {
            realm.add(gameToSave)
        }
        
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



