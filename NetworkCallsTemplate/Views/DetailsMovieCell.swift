//
//  DetailsMovieCell.swift
//  TableViewGA
//
//  Created by Marina De Pazzi on 25/05/23.
//

import UIKit

class DetailsMovieCell: UITableViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var ratingsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
     
        self.posterView.layer.masksToBounds = true
        self.posterView.contentMode = .scaleAspectFill
        self.posterView.layer.cornerRadius = 12
        
    }
}
