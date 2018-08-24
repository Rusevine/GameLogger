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
    

}
    

// MARK: - Table View Data Source


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
