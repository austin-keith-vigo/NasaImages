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
    
    override func prepareForReuse() {
        
        // Remove previous image
        if let previewImageView = self.previewImageView {
            previewImageView.image = nil
        }
    }
    
    func initViews() {
        self.previewImageView?.isUserInteractionEnabled = false
        self.previewImageView?.contentMode = .scaleAspectFill
    }
    
    /*
     Sets values for UIElements presenting data from image object assuming UIElements have been loaded
     */
    var currentSequence: Int = 0
    func setInfo(image: Image) {
        guard let previewImageView = self.previewImageView else { return }
        
        // Makes sure the previous request on the reused cell does not appear before the current request
        self.currentSequence += 1
        let sequence = self.currentSequence
        
        // Asynchronously load image from cache or make request to load image
        // TODO: Implement blur background to indicate image loading
        if let url = URL(string: image.getImagePath() ?? "") {
            ImageCache.load(url: url, completionHandler: { image in
                if let image = image, sequence == self.currentSequence {
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
