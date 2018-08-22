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
            
        }
    }
    
    @IBOutlet weak var searchField: UITextField!
    
    // MARK: - Properties
    
    
    
}

