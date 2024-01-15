//
//  PhotosPresenter.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 14.01.24.
//

import Foundation

protocol PhotosPresenterProtocol: AnyObject {
    func photosDidUpdate(photos: [Photo])
}

class PhotosPresenter {
    let networkService: NetworkService
    var photos: [Photo]
    var isLoading: Bool
    var pageNumber: Int

    weak var view: PhotosPresenterProtocol?
    
    init() {
        self.photos = []
        self.pageNumber = 1
        self.isLoading = false
        self.networkService = NetworkService()
    }
   
    func attachToView(view: PhotosPresenterProtocol) {
        self.view = view
    }
    
    func getImages() -> [Photo] {
        return photos
    }

    func fetchImages() {
        isLoading = true
        Task {
            let fetchedPhotos = try await networkService.fetchPhotos(page: pageNumber)
            photos.append(contentsOf: fetchedPhotos)
            pageNumber += 1
            isLoading = false
            self.view?.photosDidUpdate(photos: photos)
        }
    }
    
    func changeLike(id: String, index: Int) {
        var favorites = PreferencesService.shared.favoriteImages
        if let favoriteIndex = favorites.firstIndex(of: id) {
            favorites.remove(at: favoriteIndex)
            photos[index].isLiked = false
        } else {
            favorites.append(id)
            photos[index].isLiked = true
        }
        PreferencesService.shared.favoriteImages = favorites
        self.view?.photosDidUpdate(photos: photos)
    }
}
