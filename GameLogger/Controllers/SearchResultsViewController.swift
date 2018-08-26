//
//  SearchResultsViewController.swift
//  GameLogger
//
//  Created by Henry Cooper on 22/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Properties
    
    var games: [Game]?
    var searchInput: String?

    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let games = games else { return }
        if segue.identifier == "CellSelectedSegue" {
            let tableViewCell = sender as! UITableViewCell
            let vc = segue.destination as! DetailViewController
            guard let indexPath = tableView.indexPath(for: tableViewCell) else { return }
            vc.game = games[indexPath.row]
        }
    }
    override func viewDidLoad() {
        tableView.sectionHeaderHeight = view.frame.size.height / 20
    }

}

// MARK: - Table Data Source

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let games = games else { return 0 }
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchResultCell") as! ResultCell
        if let games = games {
            cell.configureCellWith(games[indexPath.row])
        }
        return cell
    }
}

// MARK: - Table View Delegate

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Search results for \"\(searchInput ?? "Nothing")\""
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: (50/255), green: (50/255), blue: (50/255), alpha: 1.0)
        
        let headerLabel = UILabel(frame: CGRect(x: 10, y: 5, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        headerLabel.font = UIFont(name: "Bangers", size: 20)
        headerLabel.textColor = UIColor.white
        headerLabel.text = self.tableView(self.tableView,titleForHeaderInSection: section)
        headerLabel.sizeToFit()
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
}
