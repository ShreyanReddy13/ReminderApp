//
//  TableViewController.swift
//  ReminderApp
//
//  Created by Prathima Juturu Chinna on 16/05/22.
//

import UIKit

class TableViewController: UITableViewController,AddItemTableViewControllerDelegate {
    
    
    var items: [CheckListItem] = []
    
        
    
    
    
    func addItemViewControllerDidCancel(_ controller: ViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: ViewController, didFinishAdding item: CheckListItem) {
        let newRowIndex = items.count
        items.append(item)
        
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func addItemViewController(_ controller: ViewController, didFinishEditing item: CheckListItem) {
        
        if let index = items.firstIndex(of: item) {
            let indexPath  = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
//    let stringArray = ["Task1","Task2","Task3","Task4","Task5","Task6"]
    override func viewDidLoad() {
        super.viewDidLoad()

    loadChecklistItems()
    }
    
    func documentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentDirectory().appendingPathExtension("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadChecklistItems() {
        let path = dataFilePath()
        
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            
            do {
                items = try decoder.decode([CheckListItem].self, from: data)
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    // MARK: - Table view data source
    private func configureCheckmark(
        for cell: UITableViewCell,
        with item: CheckListItem
    ) {
        let label = cell.viewWithTag(1001) as! UILabel
        if item.isChecked {
            
            label.text = "✔"
        } else {
            label.text = ""
        }
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Additem" {
            let controller = segue.destination as! ViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ViewController
            controller.delegate = self
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    private func configureText(
        for cell: UITableViewCell,
        with item: CheckListItem
    ) {
        let itemLabel = cell.viewWithTag(10) as! UILabel
        itemLabel.text = item.text
        
    }
   
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.toggleCheck()
            configureCheckmark(for: cell, with: item)
            
            saveChecklistItems()
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath)  {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            
            let indexPaths = [indexPath]
            tableView.deleteRows(at: indexPaths, with: .automatic)
            saveChecklistItems()
        }
        
    }
    
}
