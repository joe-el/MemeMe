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
    var noMemesToShow: Bool!
    
    // Outlets:
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        noMemesToShow = memes.isEmpty
        collectionView!.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            let space:CGFloat = 3.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0
            // load slim view
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        } else {
            // load wide view
            let space:CGFloat = 1.0
            let dimension = (view.frame.size.width - (2 * space)) / 3.0
            flowLayout.minimumInteritemSpacing = space
            flowLayout.minimumLineSpacing = space
            flowLayout.itemSize = CGSize(width: dimension, height: dimension)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if noMemesToShow {
            return 1
        } else {
            return self.memes.count
        }
    }
    
    // Should return a custom cell, I’ll dequeue an instance of my cell class and populate it with data.
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellReuseIdentifier, for: indexPath) as! SentMemeCollectionViewCell
        
        if noMemesToShow {
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: collectionView.frame.width, height: collectionView.frame.height))
            label.numberOfLines = 2
            label.textAlignment = .center
            label.text = "Click on '+' to Add a Meme"
            collectionView.backgroundView = label
            return cell
        } else {
            collectionView.backgroundView = nil
            let memeStruct = self.memes[(indexPath as NSIndexPath).row]
            // Set the memed image
            cell.memedCellImageView?.image = memeStruct.memedImage
            return cell
        }

    }
    
    // Should present a detail view of the selected meme.
    // I’ll grab an instance of my detailViewController from the storyboard, populate the
    // detailViewController with the appropriate meme, and present it using navigation.
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath:IndexPath) {
        if !noMemesToShow {
            // Grab the DetailVC from Storyboard
            let detailController = self.storyboard!.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController

            //Populate view controller with data from the selected item
            detailController.serveMeme = memes[(indexPath as NSIndexPath).row]

            // Present the view controller using navigation
            navigationController!.pushViewController(detailController, animated: true)
        }
    }
}
