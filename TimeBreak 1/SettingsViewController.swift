//
//  SettingsViewController.swift
//  TimeBreak 1
//
//  Created by Jennifer A Sipila on 10/8/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    
    @IBOutlet weak var notifsSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    
    
    @IBAction func notifsSwitchTapped(_ sender: UISwitch) {
        
        //Finish notification settings.
    }
    
    

    @IBAction func acknowTapped(_ sender: UIButton) {
        
        
    }

    

    @IBAction func contactTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func shareTapped(_ sender: UIButton) {
    }
    
    
    @IBAction func backArrowTapped(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    
    
//    - (void) shareArticle:(NSString *)articleURL {
//    NSArray *items;
//    NSString *articleLink = [NSString stringWithFormat: @"Check out this awesome article I found on Nezz! %@", articleURL];
//    items = @[articleLink];
//    UIActivityViewController *controller = [[UIActivityViewController alloc]initWithActivityItems:items applicationActivities:nil];
//    [controller setValue:@"Article you might like from Nezz!" forKey:@"subject"];
//    controller.excludedActivityTypes = @[UIActivityTypeOpenInIBooks, UIActivityTypeAddToReadingList, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypePostToWeibo];
//    //check ipad
//    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//    //ios > 8.0
//    if ([controller respondsToSelector:@selector(popoverPresentationController)]) {
//    controller.popoverPresentationController.sourceView =
//    self.view;
//    }
//    }
//    [self presentViewController: controller animated:false completion:nil];
//    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}