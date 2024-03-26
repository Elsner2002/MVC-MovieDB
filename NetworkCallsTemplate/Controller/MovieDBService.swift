//
//  MovieDBService.swift
//  NetworkCallsTemplate
//
//  Created by Felipe  Elsner Silva on 29/06/23.
//

import Foundation

protocol Service {
    func setupFetchRequest(url urlString: String) -> URLRequest?
    func fetchImage(posterPath path: String, completionBlock: @escaping (Data) -> Void)
}

// MARK: - Service
class MovieDBService: Service {
    func setupFetchRequest(url urlString: String) -> URLRequest? {
        guard let url = URL(string: urlString) else { return nil }
        var request = URLRequest(url: url)
        
        for (key, value) in Constants.shared.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        return request
    }
    
    func fetchImage(posterPath path: String, completionBlock: @escaping (Data) -> Void) {
        guard let request = setupFetchRequest(url: "https://image.tmdb.org/t/p/w342\(path)") else { return }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data
            else { return }
            
            completionBlock(data)
            
        }.resume()
    }
}

