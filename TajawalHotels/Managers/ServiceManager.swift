//
//  ServiceManager.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/5/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import Foundation

class ServiceManager {
    
    // singleton
    static let shared = ServiceManager()
    
    var session: URLSession
    
    private init() {
        session = URLSession.shared
    }
    
    var baseURL: URL {
        return Configuration.current.baseURL
    }
    
    func fetchData(from request: Requestable, completionHandler: ((Any?, Error?) -> Void)?) {
        
        // data task
        session.dataTask(with: request.url) { (data, response, error) in
            
            // abort if we have errors or if we dont have data
            guard error == nil, let data = data else {
                completionHandler?(nil, error)
                return
            }
            
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                completionHandler?(jsonData, nil)
            }
            catch {
                completionHandler?(nil, error)
            }
        }.resume()
    }
}
