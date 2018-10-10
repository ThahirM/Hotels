//
//  Searchable.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/6/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import Foundation

protocol Searchable {
    func passesSearch(searchKey: String?, ignoreEmptyKey: Bool) -> Bool
}

extension Array where Element: Searchable {
    func filter(for searchKey: String?, ignoreEmptyKey: Bool = true) -> [Element] {
        return filter { $0.passesSearch(searchKey: searchKey, ignoreEmptyKey: ignoreEmptyKey) }
    }
}
