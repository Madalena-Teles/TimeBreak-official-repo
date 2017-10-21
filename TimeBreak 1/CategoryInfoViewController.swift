//
//  CategoryInfoViewController.swift
//  TimeBreak 1
//
//  Created by Jennifer A Sipila on 10/17/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class CategoryInfoViewController: UIViewController, UIViewControllerTransitioningDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissViewController(sender:)))
        self.view.addGestureRecognizer(tap)

    
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
