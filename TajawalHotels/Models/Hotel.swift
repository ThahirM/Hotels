//
//  Hotel.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import Foundation
import CoreLocation

class Hotel {
    var id = 0
    var name = ""
    var images = [String]()
    var address = ""
    var location: CLLocation?
    var highRate = 0.0
    var lowRate = 0.0
    
    var hasDiscount: Bool {
        return highRate > lowRate
    }
    
    init(with dictionary: [String: Any]) {
        self.id = dictionary["hotelId"] as? Int ?? 0
        self.name = dictionary[keyPath: "summary.hotelName"] as? String ?? ""
        self.address = dictionary[keyPath: "location.address"] as? String ?? ""
        self.highRate = dictionary[keyPath: "summary.highRate"] as? Double ?? 0.0
        self.lowRate = dictionary[keyPath: "summary.lowRate"] as? Double ?? 0.0
        self.images = (dictionary["image"] as? [[String: Any]])?.compactMap { $0["url"] as? String } ?? []

        if let latitude = dictionary[keyPath: "location.latitude"] as? Double, let longitude = dictionary[keyPath: "location.longitude"] as? Double {
            self.location = CLLocation(latitude: latitude, longitude: longitude)
        }
    }
}

extension Hotel: Searchable {
    func passesSearch(searchKey: String?, ignoreEmptyKey: Bool = true) -> Bool {
        
        // handle result for empty search key
        guard let searchKey = searchKey?.trimmed, !searchKey.isEmpty else {
            return ignoreEmptyKey
        }
        
        return name.localizedCaseInsensitiveContains(searchKey)
    }
}

// Router has all information related to the service calls initiated by this model
extension Hotel {
    enum Router: Requestable {
        case list
        
        var path: APIPath? {
            return .hotels
        }
    }
}

extension Hotel {
    fileprivate struct ListResponse {
        var hotels = [Hotel]()
        
        init(with dictionary: [String: Any]) {
            guard let hotels = dictionary["hotel"] as? [[String: Any]] else { return }
            self.hotels = hotels.compactMap { Hotel(with: $0) }
        }
    }
}

extension Hotel {
    static func list(completionHandler: @escaping ([Hotel], Error?) -> Void) {
        Router.list.request { (response, error) in
            
            // handle errors
            guard error == nil else {
                completionHandler([], error)
                return
            }

            // get response
            guard let response = response as? [String: Any] else { return }
            
            let listResponse = ListResponse(with: response)
            completionHandler(listResponse.hotels, nil)
        }
    }
}
