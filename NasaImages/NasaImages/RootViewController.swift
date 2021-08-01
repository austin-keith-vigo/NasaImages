//
//  RootViewController.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import UIKit

class RootViewController: UIViewController {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var imagesCollectionViewController: ImagesCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imagesCollectionViewController = ImagesCollectionViewController(collectionView: self.imagesCollectionView)
        RequestManager.getInstance().getImagesBySearchTermForPage(searchTerm: "hello", page: 1, completionHandler: { images, error in
            
            if let error = error {
                print(error)
                return
            }
            
            print(images.count)
            
        })
    }



}
