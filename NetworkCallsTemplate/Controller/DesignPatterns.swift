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
    
    //MARK: Variables representing the immutable names
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

protocol Coordinator {
    
    var childCoordinators: [Coordinator] { get set }
    
    var navigationController: UINavigationController { get set }
    
    func start()
}

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
        
    func start() {
        let vc = ViewController.instantiate()
        vc.coordinator = self
        
        navigationController.pushViewController(vc, animated: false)
    }
    
    func movieDetail(_ segue: UIStoryboardSegue, movie: Movie ) {
        let vc = DetailsViewController()
                
        vc.coordinator = self
                
        let destination = segue.destination as! DetailsViewController
        
        destination.detailController = DetailController(movie: movie)
    }
    
    func performNavigation(_ indexPath: IndexPath, controller: MainController) {

        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        vc.coordinator = self
        
        vc.performSegue(withIdentifier: Constants.shared.segueID, sender: controller.chooseSection(indexPath))
    }
}
