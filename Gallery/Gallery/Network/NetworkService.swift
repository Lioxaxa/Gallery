//
//  NetworkManager.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 9.01.24.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed
    case invalidResponse
    case decodingError
}

class NetworkService {
    
    let baseUrl = "https://api.unsplash.com/"
    let endPoint = "photos"
    let clientId = "JC3UPlJ-sNqsuurByjD2FDD4d2FoounLQUc4CylihrA"
    let perPage = 30
    
    func fetchPhotos(page: Int) async throws -> [Photo] {
        var urlComponents = URLComponents(string: baseUrl + endPoint)
        urlComponents?.queryItems = [
            URLQueryItem(name: "client_id", value: clientId),
            URLQueryItem(name: "page", value: String(page)),
            URLQueryItem(name: "per_page", value: String(perPage))
        ]
        
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        do {
            let result = try JSONDecoder().decode([PhotoResult].self, from: data)
            return result.map({$0.convertToPhoto()})
        } catch {
            throw NetworkError.decodingError
        }
    }
}
