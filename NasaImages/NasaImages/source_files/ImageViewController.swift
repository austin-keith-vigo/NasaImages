//
//  ImageViewController.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import UIKit

class ImageViewController: UIViewController {
    
    var image: Image?
    
    // Outlets
    @IBOutlet weak var navigationBackButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var photographerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
        self.setInfo()
    }
    
    
    // Prepare UI Elements
    func initViews() {
        
        // Init blur background
        self.view.backgroundColor = .black
        
        
        // Init navigation back button
        let navigationBackButtonImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        self.navigationBackButton.setImage(navigationBackButtonImage, for: .normal)
        self.navigationBackButton.tintColor = .white
        
        
        // Init previewImageView
        self.previewImageView?.contentMode = .scaleAspectFit
        
        // Init titleLabel
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
        self.titleLabel?.textColor = .white
        self.titleLabel?.numberOfLines = 1
        
        // Init photographerLabel
        self.photographerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)
        self.photographerLabel?.textColor = .white
        self.titleLabel?.numberOfLines = 1
        
        // Init descriptionLabel
        self.descriptionLabel?.font = UIFont(name: "HelveticaNeue-Regular", size: 17.0)
        self.descriptionLabel?.textColor = .white
        self.descriptionLabel?.numberOfLines = 0
    }
    
    
    // Set UI Values
    func setInfo() {
        if let image = self.image {
            
            self.titleLabel?.text = image.getTitle() ?? ""
            
            if let url = URL(string: image.getImagePath() ?? "") {
                self.previewImageView?.load(url: url)
            }
            
            var photographerStr = ""
            if let photographer = image.getPhotographer() {
                photographerStr = "Photo By: \(photographer)"
            }
            self.photographerLabel?.text = photographerStr
            
            self.descriptionLabel?.text = image.getDescription() ?? ""
            
        } else {
            print("DEBUG AV: ImageViewController no image")
        }
    }
    
    
    // Pop the view controller
    @IBAction func didTouchNavigationBackButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }


}
