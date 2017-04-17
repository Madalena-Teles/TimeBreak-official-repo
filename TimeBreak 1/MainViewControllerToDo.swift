//
//  MainViewControllerToDo.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 1/15/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit

class MainViewControllerToDo: UIViewController, UITableViewDataSource , UITableViewDelegate, UIGestureRecognizerDelegate, UIAlertController {
    
    var categoryArray: Array<String> = Array()
    var categoryToPass = ""
    
    @IBOutlet var WelcomeLabel: UILabel!
    
    @IBOutlet var MyCategoriesLabel: UILabel!
    
    @IBOutlet var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(MainViewControllerToDo.deleteCategory))
        tableView.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
    }
    
    func deleteCategory(recognizer: UITapGestureRecognizer){
        if recognizer.state == UIGestureRecognizerState.ended {
            let tapLocation = recognizer.location(in: self.tableView)
            if let tapIndexPath = self.tableView.indexPathForRow(at: tapLocation) {
                let indextoDelete = tapIndexPath.row
                self.categoryArray.remove(at:indextoDelete)
                tableView.reloadData()
            }
        
            }
        let alert = UIAlertController(title: "Are you sure you want to delete this category?", message: "With this", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "A thing", style: .default) { action in
            // perhaps use action.title here
            self.present(alert, animated: true)
        })
        
        }
    }

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
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        }
    }

      func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "categorySegue"){
            let destViewController = segue.destination as! ViewControllerToDoTask
        
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedCategory = categoryArray[indexPath.row]
                destViewController.categoryPassedName = selectedCategory
        
        }
    }
}


