//
//  DoubleExtensions.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/6/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import Foundation

extension Double {
    func currencyFormatted(for currency: String = "AED") -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.currencyCode = currency
        numberFormatter.positiveFormat = "¤ #,##0.00"
        numberFormatter.negativeFormat = "¤ -#,##0.00"
        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
