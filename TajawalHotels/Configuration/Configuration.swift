//
//  Configuration.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import Foundation

class Configuration {
    
    // the current singleton configuration
    static let current = Configuration()
    
    // the current environment (Debug, Release)
    var environment: Environment {
        guard let environment = all["Environment"] as? String else {
            return .debug
        }
        
        return Environment(rawValue: environment.lowercased()) ?? .debug
    }
    
    // all configurations
    fileprivate var all = [String: Any]()
    
    fileprivate init() {
        
        // load all configurations
        guard let configurations = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? [String: Any] else {
            fatalError("Configuration missing from info.plist")
        }
        
        self.all = configurations
    }
    
    var baseURL: URL {
        
        // get the scheme and host from configuration
        let scheme = all["URLScheme"] as? String
        let host = all["URLHost"] as? String
        
        // build url
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host

        guard let url = urlComponents.url else {
            fatalError("Couldn't build base url")
        }
        
        return url
    }
}

extension Configuration {
    
    enum Environment: String {
        case debug
        case release
    }
}
