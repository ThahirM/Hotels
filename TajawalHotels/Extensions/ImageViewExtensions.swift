//
//  ImageViewExtensions.swift
//  TajawalHotels
//
//  Created by Thahir Maheen on 10/6/18.
//  Copyright © 2018 Thahir Maheen. All rights reserved.
//

import UIKit

class ImageCache {
    
    static var shared = ImageCache()
    private init() { }
    
    private var memoryCache = [String: UIImage]()
    
    private var cacheDirectoryPath: URL? {
        return FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
    }
    
    private func filePath(for key: String) -> URL? {
        return cacheDirectoryPath?.appendingPathComponent(key)
    }
    
    func image(for key: String) -> UIImage? {
        
        // try to get image from memory cache
        if let cachedImage = memoryCache[key] {
            return cachedImage
        }
        
        // abort if we cant get the file name
        guard let file = filePath(for: key) else { return nil }
        
        // get image from the path
        return UIImage(contentsOfFile: file.path)
    }
    
    func cache(image: UIImage, for key: String) {
        
        // save it in memory cache as well
        memoryCache[key] = image
        
        // abort if we cant get the data
        guard let imageData = image.jpegData(compressionQuality: 1.0) else { return }
        
        // abort if we cant create a file to save the image
        guard let file = filePath(for: key) else { return }
        
        // cache
        try? imageData.write(to: file)
    }
}

extension UIImageView {
    
    func setImage(with urlString: String, placeholderImage: UIImage? = nil) {
        setImage(with: URL(string: urlString), placeholderImage: placeholderImage)
    }
    
    func setImage(with url: URL?, placeholderImage: UIImage? = nil) {
        
        // set the placeholder image
        image = placeholderImage

        // make sure we have a url
        guard let url = url else { return }
        
        // get a background thread as we dont want to block the UI
        DispatchQueue.global(qos: .background).async { [weak self] in
            
            // try to get the image from cache
            if let image = ImageCache.shared.image(for: url.path) {
                DispatchQueue.main.async {
                    self?.image = image
                }
                return
            }
            
            ServiceManager.shared.session.dataTask(with: url) { (data, response, error) in
                
                // abort if we failed to download the image
                guard error == nil, let data = data, let downloadedImage = UIImage(data: data) else { return }
                
                // cache the image
                ImageCache.shared.cache(image: downloadedImage, for: url.path)
                
                // set new image
                DispatchQueue.main.async {
                    self?.image = downloadedImage
                }
            }.resume()
        }
    }
}
