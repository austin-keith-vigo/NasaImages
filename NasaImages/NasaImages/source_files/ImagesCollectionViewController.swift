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
    
    
    // Callbacks
    var didRefresh: (() -> Void)?
    var didSelectImage: ((_ image: Image) -> Void)?
    
    
    // Initializes collection view
    init(collectionView: UICollectionView) {
        super.init()
        self.collectionView = collectionView
        self.collectionView?.delegate = self
        self.collectionView?.dataSource = self
        self.collectionView?.register(UINib.init(nibName: cellId, bundle: nil), forCellWithReuseIdentifier: cellId)
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
        self.collectionView?.contentOffset = .zero
    }
}

/*
 Delegate methods for collection view
 */
extension ImagesCollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    
}
