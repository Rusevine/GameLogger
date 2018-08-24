//
//  DataManager.swift
//  GameLogger
//
//  Created by Henry Cooper on 24/08/2018.
//  Copyright © 2018 Henry Cooper. All rights reserved.
//

import UIKit

class DataManager: NSObject {

    class func getImageFromData(_ data: Data) -> UIImage {
        guard let imageToReturn = UIImage(data: data) else { fatalError() }
        return imageToReturn
    }
    
}
