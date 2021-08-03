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
        
        // Make initial api call for images and loads imags into cache
        self.getImages(searchTerm: "", page: 1)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Re-Adjust mask for collection view
    }
    

    // Initialize views
    func initViews() {
        
        // Calculate top padding of content
        var topPadding: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.windows.first { $0.isKeyWindow }
            topPadding = window?.safeAreaInsets.top ?? 0.0
        }
        
        let searchBarHeight = CGFloat(50.0)
        let topEdgeInset = searchBarHeight + topPadding
        let edgeInsets = UIEdgeInsets(top: topEdgeInset, left: 0.0, bottom: 0.0, right: 0.0)
        
        // Init Collection View
        self.imagesCollectionViewController = ImagesCollectionViewController(collectionView: self.imagesCollectionView,
                                                                             edgeInsets: edgeInsets)
        
        // Set Callbacks
        self.imagesCollectionViewController?.didRefresh = {[weak self] in
            self?.currentPage = 1
            self?.getImages(searchTerm: self?.searchBarController?.getText() ?? "", page: 1)
        }
        
        self.imagesCollectionViewController?.didSelectImage = {[weak self] image in
            self?.searchBarController?.endEditing(true)
            self?.presentImageViewController(image: image)
        }
        
        self.imagesCollectionViewController?.didScrollToBottom = {[weak self] in
            self?.getNextPage()
        }
        
        self.imagesCollectionViewController?.didScroll = {[weak self] in
            self?.searchBarController?.endEditing(true)
        }
        
        
        // Init Search Bar
        self.searchBarController = ImagesSearchBarController(searchBar: self.searchBar)
        self.searchBarController?.didPressSearch = {[weak self] searchTerm in
            self?.handleDidPressSearch(searchTerm: searchTerm)
        }
        
        self.view.backgroundColor = .black
    }
    
    /*
     Retrieves new list of images and clears cache to make room for next list of images
     */
    var previousSearchTerm: String = ""
    func handleDidPressSearch(searchTerm: String) {
        guard searchTerm != previousSearchTerm else { return }
        
        // Clean up cache of previous list to clear memory foot-print
        DispatchQueue.global(qos: .background).async {
            ImageCache.clear()
        }
        
        // Reset collection view back to the top with a new list
        self.currentPage = 1
        self.getImages(searchTerm: searchTerm, page: 1)
        self.previousSearchTerm = searchTerm
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

