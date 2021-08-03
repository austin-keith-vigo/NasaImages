//
//  ImageCache.swift
//  NasaImages
//
//  Created by austin vigo on 8/2/21.
//

import Foundation
import UIKit

class ImageCache {
    
    private static var cache: NSCache = NSCache<NSString, UIImage>()
 
    /*
     Loads image from web asynchronosly and caches it, in case you have to load url
     again, it will be loaded from cache if available
     */
    static func load(url: URL, completionHandler: @escaping (_ image: UIImage?) -> Void){        let request = URLRequest(url: url)
        if let image = ImageCache.cache.object(forKey: url.absoluteString as NSString) {
            completionHandler(image)
        } else {
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    ImageCache.cache.setObject(image, forKey: url.absoluteString as NSString)
                    completionHandler(image)
                }
            }).resume()
        }
    }
    
    
    /*
     Clears all cached responses from the image cache to free up space
     */
    static func clear(_ cache: URLCache? = nil) {
        ImageCache.cache.removeAllObjects()
    }
}
