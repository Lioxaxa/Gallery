//
//  NetworkManager.swift
//  Gallery
//
//  Created by Pupko, Aleksey on 9.01.24.
//

import Foundation


class NetworkManager {
    
    func loadRandomPhotos(completion: @escaping ([PhotoResult]) -> Void) {
        let urlRandomString = "https://api.unsplash.com/photos/?client_id=JC3UPlJ-sNqsuurByjD2FDD4d2FoounLQUc4CylihrA&page=1&per_page=30"
        guard let url = URL(string: urlRandomString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            do {
                let jsonResult: [PhotoResult] = try JSONDecoder().decode([PhotoResult].self, from: data)
                             completion(jsonResult)
                
            }
            catch{
                print(error)
            }
        }
        task.resume()
    }
}
