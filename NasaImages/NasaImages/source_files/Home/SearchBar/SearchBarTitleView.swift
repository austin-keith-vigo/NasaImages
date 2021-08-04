//
//  SearchBarTitleView.swift
//  NasaImages
//
//  Created by austin vigo on 8/4/21.
//

import UIKit
import SnapKit

class SearchBarTitleView: UIView {

    // Subviews
    var searchBar: UISearchBar!
    var showSearchBarButton: UIButton!
    var titleLabel: UILabel!
    
    
    // Variables
    var isSearchBarHidden: Bool = true
    
    
    // Callbacks
    var didPressSearch: ((_ searchTerm: String) -> Void)?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        initViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        initViews()
    }
    
    
    // Getter for searchBarText
    func getText() -> String {
        if let text = searchBar?.text {
            return text
        }
        else {
            return ""
        }
    }
    
    
    // Initializes view and subviews
    func initViews() {
        
        self.backgroundColor = .clear
        
        // Initialize search bar
        self.searchBar = UISearchBar(frame: .zero)
        self.searchBar.getTextField()?.font = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.searchBar.setTextFieldBackgroundColor(ThemeColors.LIGHT_GRAY)
        self.searchBar.barTintColor = UIColor.clear
        self.searchBar.backgroundColor = UIColor.clear
        self.searchBar.isTranslucent = true
        self.searchBar.setBackgroundImage(UIImage(), for: .any, barMetrics: .default) // Necessary to make search bar see through
        self.addSubview(self.searchBar)
        self.searchBar.snp.makeConstraints({ maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        })
        self.searchBar.isHidden = true
        self.searchBar.delegate = self
        self.searchBar.getTextField()?.enablesReturnKeyAutomatically = false
        
        
        // Initialize show searchBarButton
        self.showSearchBarButton = UIButton(frame: .zero)
        self.showSearchBarButton.contentEdgeInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        self.addSubview(showSearchBarButton)
        self.sendSubviewToBack(showSearchBarButton)
        self.showSearchBarButton.addTarget(self, action: #selector(showSearchButtonDidTouchDown), for: .touchDown)
        showSearchBarButton.snp.makeConstraints({ maker in
            maker.height.equalTo(50.0)
            maker.width.equalTo(50.0)
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-15.0)
        })
        self.showSearchBarButton.isHidden = false
        let image = UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysTemplate)
        self.showSearchBarButton.setImage(image, for: .normal)
        self.showSearchBarButton.tintColor = .white
        self.showSearchBarButton.backgroundColor = ThemeColors.DARK_GRAY
        self.showSearchBarButton.layer.cornerRadius = 25.0
        self.showSearchBarButton.clipsToBounds = true
        
        
        
        // Initialize Title Label
        self.titleLabel = UILabel()
        self.titleLabel.text = "All"
        self.titleLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 33.0)!
        self.titleLabel.textColor = .white
        self.titleLabel.backgroundColor = .clear
        self.titleLabel.numberOfLines = 1
        self.titleLabel.lineBreakMode = .byTruncatingTail
        self.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints({ maker in
            maker.leading.equalToSuperview().offset(25.0)
            maker.centerY.equalToSuperview()
            maker.trailing.equalTo(self.showSearchBarButton.snp.leading).offset(-15.0)
        })
        
        
        
    }
    
    
    // Handle user pressed showSearchButton
    @objc func showSearchButtonDidTouchDown() {
        self.showSearchBar()
    }
    
    
    /*
    Shows searchBar
    Hides Title and Button
    */
    func showSearchBar() {
        self.searchBar.isHidden = false
        self.titleLabel.isHidden = true
        self.showSearchBarButton.isHidden = true
        
        // Show keyboard for editing
        self.searchBar.becomeFirstResponder()
    }
    
    
    /*
     Hides searchBar
     Shows Title and Button
     */
    func hideSearchBar() {
        self.searchBar.isHidden = true
        self.titleLabel.isHidden = false
        self.showSearchBarButton.isHidden = false
        
        // Hide keyboard if editing
        self.searchBar.endEditing(true)
    }
}

extension SearchBarTitleView: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // Dismiss search bar
        if let text = searchBar.text {
            self.didPressSearch?(text)
            self.hideSearchBar()
            self.titleLabel.text = (text == "") ? "All" : text
        }
        
    }
}
