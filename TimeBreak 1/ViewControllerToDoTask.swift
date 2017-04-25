//
//  ViewControllerToDoTask.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 1/15/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

// Receiving ViewController

class ViewControllerToDoTask: UIViewController, UITableViewDataSource , UITableViewDelegate, DataSentDelegate, UIGestureRecognizerDelegate {
    
    var taskTimeToPass = 1800
    var nameToPass = ""
    var taskNameArray: Array<String> = Array()
    var taskTimeArray: Array<Int> = Array()
    var categoryPassedName:String = String()
    var timeValueArray: Array<Int> = Array()   // This changed to an array of Integers not Dates!
    var buttonRow: Int?
    var deleteTaskIndexPath:IndexPath?

    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var AddTaskLabel: UILabel!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var todaysDateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        categoryName.text = categoryPassedName
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let result = formatter.string(from: date)
        todaysDateLabel.text = result
    }

    // TableView Delegate Methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cellIdentifier = "toDoCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:
                indexPath as IndexPath) as! TaskTableViewCell
            cell.taskLabel.text = taskNameArray[indexPath.row]
            cell.timerButton.tag = indexPath.row
            cell.timerButton.addTarget(self, action: #selector(self.timerButtonTapped), for: .touchUpInside)
            return cell
    }
    
    func timerButtonTapped(sender:UIButton) {
        self.buttonRow = sender.tag
        let timerVC = storyboard?.instantiateViewController(withIdentifier: "timerVC") as! ViewControllerTimer
        timerVC.taskName = taskNameArray[buttonRow!]
        timerVC.chosenTimeInterval = timeValueArray[buttonRow!] 
        self.present(timerVC, animated:true, completion:nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.buttonRow = tableView.indexPathForSelectedRow?.row
        nameToPass = taskNameArray[indexPath.row]
        performSegue(withIdentifier: "editTask", sender: self)
    }
    
    // Delegate Methods
    
    func userDidEnterTaskName(taskName: String) {
        taskNameArray.append(taskName)
        tableView.reloadData()
    }
    
    func userDidEnterChosenTimeInterval(chosenTimeInterval: Int) { //This method is now receiving an integer!!
        timeValueArray.append(chosenTimeInterval) //This now sends the seconds(which is an integer) to an array of integers!
    }
    
    //Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func AddTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addTaskButton", sender: self)

    }
    
    //@IBAction func deleteTaskTapped(_ sender: UIButton) {}
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                deleteTaskIndexPath = indexPath //Here we assign the variable from step one to contain the value of the cell we want to delete.
                let taskToDelete = taskNameArray[indexPath.row]
                self.confirmDelete(task: taskToDelete)
            }
        }
        func confirmDelete(task: String) { //ADD THIS WHOLE FUNCTION
            let alert = UIAlertController(title: "Delete category", message: "Are you sure you want to permanently delete this task?", preferredStyle: .actionSheet)
            
            let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteTask)
            let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.handleDeleteTask)
            
            alert.addAction(DeleteAction)
            alert.addAction(CancelAction)
            
            self.present(alert, animated: true, completion: nil)
        }
        
        func handleDeleteTask(alertAction: UIAlertAction!) -> Void {  //ADD THIS WHOLE FUNCTION
            if let indexPath = deleteTaskIndexPath {
                tableView.beginUpdates()
                taskNameArray.remove(at: indexPath.row) //It removes the corresponding item from the array here in this line!!!!
                
                tableView.deleteRows(at: [indexPath], with: .automatic)
                
                deleteTaskIndexPath = nil
                
                tableView.endUpdates()
            }
        }
        
        func cancelDeleteTask(alertAction: UIAlertAction!) { //ADD THIS WHOLE FUNCTION
            deleteTaskIndexPath = nil
        }


    
    
    
    
    //Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "addTaskButton"){
            let destViewController = segue.destination as! ViewControllerAddTask
            destViewController.delegate = self
        }
        
        if (segue.identifier == "timerIcon"){
            
            let destViewController = segue.destination as! ViewControllerTimer
            if buttonRow != nil {
                let selectedTask = taskNameArray[buttonRow!]
                destViewController.taskName = selectedTask
                let selectedTimeInterval = timeValueArray[buttonRow!] //This had to change to be timeValueArray[indexPath.row].
                destViewController.chosenTimeInterval = selectedTimeInterval  //This had to change to be time interval
        }
        
        if (segue.identifier == "editTask"){
            let destViewController = segue.destination as! ViewControllerAddTask
            destViewController.delegate = self
            }
            
        }
    }
}

