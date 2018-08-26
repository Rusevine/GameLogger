//
//  HavePlayedCell.swift
//  GameLogger
//
//  Created by Henry Cooper on 23/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class GameListCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var artwork: UIImageView!

    func configureCellWith(_ game: Game) {
        if let name = game.name {
            title.text = name
        }
        game.getArtwork { (image) in
            OperationQueue.main.addOperation({
                self.artwork.image = image
            })
        }
    }
}
