//
//  CategoryTableViewCell.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 4/4/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet var categoryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
