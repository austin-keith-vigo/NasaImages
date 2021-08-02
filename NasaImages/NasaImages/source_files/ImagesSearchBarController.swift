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
        self.searchBar?.searchTextField.font = UIFont(name: "HelveticaNeue", size: 17.0)!
        self.searchBar?.searchTextField.textColor = .red
        self.searchBar?.backgroundColor = .clear
        self.searchBar?.searchTextField.backgroundColor = .blue
    }
    
    
    func getText() -> String {
        if let text = searchBar?.text {
            return text
        }
        else {
            return ""
        }
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
