//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Kenneth Gutierrez on 3/8/22.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    
    // Properties:
    var serveMeme: Meme!
    
    // Outlets:
    @IBOutlet weak var memedImageView: UIImageView!
    
    // Life Cycle:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        self.memedImageView!.image = serveMeme.memedImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
