//
//  AlertControllerExtensions.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/7/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func ok(title: String = "", message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
    }
}
