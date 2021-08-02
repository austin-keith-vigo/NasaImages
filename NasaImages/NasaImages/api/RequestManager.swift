//
//  RequestManager.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import Foundation


enum JSONError: String, Error {
    case NoData = "ERROR: no data"
    case ConversionFailed = "ERROR: conversion from JSON failed"
}


/*
 Singleton to manage request to API
 */
class RequestManager: NSObject {
    
    static var sharedInstance: RequestManager?
    
    static func getInstance() -> RequestManager {
        
        if RequestManager.sharedInstance == nil {
            RequestManager.sharedInstance = RequestManager()
        }
        
        return RequestManager.sharedInstance!
    }
    
    
    /*
     Makes a request to /search endpoint
     */
    func getImagesBySearchTermForPage(searchTerm: String, page: Int, completionHandler: @escaping (_ images: [Image], _ error: String?) -> Void) {
        
        // Create URL
        var searchTerm = searchTerm
        if searchTerm == "" { // Handle empty search term
            searchTerm = "''"
        }
        let url = URL(string: NetworkConstants.BASE_URL + "search?q=\(searchTerm)&page=\(page)&media_type=image")
        print(NetworkConstants.BASE_URL + "search?q=\(searchTerm)&page=\(page)&media_type=image")

        guard let requestUrl = url else {
            completionHandler([], "Could not create URL")
            return
        }
        
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                completionHandler([], error.localizedDescription)
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 400 {
                    completionHandler([], "400 Status Code: Bad Request")
                    return
                } else if response.statusCode == 404 {
                    completionHandler([], "404 Status Code: The requested resource doesn’t exist.")
                    return
                } else if response.statusCode == 500 || response.statusCode == 502 || response.statusCode == 503 || response.statusCode == 504 {
                    completionHandler([], "\(response.statusCode) Status Code: Something went wrong on the API’s end.")
                    return
                }
            }
            

            // Convert HTTP Response Data to a Image objects
            if let images = self.parseJSONForImages(data: data) {
                completionHandler(images, nil)
            } else {
                completionHandler([], "Could not parse results")
            }
            
        }
        task.resume()
    }
    
    
    /*
     Parses json response from api and converts into image objects
     */
    func parseJSONForImages(data: Data?) -> [Image]? {
        
        // Convert HTTP Response Data to a dictionary
        var images: [Image] = []
        do {
            if let convertedJsonIntoDict = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                if let collection = convertedJsonIntoDict["collection"] as? NSDictionary {
                    if let items = collection["items"] as? [NSDictionary] {
                        for item in items {
                            
                            // Parse for preview URL
                            var imageURL: String = ""
                            if let links = item["links"] as? [NSDictionary] {
                                for link in links {
                                    if let value = link["href"] as? String {
                                        imageURL = value
                                    }
                                }
                            }
                            
                            // Parse for remaing image data
                            if let itemData = item["data"] as? [NSDictionary] {
                                for data in itemData {
                                    
                                    let id = data["nasa_id"] as? String ?? ""
                                    let imagePath = imageURL
                                    let title = data["title"] as? String ?? ""
                                    let description = data["description"] as? String ?? ""
                                    let photographer = data["photographer"] as? String ?? ""
                                    let location = data["location"] as? String ?? ""
                                    
                                    let newImage = Image(id: id,
                                                         title: title,
                                                         imagePath: imagePath,
                                                         description: description,
                                                         photographer: photographer,
                                                         location: location)
                                    
                                    
                                    images.append(newImage)
                                }
                            }
                        }
                    } else {
                        return nil
                    }
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch let _ as NSError {
            return nil
        }
        
        return images
    }
    
}
