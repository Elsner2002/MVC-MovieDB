//
//  Movie.swift
//  TableViewGA
//
//  Created by Marina De Pazzi on 25/05/23.
//

import Foundation
import UIKit

struct Movie: Decodable {
    
    var id: Int
    var title: String
    var overview: String
    var voteAverage: Double
    var posterPath: String
    var genreIDs: [Int]
    
    var imageCover: Data?
    
    var description: String {
        return "\(self.id)" + " - " + self.title
    }
    
    func getGenerID() -> String {
        var g = ""
        for genreID in genreIDs {
            g = "\(genreID), " + g
        }
        return g
    }
    
    func getTitle() -> String {
        return title
    }
    
    
    func getVote() -> String {
        return String(voteAverage)
    }
    
    func getOverview() -> String {
        return overview
    }
}

enum Section: Int, CaseIterable {
    case nowPlaying
    case popular
    
    var value: String {
        switch self {
        case .nowPlaying:
            return "Now Playing"
        case .popular:
            return "Popular"
        }
    }
}

struct MovieResponse: Decodable {
    var results: [Movie]
}

protocol Storyboarded {
    static func instantiate() -> Self
}
extension Storyboarded where Self: UIViewController {
    static func instantiate() -> Self {
        let fullname = NSStringFromClass(self)
        let classname = fullname.components(separatedBy: ".")[1]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier:  classname) as! Self
    }
}
