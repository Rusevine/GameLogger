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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CellSelectedSegue" {
            let tableViewCell = sender as! UITableViewCell
            let vc = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPath(for: tableViewCell) else { return }
            switch indexPath.section {
                case 0:
                    vc.game = havePlayedGames[indexPath.row]
                case 1:
                    vc.game = wantToPlayGames[indexPath.row]
                default:
                    print("Invalid")
            }
        }
    }
    override func viewDidLoad() {
        tableView.sectionHeaderHeight = view.frame.size.height / 16
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
            cell.configureCellWith(havePlayedGames[indexPath.row])
        case 1:
            cell.configureCellWith(wantToPlayGames[indexPath.row])
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: (50/255), green: (50/255), blue: (50/255), alpha: 1.0)
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Bangers", size: 30)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.tableView(self.tableView,titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
   func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "REMOVE") { (action, view, handler) in
   
            switch indexPath.section {
                case 0:
                    self.havePlayedGames.remove(at: indexPath.row)
                case 1:
                    self.wantToPlayGames.remove(at: indexPath.row)
                default:
                    print("Invalid")
            }
            
            tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.left)
            tableView.reloadData()
    
            // [self.todos removeObjectAtIndex:indexPath.row];
        }
        deleteAction.backgroundColor = UIColor(red: (175/255), green: (11/255), blue: (32/255), alpha: 1.0)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    
    }
}

