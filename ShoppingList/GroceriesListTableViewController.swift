//
//  GroceriesListTableViewController.swift
//  ShoppingList
//
//  Created by Uldis Zingis on 07/10/16.
//  Copyright © 2016 Uldis Zingis. All rights reserved.
//

import UIKit
import CoreData

class GroceriesListTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, GroceryTableViewCellDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GroceriesController.sharedController.fetchResultsController.delegate = self
    }
    
    func getGrocery(at: IndexPath) -> Grocery {
        let fetchResultsController = GroceriesController.sharedController.fetchResultsController
        return fetchResultsController.object(at: at)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return GroceriesController.sharedController.fetchResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let fetchResultsController = GroceriesController.sharedController.fetchResultsController
        return fetchResultsController.sections?[section].name
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let fetchResultsController = GroceriesController.sharedController.fetchResultsController
        return fetchResultsController.sections?[section].numberOfObjects ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groceryCell", for: indexPath) as? GroceryTableViewCell else { return UITableViewCell() }
        
        cell.delegate = self
        cell.updateWithGrocery(grocery: getGrocery(at: indexPath))

        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            GroceriesController.sharedController.delete(grocery: getGrocery(at: indexPath))
        }
    }
    
    func presentAlert(){
        // 1. Create alert controller
        let alertController = UIAlertController(title: "New grocery", message: "", preferredStyle: .alert)
        // 2. Add text fields to alert
        var grocNameField = UITextField()
        var grocCategoryField: UITextField?
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            grocNameField = textField
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Category"
            grocCategoryField = textField
        }
        // 3. Create alert actions
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            guard let name = grocNameField.text else { return }
            let category = grocCategoryField?.text ?? ""
            GroceriesController.sharedController.create(name: name, category: category)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // 4. Add actions to alert controller
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        // 5. Present the alert controller
        self.present(alertController, animated: true, completion: nil)
    }

    @IBAction func addButtonTapped(_ sender: AnyObject) {
        presentAlert()
    }
    
    func cellCheckboxButtonTapped(sender: GroceryTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        GroceriesController.sharedController.updateCompleteness(grocery: getGrocery(at: indexPath))
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }
            tableView.deleteRows(at: [indexPath], with: .fade)
        case .insert:
            guard let newIndexPath = newIndexPath else { return }
            tableView.insertRows(at: [newIndexPath], with: .fade)
        case .update:
            guard let indexPath = indexPath else { return }
            tableView.reloadRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .delete:
            tableView.deleteSections([sectionIndex], with: .bottom)
        case .insert:
            tableView.insertSections([sectionIndex], with: .top)
        default:
            break
        }
    }
}
