//
//  MemeCollectionViewController.swift
//  ImagePickerExp
//
//  Created by Grigory Rudko on 8/30/16.
//  Copyright © 2016 Grigory Rudko. All rights reserved.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!

var memes: [Meme]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        memes = applicationDelegate.memes
    }


    
//    var memes: [Meme] {
//        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
//    }


}










