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
    
    var mainController = MainController()
    
    //MARK: View loading methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainController.apiCall(tableView)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.shared.segueID,
           let movie = sender as? Movie {
            let destination = segue.destination as! DetailsViewController
            
            destination.detailController = DetailController(movie: movie)
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.performSegue(withIdentifier: Constants.shared.segueID, sender: mainController.chooseSection(indexPath))
    }
}

//MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainController.getSections().count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mainController.getSections()[section].value
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        
        header.contentConfiguration = mainController.setContent(header, section: section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainController.sectionCount(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.shared.movieCellID, for: indexPath) as! SmallMovieCell
        
        mainController.movieInRow(cell: cell, indexPath, self.tableView)
        
        return cell
    }
}
