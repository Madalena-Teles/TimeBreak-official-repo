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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(dismissViewController(sender:)))
        self.view.addGestureRecognizer(tap)

//        navigationController?.navigationBar.setBackgroundImage(UIImage.new for: UIBarMetrics.default)
//        navigationController?.navigationBar.isTranslucent = true
//        navigationController?.navigationBar.shadowImage = UIImage.init(named: <#T##String#>)
        

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.modalPresentationStyle = UIModalPresentationStyle.custom
        self.transitioningDelegate = self
    }
    
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//    
//        let presentationController = UIPresentationController.init(presentedViewController: presented, presenting: presenting)
//        
//        presentationController.presentationStyle =  UIModalPresentationStyle.overCurrentContext
//        
//        return presentationController
//    }
//    
    

    
//    - (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
//    {
//    return [[LargeFormatPresentation alloc] initWithPresentedViewController:presented presentingViewController:presenting];
//    }
    
    // MARK: - Navigation
    
    func dismissViewController(sender : UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

}


 


