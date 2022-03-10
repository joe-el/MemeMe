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
    
    // Life Cycle:
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView!.reloadData()
    }
    
    // UITableView Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.memes.count == 0 {
            return 1
        } else {
            return self.memes.count;
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: self.cellReuseIdentifier)!
        
        if self.memes.count == 0 {
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
        if self.memes.count != 0 {
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
            
            // I may need to assign an empty array or image if meme count is zero:
            detailController.serveMeme = self.memes[(indexPath as NSIndexPath).row]
            
            self.navigationController!.pushViewController(detailController, animated: true)
        }
    }
}
