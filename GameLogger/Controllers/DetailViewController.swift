//
//  DetailViewController.swift
//  GameLogger
//
//  Created by Wiljay Flores on 2018-08-22.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
  
  
  @IBOutlet weak var gameNameLabel: UILabel!
  
  @IBOutlet weak var imageCollectionView: UICollectionView!
  
  @IBOutlet weak var playedButton: UIButton!
  
  @IBOutlet weak var wantToPlayButton: UIButton!
  
  let images = [UIImage(named: "Z1"),UIImage(named: "Z2"),UIImage(named: "Z3")]
  
  
  

    override func viewDidLoad() {
        super.viewDidLoad()
      imageCollectionView.dataSource=self
      imageCollectionView.delegate=self
      playedButton.layer.cornerRadius = 10
      wantToPlayButton.layer.cornerRadius = 10

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "detailViewCell", for: indexPath) as! DetailCollectionViewCell
    
    cell.configure(with: images[indexPath.row])
    
    return cell
  }
}
