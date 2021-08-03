//
//  ImagesCollectionViewController.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import Foundation
import UIKit

class ImagesCollectionViewController: NSObject {
    
    let cellId = ImagesCollectionViewCell.cellId
    
    private var collectionView: UICollectionView?
    private var images: [Image] = []
    private var edgeInsets: UIEdgeInsets?
    
    
    // Callbacks
    var didRefresh: (() -> Void)?
    var didSelectImage: ((_ image: Image) -> Void)?
    var didScroll: (() -> Void)?
    var didScrollToBottom: (() -> Void)?
    
    
    // Initializes collection view
    init(collectionView: UICollectionView, edgeInsets: UIEdgeInsets?) {
        super.init()
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
        self.collectionView?.backgroundColor = .clear
        
        // Set layout of collectionView to minimize spacing
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (screenWidth / 3) - 2.0, height: screenWidth / 3)
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 2.0
        self.collectionView?.collectionViewLayout = layout
        self.collectionView?.contentInset = edgeInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView?.automaticallyAdjustsScrollIndicatorInsets = false
        self.edgeInsets = edgeInsets
    }
    
    
    // Re-gets first page of images based on search term
    func refresh() {
        self.didRefresh?()
    }
    
    
    // View-Model provides new list to present
    func setImages(newImages: [Image]) {
        self.images.removeAll()
        self.images = newImages
        self.collectionView?.reloadData()
        
        // Reset content offset
        self.collectionView?.contentOffset = CGPoint(x: 0.0,
                                                     y: -1 * (edgeInsets?.top ?? 0))
    }
    
    
    // Adds new list of images to current list
    func appendImages(newImages: [Image]) {
        
        // Calculate new rows
        var newIndexPaths: [IndexPath] = []
        for row in self.images.count...newImages.count - 1 {
            newIndexPaths.append(IndexPath(row: row, section: 0))
        }
        
        // Update data
        self.images.removeAll()
        self.images = newImages
        
        
        // Update collection view
        self.collectionView?.performBatchUpdates({
            self.collectionView?.insertItems(at: newIndexPaths)
        }, completion: nil)
    }
}


/*
 Delegate methods for collection view
 */
extension ImagesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ImagesCollectionViewCell
        let image = self.images[indexPath.row]
        cell.setInfo(image: image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let image = self.images[indexPath.row]
        self.didSelectImage?(image)
    }
    

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
        // Request next set of images when bottom is reached
        let height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if distanceFromBottom < height && self.images.count > 0 {
            self.didScrollToBottom?()
        }
    }
    
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // Notify View-Model of user scroll
        self.didScroll?()
    }
    
    
}
