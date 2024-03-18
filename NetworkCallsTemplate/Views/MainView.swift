//
//  ViewController.swift
//  TableViewGA
//
//  Created by Marina De Pazzi on 24/05/23.
//

import UIKit

//MARK: - ViewController
class ViewController: UIViewController {
    //MARK: TableView Sections
    
    @IBOutlet weak var tableView: UITableView!
    
    private var sections: [Section] = Section.allCases
    private var nowPlaying: [Movie] = []
    private var popular: [Movie] = []
    
    //MARK: View loading methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Fazer a chamada da api aqui
        
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
            
            self?.reloadData()
        }
        .resume()
        
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
            
            self?.reloadData()
        }
        .resume()
        //depois da chamada, atualizar tableView
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
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
    
    //MARK: Refresh UI
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    //MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.shared.segueID,
           let movie = sender as? Movie {
            let destination = segue.destination as! DetailsViewController
            
            destination.detailController = DetailController(movie: movie)
        }
    }
}

//MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentSection = self.sections[indexPath.section]
        
        switch currentSection {
        case .nowPlaying:
            self.performSegue(withIdentifier: Constants.shared.segueID, sender: self.nowPlaying[indexPath.row])
        case .popular:
            self.performSegue(withIdentifier: Constants.shared.segueID, sender: self.popular[indexPath.row])
        }
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].value
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        var content = header.defaultContentConfiguration()
        
        content.text = self.sections[section].value
        content.textProperties.font = .preferredFont(forTextStyle: .headline)
        content.textProperties.color = .label
        
        header.contentConfiguration = content
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let currentSection = self.sections[section]
        
        switch currentSection {
        case .nowPlaying:
            return self.nowPlaying.count
        case .popular:
            return self.popular.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let currentSection = self.sections[indexPath.section]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.movieCellID, for: indexPath) as! SmallMovieCell
        switch currentSection {
        case .nowPlaying:
            let movie = nowPlaying[indexPath.row]
            
            if let dataC = movie.imageCover, let imageC = UIImage(data: dataC){
                cell.posterView.image = imageC
            }
            else{
                MovieDBService.fetchImage(posterPath: movie.posterPath) { [weak self] data in
                    self?.nowPlaying[indexPath.row].imageCover = data
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            
            cell.titleLabel.text = self.nowPlaying[indexPath.row].title
            cell.descriptionLabel.text = self.nowPlaying[indexPath.row].overview
            cell.ratingLabel.text = "\(self.nowPlaying[indexPath.row].voteAverage)"
            
            return cell
        case .popular:
            let movie = popular[indexPath.row]
            
            if let dataC = movie.imageCover, let imageC = UIImage(data: dataC) {
                cell.posterView.image = imageC
            }
            else{
                MovieDBService.fetchImage(posterPath: movie.posterPath) { [weak self] data in
                    self?.popular[indexPath.row].imageCover = data
                    
                    DispatchQueue.main.async {
                        self?.tableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            }
            cell.titleLabel.text = self.popular[indexPath.row].title
            cell.descriptionLabel.text = self.popular[indexPath.row].overview
            cell.ratingLabel.text = "\(self.popular[indexPath.row].voteAverage)"
            
            return cell
        }
    }
}
