//
//  ViewController.swift
//  ReminderApp
//
//  Created by Prathima Juturu Chinna on 18/05/22.
//
import UIKit


protocol AddItemTableViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(_ controller: ViewController)
    func addItemViewController(_ controller: ViewController, didFinishAdding item: CheckListItem)
    func addItemViewController(_ controller: ViewController, didFinishEditing item: CheckListItem)
}

class ViewController: UIViewController, UITextFieldDelegate {
    @IBAction func cancel(_ sender: Any) {
//        navigationController?.popViewController(animated: true)
        delegate?.addItemViewControllerDidCancel(self)
    }
    weak var delegate: AddItemTableViewControllerDelegate?
   
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBAction func done(_ sender: UIBarButtonItem) {
//        navigationController?.popViewController(animated: true)
        if let itemToEdit = itemToEdit {
            itemToEdit.text = textField.text!
            delegate?.addItemViewController(self, didFinishEditing: itemToEdit)
            
        } else {
            let item = CheckListItem()
            item.text = textField.text!
            item.isChecked = false
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
    }
    
    @IBOutlet weak var textField: UITextField!
    var itemToEdit: CheckListItem?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        doneButton.isEnabled = false
        
  
        if let itemToEdit = itemToEdit {
            title = "Edit item"
            textField.text = itemToEdit.text
            doneButton.isEnabled = true
       }
    

}
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        doneButton.isEnabled = !newText.isEmpty
        
        return true
    }
}
