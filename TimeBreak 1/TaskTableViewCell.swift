//
//  TaskTableViewCell.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 3/7/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class TaskTableViewCell: UITableViewCell {

    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet var taskLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    //MARK: IBActions
    @IBAction func timerButtonTapped(_ sender: UIButton) {
        
    }
    
    

}
