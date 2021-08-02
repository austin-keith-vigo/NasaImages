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
    var searchBarController: ImagesSearchBarController?
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    var imagesCollectionViewController: ImagesCollectionViewController?
    
    
    var images: [Image] = [] // Current list that is being presented
    var currentPage: Int = 1
    var isRequestingNewImages: Bool = false // Tracks if a request is being waited on
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
        self.initNavigation()
        
        // Make initial api call for images
        self.getImages(searchTerm: "", page: 1)
    }
    

    // Initialize views
    func initViews() {
        
        // Init Collection View
        self.imagesCollectionViewController = ImagesCollectionViewController(collectionView: self.imagesCollectionView)
        self.imagesCollectionViewController?.didRefresh = {[weak self] in
            self?.currentPage = 1
            self?.getImages(searchTerm: self?.searchBarController?.getText() ?? "", page: 1)
        }
        
        self.imagesCollectionViewController?.didSelectImage = {[weak self] image in
            self?.presentImageViewController(image: image)
        }
        
        self.imagesCollectionViewController?.didScrollToBottom = {[weak self] in
            self?.getNextPage()
        }
        
        // Init Search Bar
        self.searchBarController = ImagesSearchBarController(searchBar: self.searchBar)
        self.searchBarController?.didPressSearch = {[weak self] searchTerm in
            self?.currentPage = 1
            self?.getImages(searchTerm: searchTerm, page: 1)
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
    func getImages(searchTerm: String, page: Int) {
        guard self.isRequestingNewImages == false else { return } // Disallow multiple requests
        
        self.isRequestingNewImages = true
        RequestManager.getInstance().getImagesBySearchTermForPage(searchTerm: searchTerm, page: page, completionHandler: { images, error in
            if let error = error {
                print("DEBUG AV: \(error)")
                self.isRequestingNewImages = false
                return
            }
            
            
            if page == 1 {
                
                self.images.removeAll()
                self.images = images
                DispatchQueue.main.async {
                    self.imagesCollectionViewController?.setImages(newImages: images)
                    self.isRequestingNewImages = false
                }
                
            } else {
                
                self.images.append(contentsOf: images)
                DispatchQueue.main.async {
                    self.imagesCollectionViewController?.appendImages(newImages: self.images)
                    self.isRequestingNewImages = false
                }
                
            }
            
        })
    }
    
    // Makes request for next set of images
    func getNextPage() {
        guard self.isRequestingNewImages == false else { return }
        self.currentPage += 1
        self.getImages(searchTerm: self.searchBarController?.getText() ?? "", page: self.currentPage)
    }
}

