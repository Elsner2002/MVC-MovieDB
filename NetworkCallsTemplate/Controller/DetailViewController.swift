import Foundation
import UIKit


class DetailController {
    var movie: Movie
    
    init(movie: Movie) {
        self.movie = movie
    }
    
    func fetchImage(_ cell: DetailsMovieCell, _ tableView: UITableView, indexPath: IndexPath) {
        if let dataC = movie.imageCover, let imageC = UIImage(data: dataC) {
            cell.posterView.image = imageC
        }
        else{
            MovieDBService.fetchImage(posterPath: movie.posterPath) { [weak self] data in
                self?.movie.imageCover = data
                
                DispatchQueue.main.async {
                    tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
    
    func movieInformations(_ cell: DetailsMovieCell) {
        cell.titleLabel.text = movie.getTitle()
        cell.tagsLabel.text = movie.getGenerID()
        cell.ratingsLabel.text = movie.getVote()
        cell.descriptionLabel.text = movie.getOverview()
    }
}
