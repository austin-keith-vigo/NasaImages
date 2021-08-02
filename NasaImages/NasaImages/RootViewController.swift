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
    
    var images: [Image] = [] // Current list that is being presented
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
        self.initNavigation()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Make initial api call for images
        self.getImages()
    }
    

    // Initialize views
    func initViews() {
        self.imagesCollectionViewController = ImagesCollectionViewController(collectionView: self.imagesCollectionView)
        self.imagesCollectionViewController?.didRefresh = {[weak self] in
            self?.getImages()
        }
        self.imagesCollectionViewController?.didSelectImage = {[weak self] image in
            self?.presentImageViewController(image: image)
        }
    }
    
    
    // Initialize navigation controller
    func initNavigation() {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    // Pushes ImageViewController onto navigation stack
    func presentImageViewController(image: Image) {
        let imageViewController = ImageViewController()
        imageViewController.image = image
        self.navigationController?.pushViewController(imageViewController, animated: true)
    }
    
    
    // Grabs images by page and updates view 
    func getImages() {
        RequestManager.getInstance().getImagesBySearchTermForPage(searchTerm: "", page: 1, completionHandler: { images, error in
            if let error = error {
                print("DEBUG AV: \(error)")
                return
            }
            
            // TODO: Implement pagination
            self.images.removeAll()
            self.images = images
            DispatchQueue.main.async {
                self.imagesCollectionViewController?.setImages(newImages: images)
            }
        })
    }
}
