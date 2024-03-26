//
//  MovieDBServiceMock.swift
//  NetworkCallsTemplate
//
//  Created by Waldyr Schneider on 26/03/24.
//

import Foundation

@testable
import NetworkCallsTemplate

class MovieDBServiceMock: Service {
    func setupFetchRequest(url urlString: String) -> URLRequest? {
        if !urlString.isEmpty {
            guard let url = URL(string: urlString) else { return nil }
            return URLRequest(url: url)
        } else {
            return nil
        }
    }
    
    func fetchImage(posterPath path: String, completionBlock: @escaping (Data) -> Void) {
        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2, execute: {
            completionBlock(Data())
        })
    }
}
