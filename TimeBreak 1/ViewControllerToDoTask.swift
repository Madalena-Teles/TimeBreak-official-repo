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

class ViewControllerToDoTask: UIViewController, UITableViewDataSource , UITableViewDelegate, UIGestureRecognizerDelegate {
    
    //MARK: - variables
    var taskTimeToPass = 1800
    var taskToPass: Task?
    //var taskNameArray: Array<String> = Array()
    //var taskTimeArray: Array<Int> = Array()
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
        tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        getData()
        self.tableView.reloadData()
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
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cellIdentifier = "toDoCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:
                indexPath as IndexPath) as! TaskTableViewCell
            let task = tasks[indexPath.row]
            getData()
            if task.completed == true {
                cell.taskLabel.textColor = UIColor.gray
                cell.timerButton.isEnabled = false
                cell.selectionStyle = UITableViewCellSelectionStyle.none
//                cell.isUserInteractionEnabled = false
            }
            cell.taskLabel?.text = task.name
            cell.timerButton.tag = indexPath.row
            cell.timerButton.addTarget(self, action: #selector(self.timerButtonTapped), for: .touchUpInside)
            return cell
    }
    
    //Did Select Row.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        getData()
        self.buttonRow = tableView.indexPathForSelectedRow?.row
        taskToPass = tasks[indexPath.row]
        if taskToPass?.completed == true {
            //Do nothing.
        } else {
           performSegue(withIdentifier: "editTask", sender: self)
        }
        
    }
    
    // MARK: - TableView Deleting task Methods
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteTaskIndexPath = indexPath //Here we assign the variable from step one to contain the value of the cell we want to delete.
            let taskToDelete = tasks[indexPath.row]
            self.confirmDelete(task: taskToDelete, index:indexPath.row)
            
            
            
            
        }

           }
    
    func deleteFromContext(index:Int, alertAction: UIAlertAction!) -> Void {
        let context: NSManagedObjectContext = CoreDataStack.shared.context
        context.delete(tasks[index] as NSManagedObject) // deleting from context specific thing from tasks array
        let _ : NSError! = nil
        do {
            try context.save()
            getData()
            self.tableView.reloadData()
        } catch {
            print("error: \(error)")
        }
    }
    
    //MARK: - Helper Methods
    
    func timerButtonTapped(sender:UIButton) {
        self.buttonRow = sender.tag
        let timerVC = storyboard?.instantiateViewController(withIdentifier: "timerVC") as! ViewControllerTimer
        timerVC.passedRow = self.buttonRow
        timerVC.taskName = tasks[buttonRow!].name!
        timerVC.chosenTimeInterval = Int(tasks[buttonRow!].timeInSeconds)
        self.present(timerVC, animated:true, completion:nil)
    }
    
    func confirmDelete(task: Task, index: Int) {
        let alert = UIAlertController(title: "Delete category", message: "Are you sure you want to permanently delete this task?", preferredStyle: .actionSheet)
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive) {actio
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler:self.deleteFromContext(index:index, alertAction: <#UIAlertAction!#>))
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
//    func handleDeleteTask(alertAction: UIAlertAction!) -> Void {
//        if let indexPath = deleteTaskIndexPath {
//            tableView.beginUpdates()
//            tasks.remove(at: indexPath.row) //It removes the corresponding item from the array here in this line!!!!
//            tableView.deleteRows(at: [indexPath], with: .automatic)
//            deleteTaskIndexPath = nil
//            tableView.endUpdates()
//        }
//    }
    
    func cancelDeleteTask(alertAction: UIAlertAction!) {
        deleteTaskIndexPath = nil
    }

    //MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func logoTapped(_ sender: UIButton) {
        self.presentingViewController!.presentingViewController!.dismiss(animated:true, completion: nil)
    }
    
    @IBAction func AddTaskButtonTapped(_ sender: UIButton) {
//        performSegue(withIdentifier: "addTaskButton", sender: self)

    }

    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //if (segue.identifier == "addTaskButton"){
            //let destViewController = segue.destination as! ViewControllerAddTask
            //destViewController.delegate = self
        //}
        
        if segue.identifier == "editTask" {
            let destViewController = segue.destination as! ViewControllerAddTask
            //            destViewController.delegate = self
            
            destViewController.passedTask = taskToPass
            
        }
    
        if segue.identifier == "timerIcon" {
            let destViewController = segue.destination as! ViewControllerTimer
            if buttonRow != nil {
                let selectedTask = tasks[buttonRow!].name!
                destViewController.taskName = selectedTask
                let selectedTimeInterval = timeValueArray[buttonRow!]
                destViewController.chosenTimeInterval = selectedTimeInterval
            }
        }
    }
}

extension Task {
    static var fetch: NSFetchRequest<Task>{
        return NSFetchRequest<Task>(entityName: "Task")
    }
}
