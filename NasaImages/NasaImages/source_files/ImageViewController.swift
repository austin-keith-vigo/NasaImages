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
    @IBOutlet weak var scrollViewTopConstraint: NSLayoutConstraint!
    
    
    // Callbacks
    var didPressDismiss: (() -> Void)?
    
    // Variables
    var previousContentOffsetY: CGFloat?
    let minTopConstraintConstant: CGFloat = 100.0
    var previousTopConstraintConstant: CGFloat = 100.0
    var willDismiss: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initViews()
        self.setInfo()
    }
    
    
    // Prepare UI Elements
    func initViews() {
        
        // Init blur background
        self.view.backgroundColor = nil
        self.scrollView.backgroundColor = ThemeColors.DARK_GRAY
        
        
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
        
        // Init scrollView
        self.scrollView.delegate = self
        self.scrollView.decelerationRate = .fast
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
}

extension ImageViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // Calculate direction user is scrolling
        let direction = getDirectionOfScroll(self.scrollView.contentOffset.y)
        
        // Handle user scroll
        switch direction {
        case 1:
            self.handleScrollUp(scrollView.contentOffset.y)
        case -1:
            self.handleScrollDown(scrollView.contentOffset.y)
        default:
            // Do nothing
            do {}
        
        }
        previousContentOffsetY = self.scrollView.contentOffset.y
    }
    
    /*
     Calculates the direction the user is scrolling
     1: scrolling up
     -1: scrolling down
     0: no change
     */
    func getDirectionOfScroll(_ contentOffsetY: CGFloat) -> Int {
        var direction: Int = 0
        if let previousContentOffsetY = self.previousContentOffsetY {
            direction = (self.scrollView.contentOffset.y > previousContentOffsetY) ? 1 : -1
        } else {
            direction = (self.scrollView.contentOffset.y > 0) ? 1 : -1
        }
        return direction
    }
    
    /*
     Moves the scroll view up on user scroll
     */
    func handleScrollUp(_ contentOffsetY: CGFloat) {
        
        // Disallow movement if the topConstraint hasn't already been changed
        if self.scrollViewTopConstraint.constant > self.minTopConstraintConstant {
            var newConstant = self.scrollViewTopConstraint.constant - contentOffsetY
            if newConstant < self.minTopConstraintConstant { newConstant = CGFloat(self.minTopConstraintConstant) }
            self.scrollViewTopConstraint.constant = newConstant
            self.scrollView.setNeedsLayout()
            self.scrollView.contentOffset = .zero
    
            // Update Variables
            self.previousTopConstraintConstant = newConstant
        }
    }
    
    /*
     Moves the scrollView down on user scroll
     */
    func handleScrollDown(_ contentOffsetY: CGFloat) {
        
        // Disallow movement if contentOffset is not @ .zero
        if contentOffsetY < 0 {
            
            // Move Scroll View
            let newConstant = self.scrollViewTopConstraint.constant + (-1 * contentOffsetY)
            self.scrollViewTopConstraint.constant = newConstant
            self.scrollView.setNeedsLayout()
            self.scrollView.contentOffset = .zero
            
            // Update Variables
            self.previousTopConstraintConstant = newConstant
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate && scrollViewTopConstraint.constant != self.minTopConstraintConstant  {
            
            self.scrollViewTopConstraint.constant = self.minTopConstraintConstant
            self.scrollView.setNeedsLayout()
            
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.scrollViewTopConstraint.constant = self.minTopConstraintConstant
        self.scrollView.setNeedsLayout()
    }
    
    
}
