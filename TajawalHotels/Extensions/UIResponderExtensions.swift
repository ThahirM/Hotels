//
//  File.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

typealias VoidClosure = () -> Void

extension UIResponder {
    static var identifier: String {
        return "\(self)"
    }
}
