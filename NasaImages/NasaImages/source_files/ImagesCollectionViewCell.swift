//
//  ImagesCollectionViewCell.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import UIKit
import SDWebImage

class ImagesCollectionViewCell: UICollectionViewCell {
    
    static let cellId = "ImagesCollectionViewCell"
    
    // UI elements
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var blurBackgroundImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.initViews()
    }
    
    override func prepareForReuse() {
    
    }
    
    func initViews() {
        self.previewImageView?.isUserInteractionEnabled = false
        self.previewImageView?.contentMode = .scaleAspectFill
        
        // Init blur background
        let backgroundImage = UIImage(named: "image-scale-sample-imgscalr.jpeg")
        blurBackgroundImageView.image = backgroundImage
        blurBackgroundImageView.contentMode = .scaleAspectFill
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = blurBackgroundImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurBackgroundImageView.addSubview(blurEffectView)
    }
    
    /*
     Sets values for UIElements presenting data from image object assuming UIElements have been loaded
     */
    func setInfo(image: Image) {
        guard let previewImageView = self.previewImageView else { return }
        
        // Asynchronously load image from cache or make request to load image
        let url = URL(string: image.getImagePath() ?? "")
        previewImageView.sd_setImage(with: url, completed: nil)
        
    }

}
