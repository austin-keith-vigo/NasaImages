//
//  ImagesCollectionViewController.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import Foundation
import UIKit

class ImagesCollectionViewController: NSObject {
    
    private var collectionView: UICollectionView?
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.backgroundColor = .blue
    }
}
