//
//  MemeTableViewController.swift
//  ImagePickerExp
//
//  Created by Grigory Rudko on 8/30/16.
//  Copyright © 2016 Grigory Rudko. All rights reserved.
//

import Foundation
import UIKit

class MemeTableViewController: UICollectionViewController {
    
    var memes: [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
}
