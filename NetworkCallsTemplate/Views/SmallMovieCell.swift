//
//  SmallMovieCell.swift
//  TableViewGA
//
//  Created by Marina De Pazzi on 24/05/23.
//

import UIKit

class SmallMovieCell: UITableViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.posterView.layer.masksToBounds = true
        self.posterView.contentMode = .scaleAspectFill
        self.posterView.layer.cornerRadius = 12
    }

}
