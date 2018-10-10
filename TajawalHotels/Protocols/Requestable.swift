//
//  Requestable.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import Foundation

protocol Requestable {
    
    // the base url
    var baseURL: URL { get }
    
    // the full url with path details attached which will be used to hit service
    var url: URL { get }
    
    // path component
    var path: APIPath? { get }
    
    // request method
    func request(completionHandler: ((Any?, Error?) -> Void)?)
}

extension Requestable {
    
    // defaults to base url of service manager
    var baseURL: URL {
        return ServiceManager.shared.baseURL
    }
    
    var url: URL {
        guard let path = path else { return baseURL }
        return baseURL.appendingPathComponent(path.name)
    }
    
    // defaults to nil
    var path: APIPath? {
        return nil
    }
    
    func request(completionHandler: ((Any?, Error?) -> Void)?) {
        ServiceManager.shared.fetchData(from: self, completionHandler: completionHandler)
    }
}
