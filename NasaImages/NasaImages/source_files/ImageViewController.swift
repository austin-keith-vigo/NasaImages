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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var contentViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollIndicatorView: UIView!
    
    
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
        
        
        // Init navigation back button
        let navigationBackButtonImage = UIImage(systemName: "chevron.backward")?.withRenderingMode(.alwaysTemplate)
        self.navigationBackButton.setImage(navigationBackButtonImage, for: .normal)
        self.navigationBackButton.tintColor = .white
        
        
        // Init previewImageView
        self.previewImageView?.contentMode = .scaleAspectFit
        
        
        // Init titleLabel
        self.titleLabel?.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)!
        self.titleLabel?.textColor = .white
        self.titleLabel?.numberOfLines = 1
        
        
        // Init photographerLabel
        self.photographerLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 15.0)!
        self.photographerLabel?.textColor = .white
        self.titleLabel?.numberOfLines = 1
        
        
        // Init descriptionLabel
        self.descriptionLabel?.font = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.descriptionLabel?.textColor = .white
        self.descriptionLabel?.numberOfLines = 0
        
        
        // Init contentView
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(didPanContentView(_:)))
        panGesture.minimumNumberOfTouches = 1
        self.contentView.addGestureRecognizer(panGesture)
        self.contentView.backgroundColor = ThemeColors.DARK_GRAY
        self.contentView.layer.cornerRadius = 15.0
        self.contentView.clipsToBounds = true
        
        
        // Init ScrollIndicatorView
        self.scrollIndicatorView.layer.cornerRadius = 3.0
        self.scrollIndicatorView.clipsToBounds = true
        
        
        // Init scrollView
        self.scrollView.bounces = false
        self.scrollView.backgroundColor = nil
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
            
            self.titleLabel?.text = image.getTitle() ?? ""
            
            let url = URL(string: image.getImagePath() ?? "")
            self.previewImageView?.sd_setImage(with: url, completed: nil)
            
            var photographerStr = ""
            if let photographer = image.getPhotographer(), photographer.count > 0 {
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
        self.didPressDismiss?()
    }
    
    // Dismisses view
    @objc func dismissSelf() {
        self.didPressDismiss?()
    }
}
