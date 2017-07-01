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

class ViewControllerTimer: UIViewController {
    
    var taskName = ""
    var timeForTask = 0
    var seconds = 60
    var timer = Timer ()
    var isTimerRunning = false
    var resumeTapped = false
    var chosenTimeInterval: Int = 0 //This is now chosen Time Interval an integer value!
    var confettiView = SAConfettiView()

    
    @IBOutlet var taskLabel: UILabel!
    @IBOutlet var CountDownTimerLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    @IBOutlet var snoozeButton: UIButton!
    @IBOutlet var resetButton: UIButton!
    @IBOutlet var endButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Now we assign the chosen time interval to "seconds" and our timer can easily start counting down the seconds which is what the chosenTimeInterval represents!!
        seconds = chosenTimeInterval
        taskLabel.text = taskName
        CountDownTimerLabel.text = timeString(time: Double(chosenTimeInterval))
        startButton.layer.cornerRadius = 10.0
        startButton.layer.borderColor = UIColor.black.cgColor
        startButton.layer.borderWidth = 2
        endButton.layer.cornerRadius = 10.0
        endButton.layer.borderColor = UIColor.black.cgColor
        endButton.layer.borderWidth = 2
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
    @IBAction func BackButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
        confettiView.stopConfetti()
    }
    
    @IBAction func StartButtonTapped(_ sender: UIButton) {
        if isTimerRunning == false {
            runTimer(isTimerRunning = true)
            self.startButton.isEnabled = false
        }
    }
    
    @IBAction func PauseButtonTapped(_ sender: UIButton) {
        if self .resumeTapped == false {
            timer.invalidate()
            self.resumeTapped = true
        } else {
            runTimer()
            self.resumeTapped = false
        }
    }

    @IBAction func ResetButtonTapped(_ sender: UIButton) {
        timer.invalidate()
        seconds = chosenTimeInterval
        CountDownTimerLabel.text = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        self.snoozeButton.isEnabled = false
    }
    
    @IBAction func endButtonTapped(_ sender: UIButton) {
       taskFinished(alertAction: nil)
    }
    func taskFinished (alertAction: UIAlertAction!) {
        confettiView = SAConfettiView(frame: self.view.bounds)
        self.view.addSubview(confettiView)
        confettiView.type = .Confetti
        confettiView.colors = [UIColor.red, UIColor.green, UIColor.blue, UIColor.yellow, UIColor.purple ]
        confettiView.intensity = 1.0
        confettiView.startConfetti()
    }
}
