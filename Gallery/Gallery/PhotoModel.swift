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
    let createdAt: String
    let width, height, likes: Int
    let likedByUser: Bool
    let description: String?
    let urls: PhotoURLs

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case width, height, likes
        case likedByUser = "liked_by_user"
        case description, urls
    }
    
//    func convertToPhoto() -> Photo {
//        Photo(id: self.id,
//              size: CGSize(width: self.width,
//                           height: self.height),
//              createdAt: self.createdAt,
//              welcomeDescription: self.description,
//              thumbImageURL: self.urls.small,
//              largeImageURL: self.urls.full,
//              isLiked: self.likedByUser)
//    }
}

//MARK: - Like Result

struct LikeResult: Decodable {
    let photo: PhotoResult
}

// MARK: - PhotoURLs
struct PhotoURLs: Decodable {
    let raw, full, regular: String?
    let thumb, small: String
}
