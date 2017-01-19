//
//  GenreTableViewCell.swift
//  MangaOtaku
//
//  Created by Vox Long on 1/19/17.
//  Copyright © 2017 Vox Long. All rights reserved.
//

import UIKit

class GenreTableViewCell: UITableViewCell {

    @IBOutlet weak var cellLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellLabel.text = nil
    }
    
    struct constants {
        static let identifier = "GenreTableViewCell"
        static let height : CGFloat = 44
        static let name = "GenreTableViewCell"
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
