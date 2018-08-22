//
//  PopularGameCell.swift
//  GameLogger
//
//  Created by Henry Cooper on 22/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class PopularGameCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Custom Methods
    
    func configureCellWith(_ game: Game) {
        game.getArtwork { (image) in
            OperationQueue.main.addOperation({
                self.imageView.image = image
            })
        }
    }
}
