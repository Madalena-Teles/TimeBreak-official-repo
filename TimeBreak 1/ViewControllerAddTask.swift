//
//  ViewControllerAddTask.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 1/15/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit
import CoreData

//Sending ViewController

class ViewControllerAddTask: UIViewController {
    
    var chosenDate = TimeInterval()
    //var delegate: DataSentDelegate?
    
    @IBOutlet var myTaskTextField: UITextField!
    @IBOutlet var StartingDateOfTaskTextField: UITextField!
    @IBOutlet var DueDateOfTaskTextField: UITextField!
    @IBOutlet var TimeForCompletionLabel: UILabel!
    @IBOutlet var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chosenDate = datePicker.countDownDuration
    }
    
    // MARK: - IBActions- what happens when the add task button is tapped- all the things in that page
    @IBAction func AddTaskButtonTapped(_ sender: UIButton) {
        //if delegate != nil {
            if myTaskTextField.text != "" {
                let newTask = Task(context: CoreDataStack.shared.context)
                newTask.name = myTaskTextField.text!
                
                let chosenDate = datePicker.date
                let calendar = Calendar.current
                let hours = calendar.component(.hour, from: chosenDate)
                let minutes = calendar.component(.minute, from: chosenDate)
                let hoursToMinutes = hours * 60
                let totalTimeInMinutes = hoursToMinutes + minutes
                let secondsTimeInterval = totalTimeInMinutes * 60
                
                
                newTask.time = Int64(secondsTimeInterval)
                CoreDataStack.shared.saveContext() // data was saved
            }
            
           // if let taskName = myTaskTextField.text {
               // print(myTaskTextField.text!)
                
                //delegate?.userDidEnterTaskName(taskName: taskName) //This is where the passing starts/happens.
                //dismiss(animated: true, completion: nil)
            //}
            
            //Here we get the calendar components from the date picker. In our case we have hours and minutes.
        
        
            //This prints the amount of hours and minutes the user chooses.
            //print(hours)
            //print(minutes)
        
            //We then convert these hours and minutes to total value of seconds.
            //This will come in handy when we want to start our timer. So we do the conversion here and then pass the seconds value to the To Do View Controller and then to the Timer View Controller.


            
            //self.delegate?.userDidEnterChosenTimeInterval(chosenTimeInterval: secondsTimeInterval)
            self.dismiss(animated: true, completion: nil)
  
        }
    //}
    
    @IBAction func CancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func gestureTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
