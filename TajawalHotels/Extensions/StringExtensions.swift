//
//  StringExtensions.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/6/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

extension String {
    var trimmed: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    
    func strikeThrough(with color: UIColor? = nil) -> NSAttributedString {
        
        // strikethrough
        var attributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue]
        
        // set color if there is one
        if let color = color {
            attributes[NSAttributedString.Key.foregroundColor] = color
        }
        
        // create attributed string with the attributes
        return NSMutableAttributedString(string: self, attributes: attributes)
    }
}
