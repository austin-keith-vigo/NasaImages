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
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var photographerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollIndicatorView: UIView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    // Callbacks
    var didPressDismiss: (() -> Void)?
    
    // Variables
    let minTopConstraintConstant: CGFloat = 75.0
    var willDismiss: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
        self.setInfo()
    }
    
    
    // Prepare UI Elements
    func initViews() {
        
        // Init background
        self.view.backgroundColor = nil
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissSelf))
        tapGesture.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapGesture)
        
        
        // Init previewImageView
        self.previewImageView?.contentMode = .scaleToFill
        self.previewImageView?.layer.shadowColor = UIColor.black.cgColor
        self.previewImageView?.layer.shadowOpacity = 0.5
        self.previewImageView?.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.previewImageView?.layer.shadowRadius = 5
        self.previewImageView?.layer.masksToBounds = false
        
        
        // Init descriptionLabel
        self.descriptionLabel?.font = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.descriptionLabel?.textColor = ThemeColors.LIGHT_GRAY
        self.descriptionLabel?.numberOfLines = 0
        
        
        // Init contentView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanContentView(_:)))
        panGesture.minimumNumberOfTouches = 1
        self.contentView.addGestureRecognizer(panGesture)
        self.contentView.backgroundColor = ThemeColors.DARK_BACKGROUND
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.contentView.clipsToBounds = true
        
        
        // Init ScrollIndicatorView
        self.scrollIndicatorView.layer.cornerRadius = 3.0
        self.scrollIndicatorView.clipsToBounds = true
        
        
        // Init scrollView
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = nil
        
        
        // Init photographer label
        self.photographerLabel.numberOfLines = 0
        self.photographerLabel.lineBreakMode = .byWordWrapping
        
        
        // Init location label
        self.locationLabel.numberOfLines = 0
        self.locationLabel.lineBreakMode = .byWordWrapping
        
        
        // Init Title Label
        let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 20.0)!
        self.titleLabel.font = boldFont
        self.titleLabel.textColor = .white
        self.titleLabel.numberOfLines = 0
        self.titleLabel.lineBreakMode = .byWordWrapping
    }
    
    
    // Handles panGesture action for contentView
    @objc func didPanContentView(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            // Do Nothing
            do {}
        case .changed:
            self.handlePanGestureChanged(panGesture)
        case .ended:
            self.handlePanGestureEnded(panGesture)
        case .failed:
            // Do Nothing
            do {}
        case .possible:
            // Do Nothing
            do {}
        case .cancelled:
            // Do Nothing
            do {}
        default:
            // Do Nothing
            do {}
        }
    }
    
    /*
     Recognized user is panning, will move view up or down
     */
    func handlePanGestureChanged(_ panGesture: UIPanGestureRecognizer) {
        let translationY = panGesture.translation(in: self.contentView).y
        let direction = getDirectionOfPan(translationY)
        let distance = abs(abs(self.previousTranslationY) - abs(panGesture.translation(in: self.contentView).y))
        self.previousTranslationY = translationY
        
        switch direction {
        case -1:
            self.moveViewUp(distance: distance)
        case 1:
            self.moveViewDown(distance: distance)
        default:
            // Do nothing
            do {}
        }
        
        // Check if threshold is passed to dismiss view
        if translationY > self.minTopConstraintConstant + 150.0 {
            self.willDismiss = true
        } else {
            self.willDismiss = false
        }
    }
    
    /*
     Will Reset content view back to its starting position
     */
    func handlePanGestureEnded(_ panGesture: UIPanGestureRecognizer) {
        
        if self.willDismiss {
            self.didPressDismiss?()
            return
        }
        
        self.contentViewTopConstraint.constant = self.minTopConstraintConstant
        self.contentView.setNeedsLayout()
    }
    
    /*
     Calculates the direction the user is scrolling
     -1: scrolling up
     1: scrolling down
     0: no change
     */
    var previousTranslationY: CGFloat = 0.0
    func getDirectionOfPan(_ translationY: CGFloat) -> Int {
        
        var direction: Int = 0
        if previousTranslationY > translationY {
            direction = -1
        } else if previousTranslationY < translationY {
            direction = 1
        } else {
            direction = 0
        }
        
        return direction
    }
    

    // Moves the view up
    func moveViewUp(distance: CGFloat) {
        guard self.contentViewTopConstraint.constant >= self.minTopConstraintConstant else { return }
        var newConstant = self.contentViewTopConstraint.constant - distance
        if newConstant < self.minTopConstraintConstant { newConstant = self.minTopConstraintConstant }
        self.contentViewTopConstraint.constant = newConstant
        self.contentView.setNeedsLayout()
    }
    
    
    // Moves the view down
    func moveViewDown(distance: CGFloat) {
        self.contentViewTopConstraint.constant += distance
        self.contentView.setNeedsLayout()
    }
    
    
    // Set UI Values
    func setInfo() {
        if let image = self.image {
            
            // Set preview image label
            let url = URL(string: image.getImagePath() ?? "")
            self.previewImageView?.sd_setImage(with: url, completed: nil)
            
            
            // Set photographer label
            if let photographer = image.getPhotographer(), photographer.count > 0 {
                self.setPhotographerLabel(with: photographer)
            } else {
                self.setPhotographerLabel(with: "Unknown")
            }
            
            
            // Set location label
            if let location = image.getLocation(), location.count > 0 {
                self.setLocationLabel(with: location)
            } else {
                self.setLocationLabel(with: "Unknown")
            }
            
            // Set Title label
            self.titleLabel.text = image.getTitle() ?? "Image"
            
            
            // Remove trailing "Photo Credit:" substring
            var descriptionString = image.getDescription() ?? ""
            let begginingRange = descriptionString.range(of: "Photo Credit:")?.lowerBound
            if let begginingRange = begginingRange {
                let range = begginingRange...descriptionString.index(descriptionString.endIndex, offsetBy: -1)
                descriptionString.removeSubrange(range)
            }
            
            
            // Set description label
            self.descriptionLabel.text = descriptionString
            
        } else {
            print("DEBUG AV: ImageViewController no image")
        }
    }
    
    // Configures photographer label with bold 'Photo By: ' and regular photographer name
    func setPhotographerLabel(with photographerStr: String) {
        
        // Text styles
        let regularFont = UIFont(name: "HelveticaNeue", size: 17.0)!
        let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
        let textColor: UIColor = ThemeColors.LIGHT_GRAY
        
        // Build mutableString
        let boldAttribute = [NSAttributedString.Key.font : boldFont,
                             NSAttributedString.Key.foregroundColor : UIColor.white]
        let regularAttribute = [NSAttributedString.Key.font : regularFont,
                                NSAttributedString.Key.foregroundColor : textColor]
        
        let boldAttributedString = NSMutableAttributedString(string: "Photo By: ", attributes: boldAttribute)
        let regularAttributedString = NSMutableAttributedString(string: photographerStr, attributes: regularAttribute)

        boldAttributedString.append(regularAttributedString)
        
        
        self.photographerLabel.attributedText = boldAttributedString
    }
    
    
    // Configures location label with bold 'Location: ' and regular photographer name
    func setLocationLabel(with locationStr: String) {
        
        // Text styles
        let regularFont = UIFont(name: "HelveticaNeue", size: 17.0)!
        let boldFont = UIFont(name: "HelveticaNeue-Bold", size: 17.0)!
        let textColor: UIColor = ThemeColors.LIGHT_GRAY
        
        // Build mutableString
        let boldAttribute = [NSAttributedString.Key.font : boldFont,
                             NSAttributedString.Key.foregroundColor : UIColor.white]
        let regularAttribute = [NSAttributedString.Key.font : regularFont,
                                NSAttributedString.Key.foregroundColor : textColor]
        
        let boldAttributedString = NSMutableAttributedString(string: "Location: ", attributes: boldAttribute)
        let regularAttributedString = NSMutableAttributedString(string: locationStr, attributes: regularAttribute)

        boldAttributedString.append(regularAttributedString)
        
        self.locationLabel.attributedText = boldAttributedString
    }
    
    
    // Dismisses view
    @objc func dismissSelf() {
        self.didPressDismiss?()
    }
}
