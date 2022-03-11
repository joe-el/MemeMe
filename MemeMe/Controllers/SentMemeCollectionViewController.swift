//
//  MemeCollectionViewController.swift
//  MemeMe 2.0
//
//  Created by Kenneth Gutierrez on 3/4/22.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController {
    
    /*
     * The default UICollectionViewCell leaves a little to be desired in terms of meme display, so we are
     * going to need to write a custom cell. To do this, add a Cocoa Touch Class to my project and have it
     * inherit from UICollectionViewCell.
     */
    
    // Properties:
    let cellReuseIdentifier = "MemeCollectionViewCell"
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }
    
    // Outlets:
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let space:CGFloat = 3.0
        let dimension = (view.frame.size.width - (2 * space)) / 3.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    func memesToShow() -> Bool {
        if self.memes.count == 0 {
            return false
        } else {
            return true
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if memesToShow() {
            return self.memes.count
        } else {
            return 1
        }
    }
    
    // Should return a custom cell, I’ll dequeue an instance of my cell class and populate it with data.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! SentMemeCollectionViewCell
        
        if memesToShow() {
            let memeStruct = self.memes[(indexPath as NSIndexPath).row]
            // Set the memed image
            cell.memedCellImageView?.image = memeStruct.memedImage
            return cell
        }
        return cell
    }
    
    // Should present a detail view of the selected meme.
    // I’ll grab an instance of my detailViewController from the storyboard, populate the
    // detailViewController with the appropriate meme, and present it using navigation.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        if memesToShow() {
            // Grab the DetailVC from Storyboard
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

            //Populate view controller with data from the selected item
            detailController.serveMeme = memes[(indexPath as NSIndexPath).row]

            // Present the view controller using navigation
            navigationController!.pushViewController(detailController, animated: true)
        }
    }
}
