//
//  InfoViewController.swift
//  TimeBreak 1
//
//  Created by Jennifer A Sipila on 10/17/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class InfoViewController: UIViewController, UIViewControllerTransitioningDelegate {

//    var dimmingView: UIView
    
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissViewController(sender:)))
        self.view.addGestureRecognizer(tap)

    }
    
    func prepareUI() {
        backgroundView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
    }
    
    // MARK: - Navigation
    
    func dismissViewController(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}


 


