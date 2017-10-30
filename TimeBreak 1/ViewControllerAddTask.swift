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
    
    var passedTask: Task?
    
    @IBOutlet var myTaskTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var TimeForCompletionLabel: UILabel!
    
    @IBOutlet var StartingDateOfTaskTextField: UITextField!
    @IBOutlet var DueDateOfTaskTextField: UITextField!
    
    @IBOutlet weak var startPickerBackground: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startDatePicker.minimumDate = Date()
        
        chosenDate = datePicker.countDownDuration
        if passedTask != nil {
            self.title = "Edit your Task!"
            if let name = passedTask?.name {
                myTaskTextField.text = name
            }
            if let startDate = passedTask?.startDate {
                startDatePicker!.date = startDate as Date
            } else {
                startDatePicker!.date = Date()
            }
        }
    }
    
    //MARK: - UI Preparation
    
    func prepareUI() {
        startPickerBackground.layer.cornerRadius = 10

        let whiteColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 250.0/255.0, alpha: 0.5 )
        
        startDatePicker.layer.backgroundColor = whiteColor.cgColor
    
        startDatePicker.layer.cornerRadius = 10
        
    }
    
    //MARK: - UI Controls
    
    @IBAction func AddTaskButtonTapped(_ sender: UIButton) {
        if myTaskTextField.text != "" && StartingDateOfTaskTextField.text != "" {
            
            if passedTask != nil {
                deleteEditedTask(task:passedTask!)
            }
            
            let newTask = Task(context: CoreDataStack.shared.context)
            newTask.name = myTaskTextField.text!
            
            let chosenDate = datePicker.date
            let calendar = Calendar.current
            let hours = calendar.component(.hour, from: chosenDate)
            let minutes = calendar.component(.minute, from: chosenDate)
            let hoursToMinutes = hours * 60
            let totalTimeInMinutes = hoursToMinutes + minutes
            let secondsTimeInterval = totalTimeInMinutes * 60
            
            newTask.timeInSeconds = Int64(secondsTimeInterval)
            newTask.startDate = startDatePicker.date as NSDate
            
            CoreDataStack.shared.saveContext() // data was saved
            
            //TO DO: Set up local notification for start time.
            
            navigationController?.popViewController(animated: true)
            
        } else {
            infoIncompleteAlert()
        }
    }
    
    func infoIncompleteAlert() {
        let alert = UIAlertController(title: "Missing Information", message: "Please make sure to add a name, start time and duration.", preferredStyle: .actionSheet)
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }

    func deleteEditedTask(task:Task) {
        let context: NSManagedObjectContext = CoreDataStack.shared.context
        context.delete(task as NSManagedObject)
        let _ : NSError! = nil
        do {
            try context.save()
        } catch {
            print("error: \(error)")
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func CancelButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func gestureTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

