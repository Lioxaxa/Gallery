//
//  PhotoModel.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 9.01.24.
//

import Foundation

// MARK: - PhotoResult

struct PhotoResult: Decodable {
    let id: String
    let description: String?
    let urls: PhotoURLs

    enum CodingKeys: String, CodingKey {
        case id
        case description
        case urls
    }
    
    func convertToPhoto() -> Photo {
        Photo(id: self.id,
              description: self.description,
              thumbImageURL: self.urls.thumb,
              largeImageURL: self.urls.regular,
              isLiked: {
            let favorites = PreferencesService.shared.favoriteImages
            return favorites.contains(id)
        }())
    }
}

// MARK: - PhotoURLs

struct PhotoURLs: Decodable {
    let raw, full, regular: String?
    let thumb, small: String
}

// MARK: - Photo

struct Photo {
    let id: String
    let description: String?
    let thumbImageURL: String
    let largeImageURL: String?
    var isLiked: Bool
    
    init(id: String, description: String?, thumbImageURL: String, largeImageURL: String?, isLiked: Bool) {
        self.id = id
        self.description = description
        self.thumbImageURL = thumbImageURL
        self.largeImageURL = largeImageURL
        self.isLiked = isLiked
    }
}
