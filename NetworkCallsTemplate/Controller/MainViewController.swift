//
//  MainViewController.swift
//  NetworkCallsTemplate
//
//  Created by Felipe  Elsner Silva on 18/03/24.
//

import Foundation
import UIKit

class MainController {
    private var sections: [Section] = Section.allCases
    private var nowPlaying: [Movie] = []
    private var popular: [Movie] = []
    
    let movieService: MovieDBService = MovieDBService()
    
    //MARK: Call teh API to get data
    func apiCall(_ tableView: UITableView) {
        //get the popular movies in API
        guard let urlP = URL(string: Constants.shared.urlPopular) else { return }
        URLSession.shared.dataTask(with: urlP) { [weak self] data, response, error in
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data
            else {
                print(error ?? "error")
                return
            }
            
            self?.decodeByManualKeys(data: data, type: .popular)
            
            self?.reloadData(tableView)
        }
        .resume()
        
        //get the now playing movies in API
        guard let urlNP = URL(string: Constants.shared.urlNowPlaying) else { return }
        URLSession.shared.dataTask(with: urlNP) { [weak self] data, response, error in
            
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  error == nil,
                  let data = data
            else {
                print(error ?? "error")
                return
            }
            
            self?.decodeByManualKeys(data: data, type: .nowPlaying)
            
            self?.reloadData(tableView)
        }
        .resume()
    }
    
    //MARK: Auxiliar functions to call API
    private func decodeByProtocols(data: Data, type: Section) {
        do {
            let decodedResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
            switch(type){
            case .nowPlaying:
                self.nowPlaying = decodedResponse.results
            case .popular:
                self.popular = decodedResponse.results
            }
        } catch {
            print(error)
        }
    }
    
    private func decodeByManualKeys(data: Data, type: Section) {
        do {
            
            guard let rawJSON = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed) as? [String: Any],
                  let json = rawJSON["results"] as? [[String: Any]]
            else {
                print("Error while parsing JSON")
                return
            }
            
            //get the API data info from it's id
            for movies in json {
                guard let id = movies["id"] as? Int,
                      let title = movies["original_title"] as? String,
                      let overview = movies["overview"] as? String,
                      let posterPath = movies["poster_path"] as? String,
                      let voteAverage = movies["vote_average"] as? Double,
                      let genreIDs = movies["genre_ids"] as? [Int]
                else {
                    continue
                }
                
                //save in the respective array
                let movie = Movie(id: id, title: title, overview: overview, voteAverage: voteAverage, posterPath: posterPath, genreIDs: genreIDs)
                switch(type){
                case .nowPlaying:
                    self.nowPlaying.append(movie)
                case .popular:
                    self.popular.append(movie)
                }
            }
        } catch {
            print(error)
        }
    }
    
    private func reloadData(_ tableView: UITableView) {
        DispatchQueue.main.async {
            tableView.reloadData()
        }
    }
    
    //MARK: auxiliar functions to get info for view
    func chooseSection(_ indexPath: IndexPath) -> Movie {
        let currentSection = self.sections[indexPath.section]
        
        switch currentSection {
        case .nowPlaying:
            return nowPlaying[indexPath.row]
        case .popular:
            return popular[indexPath.row]
        }
    }
    func sectionCount(_ section: Int) -> Int {
        let currentSection = self.sections[section]
        
        switch currentSection {
        case .nowPlaying:
            return self.nowPlaying.count
        case .popular:
            return self.popular.count
        }
    }
    func getSections() -> [Section] {
        return sections
    }
    func setContent(_ header: UITableViewHeaderFooterView, section: Int) -> UIListContentConfiguration{
        var content = header.defaultContentConfiguration()
        
        content.text = sections[section].value
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        content.textProperties.color = .label
        
        return content
    }
    
    //MARK: Edit the cell for each type of movie
    func movieInRow(cell: SmallMovieCell, _ indexPath: IndexPath, _ tableView: UITableView) {
        
        let currentSection = self.sections[indexPath.section]
        
        switch currentSection {
        case .nowPlaying:
            editCell(cell: cell, indexPath, tableView, movieArray: nowPlaying, sec: currentSection)
    
        case .popular:
            editCell(cell: cell, indexPath, tableView, movieArray: popular, sec: currentSection)
        }
    }
    
    private func editCell(cell: SmallMovieCell, _ indexPath: IndexPath, _ tableView: UITableView, movieArray: [Movie], sec: Section) {
        //get the correct movie to use the info
        let movie = movieArray[indexPath.row]
    
        if let dataC = movie.imageCover, let imageC = UIImage(data: dataC) {
            cell.posterView.image = imageC
        }
        else{
            movieService.fetchImage(posterPath: movie.posterPath) { [weak self] data in
                
                switch sec {
                case .nowPlaying:
                    self?.nowPlaying[indexPath.row].imageCover = data
                case .popular:
                    self?.popular[indexPath.row].imageCover = data
                }
    
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
        
        //set the cell information
        cell.titleLabel.text = movieArray[indexPath.row].title
        cell.descriptionLabel.text = movieArray[indexPath.row].overview
        cell.ratingLabel.text = "\(movieArray[indexPath.row].voteAverage)"
    }
}
