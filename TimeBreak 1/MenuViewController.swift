//
//  MenuViewController.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 5/30/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getStartedButton.layer.cornerRadius = 10.0
        getStartedButton.layer.borderColor = UIColor.black.cgColor
        getStartedButton.layer.borderWidth = 2
        settingsButton.layer.cornerRadius = 10.0
        settingsButton.layer.borderColor = UIColor.black.cgColor
        settingsButton.layer.borderWidth = 2
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
    }

    @IBAction func settingsButtonTapped(_ sender: UIButton) {
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
