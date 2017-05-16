//
//  ViewControllerToDoTask.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 1/15/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit
import CoreData

// Receiving ViewController

class ViewControllerToDoTask: UIViewController, UITableViewDataSource , UITableViewDelegate, DataSentDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - variables
    var taskTimeToPass = 1800
    var nameToPass = ""
    var taskNameArray: Array<String> = Array()
    var taskTimeArray: Array<Int> = Array()
    var categoryPassed = Category()
    var timeValueArray: Array<Int> = Array()   // This changed to an array of Integers not Dates!
    var buttonRow: Int?
    var deleteTaskIndexPath:IndexPath?
    var tasks: Array<Task> = []

    //MARK: - IBOutlets
    @IBOutlet var tableView: UITableView!
    @IBOutlet var AddTaskLabel: UILabel!
    @IBOutlet var categoryName: UILabel!
    @IBOutlet var todaysDateLabel: UILabel!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
        categoryName.text = categoryPassed.name //unload category(backpack) and get the string
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        let result = formatter.string(from: date)
        todaysDateLabel.text = result
    }

    func getData(){
        do {
            tasks = try CoreDataStack.shared.context.fetch(Task.fetch) //TO DO: fix fetch issue
        }
        catch { //TO DO: add an alert for the error
            print("Error fetching tasks")
        }
    }
    
    // MARK: - TableView Delegate Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskNameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cellIdentifier = "toDoCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:
                indexPath as IndexPath) as! TaskTableViewCell
            let task = tasks[indexPath.row]
            cell.taskLabel?.text = task.name
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
    
    // MARK: - TableView Deleting task Methods
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTaskIndexPath = indexPath //Here we assign the variable from step one to contain the value of the cell we want to delete.
            let taskToDelete = taskNameArray[indexPath.row]
            self.confirmDelete(task: taskToDelete)
            let context: NSManagedObjectContext = CoreDataStack.shared.context
            let index = indexPath.row
            context.delete(tasks[index] as NSManagedObject) // deleting from context specific thing from tasks array
            let _ : NSError! = nil
            do {
                try context.save()
                self.tableView.reloadData()
            } catch {
                print("error: \(error)")
            }

        }
    }
    
    func confirmDelete(task: String) {
        let alert = UIAlertController(title: "Delete category", message: "Are you sure you want to permanently delete this task?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteTask)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.handleDeleteTask)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func handleDeleteTask(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteTaskIndexPath {
            tableView.beginUpdates()
            taskNameArray.remove(at: indexPath.row) //It removes the corresponding item from the array here in this line!!!!
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteTaskIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    func cancelDeleteTask(alertAction: UIAlertAction!) {
        deleteTaskIndexPath = nil
    }

    
    //MARK: - Delegate Methods
    
    func userDidEnterTaskName(taskName: String) {
        taskNameArray.append(taskName)
        tableView.reloadData()
    }
    
    func userDidEnterChosenTimeInterval(chosenTimeInterval: Int) { //This method is now receiving an integer!!
        timeValueArray.append(chosenTimeInterval) //This now sends the seconds(which is an integer) to an array of integers!
    }
    
    //MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func AddTaskButtonTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "addTaskButton", sender: self)

    }

    //MARK: - Navigation
    
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
                let selectedTimeInterval = timeValueArray[buttonRow!]
                destViewController.chosenTimeInterval = selectedTimeInterval
        }
        if (segue.identifier == "editTask"){
            let destViewController = segue.destination as! ViewControllerAddTask
            destViewController.delegate = self
            }
        }
    }
}

