//
//  GameListViewController.swift
//  GameLogger
//
//  Created by Wiljay Flores on 2018-08-22.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit
import RealmSwift

class GamesHavePlayedViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notificationToken: NotificationToken? = nil
    var realm: Realm!
    var results: Results<HavePlayedGame>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         realm = try! Realm()
         results = realm.objects(HavePlayedGame.self)
        
        notificationToken = results?.observe({ (changes: RealmCollectionChange) in
            self.tableView.reloadData()
        })
    }
}

// MARK: - Table View Data Source

extension GamesHavePlayedViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let results = results {
            return results.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameListCell") as! GameListCell
        cell.title.text = results?[indexPath.row].name
        return cell
    }
}

// MARK: - Table View Delegate

extension GamesHavePlayedViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 6
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Played Games"
    }
}
