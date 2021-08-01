//
//  Image.swift
//  NasaImages
//
//  Created by austin vigo on 8/1/21.
//

import Foundation

class Image {
    
    private var id: String
    private var title: String?
    private var imagePath: String?
    private var description: String?
    private var photographer: String?
    private var location: String?
    
    init(id: String, title: String?, imagePath: String?, description: String?, photographer: String?, location: String?) {
        self.id = id
        self.title = title
        self.imagePath = imagePath
        self.description = description
        self.photographer = photographer
        self.location = location
    }
    
    /* GETTERS */
    func getId() -> String { return self.id}
    func getTitle() -> String? { return self.title }
    func getImagePath() -> String?  { return self.imagePath }
    func getDescription() -> String? { return self.description }
    func getPhotographer() -> String? { return self.photographer }
    func getLocation() -> String? { return self.location }
    
    /* SETTTERS */
    func setTitle(newTitle: String?) { self.title = newTitle }
    func setImagePath(newImagePath: String?) { self.imagePath = newImagePath }
    func setDescription(newDescription: String?) { self.description = newDescription }
    func setPhotographer(newPhotographer: String?) { self.photographer = newPhotographer }
    func setLocation(newLocation: String?) { self.location = newLocation}
}
