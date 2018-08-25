//
//  GameListViewController.swift
//  GameLogger
//
//  Created by Wiljay Flores on 2018-08-22.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class SavedGamesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    let manager = DataManager()
    var havePlayedGames = [Game]()
    var wantToPlayGames =  [Game]()
    
    override func viewWillAppear(_ animated: Bool) {
        manager.fetchGamesWithStatus(.havePlayed) { (returnedGames) in
            guard let returnedGames = returnedGames else { return }
            self.havePlayedGames = returnedGames.sorted(by: { $0.gameId > $1.gameId })
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
        manager.fetchGamesWithStatus(.wantToPlay) { (returnedGames) in
            guard let returnedGames = returnedGames else { return }
            self.wantToPlayGames = returnedGames.sorted(by: { $0.gameId > $1.gameId })
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
        }
    }

}
    

// MARK: - Table View Data Source

extension SavedGamesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0: return havePlayedGames.count
        case 1: return wantToPlayGames.count
        default: return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if havePlayedGames.count > 0 { count += 1}
        if wantToPlayGames.count > 0 { count += 1 }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameListCell") as! GameListCell
        switch indexPath.section {
        case 0:
            cell.title.text = havePlayedGames[indexPath.row].name
        case 1:
            cell.title.text = wantToPlayGames[indexPath.row].name
        default:
            cell.title.text = "No name"
        }
        return cell
    }
}


// MARK: - Table View Delegate

extension SavedGamesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Have Played"
        default:
            return "Want To Play"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
