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

        
    }
    
    @IBAction func getStartedButtonTapped(_ sender: UIButton) {
    }

    @IBAction func settingsButtonTapped(_ sender: UIButton) {
    }
    
    //This is how to get the info vc to float over the menu vc.
    @IBAction func infoButtonTapped(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "menuInfoVC") as! InfoViewController
        
        vc.view.backgroundColor = .clear
        vc.modalPresentationStyle = .overCurrentContext
        
        self.present(vc, animated: false, completion: nil)
        
        
//        let vc =
//            storyboard?.instantiateInitialViewController() as! InfoViewController
//        vc.view.backgroundColor = .clear
//        vc.modalPresentationStyle = .overCurrentContext
//        
//        self.present(vc, animated: true, completion: nil)
        
//        MenuViewController.presentViewController(vc, animated: true, completion: nil)
        
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
