//
//  MainViewControllerToDo.swift
//  TimeBreak 1
//
//  Created by Maria Madalena Teles on 1/15/17.
//  Copyright © 2017 Maria Madalena Teles. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class MainViewControllerToDo: UIViewController, UITableViewDataSource , UITableViewDelegate, UIGestureRecognizerDelegate{
    
    var categoryArray: Array<String> = Array()
    var categoryToPass = Category()
    var deleteCategoryIndexPath:IndexPath?
    var categories: [Category] = []
    @IBOutlet var WelcomeLabel: UILabel!
    @IBOutlet var MyCategoriesLabel: UILabel!
    @IBOutlet var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData() // fetch data in coredata
       
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        let height: CGFloat = 100
//        let bounds = self.navigationController!.navigationBar.bounds
//        self.navigationController?.navigationBar.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height + height)
        
        
        self.title = "Add a Category!"
    }
    
    // MARK: - TableView methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cellIdentifier = "categoryCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for:
                indexPath as IndexPath) as! CategoryTableViewCell
            let category = categories[indexPath.row]
            cell.categoryName?.text = category.name
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryToPass = categories[indexPath.row]
        performSegue(withIdentifier: "categorySegue", sender: self)
    }
    //delegate method: happens when the cell is swiped
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteCategoryIndexPath = indexPath //Here we assign the variable from step one to contain the value of the cell we want to delete.
            let categoryToDelete = categories[indexPath.row]
            self.confirmDelete(category: categoryToDelete.name!) //category name alone
            let context: NSManagedObjectContext = CoreDataStack.shared.context
            let index = indexPath.row
            context.delete(categories[index] as NSManagedObject) // deleting from context specific thing from cateories array
            let _ : NSError! = nil
            do {
                try context.save()
                self.tableView.reloadData()
            } catch {
                print("error: \(error)")
            }
        }
    }
    
    // MARK: - Methods to delete category //TO DO: customize swiping cell
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
            categories.remove(at: indexPath.row) //the action of deleting happens here
            tableView.deleteRows(at: [indexPath], with: .automatic)
            deleteCategoryIndexPath = nil
            tableView.endUpdates()
        }
    }
    
    //if the user cancel deleting the cell
    func cancelDeleteCategory(alertAction: UIAlertAction!) {
        deleteCategoryIndexPath = nil
    }
    
    //MARK: - Methods to fetch and save data
    func getData() {
        do {
            categories = try CoreDataStack.shared.context.fetch(Category.fetch)
        }
        catch { //TO DO: add an alert for the error
            print("Error fetching tasks")
        }
    }
    
    // MARK: - IBActions
    @IBAction func AddCategoryButtonTapped(_ sender: UIButton) {
        if categories.count > 0 {
            let alert = UIAlertController(title: "TimeBreak doesn't yet support multiple categories at this time.", message: "Multiple categories coming soon!", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Add Category", message: "Here you can type the name of your category.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addTextField { (textField) in
                textField.text = ""
            alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak alert] (_) in
                let textField = alert!.textFields![0] // Force unwrapping because we know it exists.
                if textField.text != "" {
                    self.categoryArray.append(textField.text!)
                    let newCategory = Category(context: CoreDataStack.shared.context)
                    newCategory.name = textField.text!
                    CoreDataStack.shared.saveContext() // data was saved
                    self.getData()
                }
                self.tableView.reloadData() 
            }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    } ///

    // MARK: - Navigation
    
      override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "categorySegue"){
            
            let destNavController = segue.destination as! UINavigationController
            let targetController = destNavController.topViewController as! ViewControllerToDoTask
            
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let selectedCategory = categories[indexPath.row]
                targetController.categoryPassed = selectedCategory
            }
        }
     }
    
    // MARK: - UI Controls

    @IBAction func mainButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
    
    @IBAction func infoButtonTapped(_ sender: UIButton) {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "menuCategoryInfoVC") as! CategoryInfoViewController
            
            vc.view.backgroundColor = .clear
            vc.modalPresentationStyle = .overCurrentContext
            
            self.present(vc, animated: false, completion: nil)

    }
}

extension Category {
    static var fetch: NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
}

extension UIViewController:UNUserNotificationCenterDelegate {
    
    //for displaying notification when app is in foreground
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert,.badge])
    }
    
    // For handling tap and user actions
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        switch response.actionIdentifier {
        case "action1":
            print("Action First Tapped")
        case "action2":
            print("Action Second Tapped")
        default:
            break
        }
        completionHandler()
    }
    
}
