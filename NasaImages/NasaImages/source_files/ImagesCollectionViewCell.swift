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
        
        if let url = URL(string: image.getImagePath() ?? "") {
            previewImageView.load(url: url, placeholder: nil)
        }
        
    }

}
