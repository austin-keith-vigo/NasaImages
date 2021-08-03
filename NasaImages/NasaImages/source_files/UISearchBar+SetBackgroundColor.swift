//
//  UISearchBar+SetBackgroundColor.swift
//  NasaImages
//
//  Created by austin vigo on 8/2/21.
//

import Foundation
import UIKit

extension UISearchBar {
    func setTextFieldBackgroundColor(_ color: UIColor?) {
        self.getTextField()?.backgroundColor = color
    }
    
    // Return text field that can be used to customize
    func getTextField() -> UITextField? {
        if #available(iOS 13, *) {
            return self.searchTextField
        }
        
        let subviews = self.subviews.flatMap{ $0.subviews }
        guard let textField = (subviews.filter {$0 is UITextField}).first as? UITextField else {
            return nil
        }
        return textField
    }
    
}
