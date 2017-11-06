//
//  ViewControllerTimer.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 1/15/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit
import CoreData
import SAConfettiView
import UserNotifications

class ViewControllerTimer: UIViewController {
    
    var tasks: Array<Task> = []
    var passedRow: Int?
    var taskName = ""
    var timeForTask = 0
    var seconds = 60
    var timer = Timer ()
    var isTimerRunning = false
    var resumeTapped = false
    var chosenTimeInterval: Int = 0 //This is now chosen Time Interval an integer value!
    var confettiView = SAConfettiView()
    var isPaused: Bool = false
    
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var CountDownTimerLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var snoozeButton: UIButton!
    @IBOutlet var endButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
        //Now we assign the chosen time interval to "seconds" and our timer can easily start counting down the seconds which is what the chosenTimeInterval represents!!
        seconds = chosenTimeInterval
        taskLabel.text = taskName
        CountDownTimerLabel.text = timeString(time: Double(chosenTimeInterval))
        
        snoozeButton.isEnabled = false
        endButton.isEnabled = false
        pauseButton.isEnabled = false
        
        UNUserNotificationCenter.current().delegate = self
        
        
        getData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getData()
        
        let task = tasks[passedRow!]
        
        task.setValue(Int64(seconds), forKey: "timeInSeconds")  //Update this to be most recent time interval!!!
        

//        CoreDataStack.shared.saveContext()
    }
    
    func getData(){
        do {
            tasks = try CoreDataStack.shared.context.fetch(Task.fetch) //TO DO: fix fetch issue
        }
        catch { //TO DO: add an alert for the error
            print("Error fetching tasks")
        }
    }
    
    //MARK: - UI Preparation
    
    func prepareUI() {
        startButton.layer.cornerRadius = 10.0
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 2
        endButton.layer.cornerRadius = 10.0
        endButton.layer.borderColor = UIColor.black.cgColor
        endButton.layer.borderWidth = 2
        snoozeButton.layer.cornerRadius = 10.0
        snoozeButton.layer.borderColor = UIColor.black.cgColor
        snoozeButton.layer.borderWidth = 2
        snoozeButton.layer.cornerRadius = 10.0
        snoozeButton.layer.borderColor = UIColor.black.cgColor
        snoozeButton.layer.borderWidth = 2
    }
    
    //MARK: - method running timer
    func runTimer() {
        seconds = chosenTimeInterval
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewControllerTimer.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
        self.snoozeButton.isEnabled = true
    }
    
    //MARK: - TableView updating timer
    func updateTimer(){
        if seconds < 1 {
            timer.invalidate(timerCompleteAlert())
            scheduleNotifications()
        } else {
            seconds -= 1
            CountDownTimerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    func timerCompleteAlert() {
        let alert = UIAlertController(title: "Time is up!", message: "Did you complete your task?", preferredStyle: .actionSheet)
        let YesAction = UIAlertAction(title: "Yes, the task is completed", style: .destructive, handler: self.taskFinished)
        let NoAction = UIAlertAction(title: "No, I need more time", style: .cancel, handler: self.addAdditionalTime)
        alert.addAction(YesAction)
        alert.addAction(NoAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func addAdditionalTime(alertAction: UIAlertAction!) {
        seconds = 900
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewControllerTimer.updateTimer)), userInfo: nil, repeats: true)
        isTimerRunning = true
    }
    
    func updateAdditionalTimer(alertAction: UIAlertAction!) {
        if seconds < 1 {
            timer.invalidate()
        } else {
            seconds -= 1
            CountDownTimerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }

    //MARK: - method for converting time
    func timeString(time:TimeInterval) -> String {
        let Hours = Int(time) / 3600
        let Minutes = Int(time) / 60 % 60
        let Seconds = Int(time) % 60
        return String(format: "%02i:%02i:%02i", Hours, Minutes, Seconds)
    }
    
    //MARK: - IBActions
    
    @IBAction func StartButtonTapped(_ sender: UIButton) {
        snoozeButton.isEnabled = true
        endButton.isEnabled = true
        pauseButton.isEnabled = true
        
        if isTimerRunning == false {
            runTimer(isTimerRunning = true)
            self.startButton.isEnabled = false
        }
    }
    
    @IBAction func snoozeButtonTapped(_ sender: UIButton) {
        alertForSnooze()
        if self .resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
        } else {
            runTimer()
            self.resumeTapped = false
        }
    }
    
    @IBAction func endButtonTapped(_ sender: UIButton) {
        taskFinished(alertAction: nil)
        timer.invalidate()
    }
    
    @IBAction func pauseButtonTapped(_ sender: UIButton) {
        if isPaused == false {
            timer.invalidate()
            isPaused = true
        } else {
            runTimer()
            isPaused = false
        }
    }
    
    @IBAction func BackButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
        confettiView.stopConfetti()
        getData()
        
        let task = tasks[passedRow!]
        
        task.setValue(Int64(seconds), forKey: "timeInSeconds")  //Update this to be most recent time interval!!!
        
    }

    func taskFinished (alertAction: UIAlertAction!) {

        confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.type = .Confetti
        confettiView.colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.purple ]
        confettiView.intensity = 1.0
        confettiView.startConfetti()
        
        perform(#selector(stopConfetti), with: self, afterDelay: 2)
        
        alertForCompletion()
    }
    
    func stopConfetti () {
        confettiView.stopConfetti()
    }
    
    //MARK: - Alerts
    
    //Alert for Snoozing.
    
    func alertForSnooze() {
        let alertController = UIAlertController(title: "Do you need more time?", message: "Add 15 minutes.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            self.chosenTimeInterval = self.chosenTimeInterval + 900

            self.runTimer()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) {
            UIAlertAction in
            
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Alert for Task Complete.
    
    func alertForCompletion() {
        let alertController = UIAlertController(title: "Congratulations!!", message: "You finished your task.", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) {
            UIAlertAction in
            
            let task = self.tasks[self.passedRow!]
            task.setValue(true, forKey: "completed")
            self.dismiss(animated: true, completion: nil)
            
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    //MARK: Notifications
    
    func scheduleNotifications() {
        
        let content = UNMutableNotificationContent()
        let requestIdentifier = "timeUp"
        
        content.badge = 1
        content.title = "TimeBreak Time Up!"
        content.subtitle = ""
        content.body = "Did you finish your task?"
        content.categoryIdentifier = "actionCategory"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 3.0, repeats: false)
        
        let request = UNNotificationRequest(identifier: requestIdentifier, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error:Error?) in
            
            if error != nil {
                print(error?.localizedDescription as Any)
            }
            print("Notification Register Success")
        }
    }
}
