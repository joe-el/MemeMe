//
//  MemeTableViewController.swift
//  MemeMe 2.0
//
//  Created by Kenneth Gutierrez on 3/4/22.
//

import Foundation
import UIKit

class SentMemeTableViewController: UITableViewController {
    
    // Properties:
    let cellReuseIdentifier = "MemeTableViewCell"
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    var noMemesToShow: Bool!
    
    // Life Cycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noMemesToShow = memes.isEmpty
        tableView!.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
    }
    
    // UITableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if noMemesToShow {
            return 1
        } else {
            return self.memes.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)!
        
        if noMemesToShow {
            cell.textLabel?.text = "Click on '+' to Add a Meme"
        } else {
            let memeStruct = self.memes[(indexPath as NSIndexPath).row]
            // Set the lables and image
            cell.imageView?.image = memeStruct.memedImage
            //UIImage(named: memeStruct.memedImage)
            cell.textLabel?.text = "\(memeStruct.topText)...\(memeStruct.bottomText)"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !noMemesToShow {
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
            
            detailController.serveMeme = self.memes[(indexPath as NSIndexPath).row]
            
            self.navigationController!.pushViewController(detailController, animated: true)
        }
    }
}
