//
//  MainViewControllerToDo.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 1/15/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class MainViewControllerToDo: UIViewController, UITableViewDataSource , UITableViewDelegate, UIGestureRecognizerDelegate{
    
    var categoryArray: Array<String> = Array()
    var categoryToPass = ""
    var deleteCategoryIndexPath:IndexPath?
    
    
    @IBOutlet var WelcomeLabel: UILabel!
    
    @IBOutlet var MyCategoriesLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    ///TableView methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cellIdentifier = "categoryCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:
                indexPath as IndexPath) as UITableViewCell
            cell.textLabel?.text = categoryArray[indexPath.row]
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        categoryToPass = categoryArray[indexPath.row]
        performSegue(withIdentifier: "categorySegue", sender: self)
    }
    //delegate method: happens when the cell is swiped
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategoryIndexPath = indexPath //Here we assign the variable from step one to contain the value of the cell we want to delete.
            let categoryToDelete = categoryArray[indexPath.row]
            self.confirmDelete(category: categoryToDelete)
        }
    }
    
    //methods to delete category
    //to send notification to confirm the deleting of cell
    
    func confirmDelete(category: String) {
        let alert = UIAlertController(title: "Delete category", message: "Are you sure you want to permanently delete this category?", preferredStyle: .actionSheet)
        
        let DeleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: self.handleDeleteCategory)
        let CancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: self.cancelDeleteCategory)
        
        alert.addAction(DeleteAction)
        alert.addAction(CancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    //which cell to delete method
    
    func handleDeleteCategory(alertAction: UIAlertAction!) -> Void {
        if let indexPath = deleteCategoryIndexPath {
            tableView.beginUpdates()
            categoryArray.remove(at: indexPath.row) //the action of deleting happens here
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
            deleteCategoryIndexPath = nil
            
            tableView.endUpdates()
        }

    }
    
    //if the user cancel deleting the cell
    func cancelDeleteCategory(alertAction: UIAlertAction!) {
        deleteCategoryIndexPath = nil
    }
    
    
    @IBAction func AddCategoryButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add Category", message: "Here you can type the name of your category.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.text = ""
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
            let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField.text!)")
            self.categoryArray.append(textField.text!)
            print("categoryArray: \(self.categoryArray)")
            self.tableView.reloadData() 
        }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)

    }
    }

      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "categorySegue"){
            let destViewController = segue.destination as! ViewControllerToDoTask
        
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedCategory = categoryArray[indexPath.row]
                destViewController.categoryPassedName = selectedCategory
        
            }
    }
}
}


