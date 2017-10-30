//
//  SettingsViewController.swift
//  TimeBreak 1
//
//  Created by Jennifer A Sipila on 10/8/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController, MFMailComposeViewControllerDelegate {

    
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
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
    mailComposerVC.setToRecipients(["timebreakcontactus@gmail.com"])
    
        mailComposerVC.setSubject("TimeBreak Contact")
        mailComposerVC.setMessageBody("<Please write how we can best help you below.>", isHTML: false)
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }

    
    @IBAction func shareTapped(_ sender: UIButton) {
        shareUrl(message: "Time break is a new app that will help you manage your time!", emailSubject: "Check out TimeBreak!")
    }
    
    @IBAction func rateTapped(_ sender: UIButton) {
        rateApp(completion: { (complete) in
            print("success")
        })
    }
    
    @IBAction func backArrowTapped(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    //Share App.
    func shareUrl(message: String, emailSubject: String) {
        let items = [ message ]
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.setValue(emailSubject, forKey: "Subject")
        activityViewController.excludedActivityTypes = [ UIActivityType.openInIBooks,
                                                         UIActivityType.addToReadingList,
                                                         UIActivityType.print,
                                                         UIActivityType.assignToContact,
                                                         UIActivityType.postToTencentWeibo]
        
        self.present(activityViewController, animated: true, completion: nil)
    }

    
    //Rate App.
    func rateApp(completion: @escaping ((_ success: Bool)->())) {
        
        let appId = "1303942214" //FILL IN APP ID FROM APP STORE.
        
        guard let url = URL(string : "itms-apps://itunes.apple.com/app/" + appId) else {
            completion(false)
            return
        }
        guard #available(iOS 10, *) else {
            completion(UIApplication.shared.openURL(url))
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: completion)
    }
}
