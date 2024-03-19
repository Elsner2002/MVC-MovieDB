//
//  Singleton.swift
//  NetworkCallsTemplate
//
//  Created by Felipe  Elsner Silva on 18/03/24.
//

import Foundation
import UIKit

class Constants: ObservableObject {
    
    static let shared: Constants = Constants()
    
    //MARK: Outlets and Variables setup
    var movieCellID: String = "smallMovieCell"
    var segueID: String = "toDetails"
    var urlPopular: String = "https://api.themoviedb.org/3/movie/popular?api_key=2d4b4abbcf1392ca7691bf7d93f415c9&language=en-US&page=1"
    var urlNowPlaying: String = "https://api.themoviedb.org/3/movie/now_playing?api_key=2d4b4abbcf1392ca7691bf7d93f415c9&language=en-US&page=1"
    
    var detailCellID: String = "detailCell"
    
    var headers = [
      "accept": "application/json",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiIyZDRiNGFiYmNmMTM5MmNhNzY5MWJmN2Q5M2Y0MTVjOSIsInN1YiI6IjY0OWM2NDQ0ZmQ0ZjgwMDBlY2IzZTZkNCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.1KVIGHOCX3Kc8HmFRMQR36R9sMkRVlz81ikniCVMig8"
    ]
    
}

protocol Coordinator {}
