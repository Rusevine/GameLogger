//
//  DetailViewController.swift
//  GameLogger
//
//  Created by Wiljay Flores on 2018-08-22.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - IBOutlets
  
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var playedButton: UIButton!
    @IBOutlet weak var wantToPlayButton: UIButton!

  
    var game : Game?
    private let manager =  DataManager()
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
 
  

  
    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        checkGameStatus()
    }
    
    // MARK: - Custom Methods
    
    private func setViews() {
        playedButton.layer.cornerRadius = 10
        wantToPlayButton.layer.cornerRadius = 10
        
        if let game = game {
            gameNameLabel.text = game.name
            gameNameLabel.adjustsFontSizeToFitWidth = true
        }
        getGameScreenshots()
    }
    
    private func disableButtons() {
        wantToPlayButton.isEnabled = false
        playedButton.isEnabled = false
        wantToPlayButton.setTitleColor(UIColor.darkGray, for: .disabled)
        playedButton.setTitleColor(UIColor.darkGray, for: .disabled)
        wantToPlayButton.alpha = 0.5
        playedButton.alpha = 0.5
    }
    
    private func getGameScreenshots() {
        if let game = game {
            DispatchQueue.global(qos: .background).async {
                NetworkManager.getScreenshots(game: game, completion: {
                    OperationQueue.main.addOperation {
                        self.imageCollectionView.reloadData()
                    }
                })

            }
        }
    }
    
    private func checkGameStatus() {
        guard let game = game else { return }
        if manager.gameAlreadyLogged(game) {
            disableButtons()
        }
    }
    
     @IBAction private func havePlayedPushed(_ sender: Any) {
        guard let game = game else { fatalError() }
        manager.addGame(game, status: .havePlayed)
        checkGameStatus()
    }
    
    @IBAction private func wantToPlayPushed(_ sender: Any) {
        guard let game = game else { fatalError() }
        manager.addGame(game, status: .wantToPlay)
        checkGameStatus()
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
        } else {
            print("currently no screenshots")
        }
        return cell
    }
}



