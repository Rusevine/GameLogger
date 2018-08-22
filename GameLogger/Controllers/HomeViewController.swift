//
//  ViewController.swift
//  GameLogger
//
//  Created by Henry Cooper on 22/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - IBOutlets & IBActions

    @IBAction func searchButtonPressed(_ sender: Any) {
        guard let text = searchField.text else { return }
        NetworkManager.getDataFor(searchTerm: text) { (games) in
            self.searchGames = games
            OperationQueue.main.addOperation({
                self.performSegue(withIdentifier: "SearchSegue", sender: nil)
                self.searchField.text = ""
            })
        }
    }
    
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var popularGameButton: UIButton!
    
    // MARK: - Properties
    
    var searchGames = [Game]()
    var popularGames = [Game]()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        self.popularGameButton.alpha = 0
        getPopularGames()
    }
    
    
    // MARK: - Custom Methods
    
    func getPopularGames() {
        NetworkManager.getPopularGames { (returnedGames) in
            self.popularGames = returnedGames
            OperationQueue.main.addOperation({
                self.collectionView.reloadData()
            })
        }
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchSegue" {
            let vc = segue.destination as! SearchResultsViewController
            vc.games = searchGames
        }
    }

    
}

// MARK: - CollectionView Data Source

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularGames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PopularGameCell", for: indexPath) as! PopularGameCell
        cell.configureCellWith(popularGames[indexPath.row])
        return cell
    }
    
}

// MARK: - Collection View Layout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/4, height: collectionView.frame.size.height)
    }
}

// MARK: - Collection View Delegate

extension HomeViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        popularGameButton.alpha = 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        popularGameButton.setTitle(popularGames[indexPath.row].name!, for: .normal)
        UIView.animate(withDuration: 0.5) {
            self.popularGameButton.alpha = 1
        }
    }
}
