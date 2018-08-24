//
//  GameListViewController.swift
//  GameLogger
//
//  Created by Wiljay Flores on 2018-08-22.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit
import RealmSwift

class SavedGamesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var notificationToken: NotificationToken? = nil
    var realm: Realm!
    var results: Results<GameToSave>?
    var havePlayed: [GameToSave] = []
    var wantToPlay: [GameToSave] = []
    
    override func viewWillAppear(_ animated: Bool) {
        realm = try! Realm()
        results = realm.objects(GameToSave.self)
        
        notificationToken = results?.observe({ _ in
            guard let results = self.results else { return }
            self.havePlayed.removeAll()
            self.wantToPlay.removeAll()
            for result in results {
                print(result.name)
                if result.havePlayed == true {
                    self.havePlayed.append(result)
                } else if result.wantToPlay == true {
                    self.wantToPlay.append(result)
                }
            }
            self.tableView.reloadData()
        })
    }
}

// MARK: - Table View Data Source

extension SavedGamesViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        if !havePlayed.isEmpty { count+=1 }
        if !wantToPlay.isEmpty { count+=1 }
        return count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return havePlayed.count
        case 1:
            return wantToPlay.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameListCell") as! GameListCell
        let currentSection = indexPath.section
        let currentRow = indexPath.row
        
        var imageData = Data()
        
        switch currentSection {
        case 0:
            cell.title.text = havePlayed[currentRow].name
            imageData = havePlayed[currentRow].imageData
        case 1:
            cell.title.text = wantToPlay[currentRow].name
            imageData = havePlayed[currentRow].imageData
        default:
            cell.title.text = "No Game!"
        }
        
        cell.artwork.image = DataManager.getImageFromData(imageData)
        
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
