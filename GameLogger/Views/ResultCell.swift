//
//  ResultCell.swift
//  GameLogger
//
//  Created by Henry Cooper on 22/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class ResultCell: UITableViewCell {

    @IBOutlet weak private var gameLabel: UILabel!
    
    @IBOutlet weak private var gameImageView: UIImageView!
    
    func configureCellWith(_ game: Game) {
        if let name = game.name {
            gameLabel.text = name
        }
        game.getArtwork { (image) in
            OperationQueue.main.addOperation({
                self.gameImageView.image = image
            })
        }
    }
    
    
}
