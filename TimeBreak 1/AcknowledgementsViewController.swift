//
//  AcknowledgementsViewController.swift
//  TimeBreak 1
//
//  Created by Jennifer A Sipila on 10/21/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class AcknowledgementsViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundView.layer.cornerRadius = 10
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}
