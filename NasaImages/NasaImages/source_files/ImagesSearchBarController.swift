//
//  ImagesSearchBarController.swift
//  NasaImages
//
//  Created by austin vigo on 8/2/21.
//

import Foundation
import UIKit

class ImagesSearchBarController: NSObject {
    
    var searchBar: UISearchBar?
    
    var didPressSearch: ((_ text: String) -> Void)?
    
    init(searchBar: UISearchBar) {
        super.init()
        
        // Init Search Bar
        self.searchBar = searchBar
        self.searchBar?.delegate = self
        self.searchBar?.getTextField()?.font = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.searchBar?.setTextFieldBackgroundColor(ThemeColors.LIGHT_GRAY)
        self.searchBar?.barTintColor = UIColor.clear
        self.searchBar?.backgroundColor = UIColor.clear
        self.searchBar?.isTranslucent = true
        self.searchBar?.setBackgroundImage(UIImage(), for: .any, barMetrics: .default) // Necessary to make search bar see through
    }
    
    
    func getText() -> String {
        if let text = searchBar?.text {
            return text
        }
        else {
            return ""
        }
    }
    
    // Dismisses keyboard when val == true
    func endEditing(_ val: Bool) {
        guard let searchBar = self.searchBar else { return }
        searchBar.endEditing(val)
    }
}

extension ImagesSearchBarController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            self.searchBar?.endEditing(true)
            self.didPressSearch?(text)
        }
    }
}
