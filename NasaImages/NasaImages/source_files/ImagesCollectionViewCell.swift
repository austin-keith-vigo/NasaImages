//
//  ImagesCollectionViewCell.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import UIKit

class ImagesCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "ImagesCollectionViewCell"
    
    // UI elements
    @IBOutlet weak var previewImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initViews()
    }
    
    func initViews() {
        self.previewImageView?.isUserInteractionEnabled = false
        self.previewImageView?.contentMode = .scaleAspectFill
    }
    
    /*
     Sets values for UIElements presenting data from image object assuming UIElements have been loaded
     */
    func setInfo(image: Image) {
        guard let previewImageView = self.previewImageView else { return }
        
        // Asynchronously load image from cache or make request to load image
        // TODO: Implement blur background to indicate image loading
        if let url = URL(string: image.getImagePath() ?? "") {
            ImageCache.load(url: url, completionHandler: { image in
                if let image = image {
                    DispatchQueue.main.async {
                        previewImageView.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        previewImageView.image = nil
                    }
                }
            })
        } else {
            previewImageView.image = nil
        }
        
    }

}
