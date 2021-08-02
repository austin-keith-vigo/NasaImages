//
//  RootViewController.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import UIKit

class RootViewController: UIViewController {
    
    // Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var imagesCollectionViewController: ImagesCollectionViewController?
    
    var images: [Image] = [] // Current list that is being presented
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
        self.initNavigation()
        
        // Make initial api call for images
        self.getImages(searchTerm: "")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    

    // Initialize views
    func initViews() {
        self.imagesCollectionViewController = ImagesCollectionViewController(collectionView: self.imagesCollectionView)
        self.imagesCollectionViewController?.didRefresh = {[weak self] in
            self?.getImages(searchTerm: self?.searchBar.text ?? "")
        }
        self.imagesCollectionViewController?.didSelectImage = {[weak self] image in
            self?.presentImageViewController(image: image)
        }
        
        // Init Search Bar
        self.searchBar.delegate = self
        self.searchBar.searchTextField.font = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.searchBar.searchTextField.textColor = .red
        self.searchBar.backgroundColor = .clear
        self.searchBar.searchTextField.backgroundColor = .blue
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
    func getImages(searchTerm: String) {
        RequestManager.getInstance().getImagesBySearchTermForPage(searchTerm: searchTerm, page: 1, completionHandler: { images, error in
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

/*
 Search Bar Delegate methods
 */
extension RootViewController: UISearchBarDelegate {

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.searchBar.endEditing(true)
            self.getImages(searchTerm: text)
        }
    }
}
