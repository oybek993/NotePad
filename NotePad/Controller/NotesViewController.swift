//
//  NotesViewController.swift
//  NotePad
//
//  Created by Oybek on 2/8/21.
//

import UIKit
import CoreData
class NotesViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundView = UIImageView(image: UIImage(named: "bg"))
        loadItems()
        //print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    var noteArray = [Note]()
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var row = 0
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return noteArray.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "items", for: indexPath)
        cell.textLabel?.text = noteArray[indexPath.row].title
        cell.backgroundColor = .clear
        return cell
    }
    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        row = indexPath.row
        print(row)
        performSegue(withIdentifier: "itemToNote", sender: self)
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! EditorViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedNote = noteArray[indexPath.row]
            destinationVC.row = row
        }
        
    }
    
    // MARK: - add Button
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add Notes", message: "", preferredStyle: .alert)
        var textField = UITextField()
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Type something"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            let newItem = Note(context: self.context)
            newItem.title = textField.text!
            self.noteArray.append(newItem)
            self.saveItems()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    // MARK: - Data manipulation
    func saveItems() {
        do {
            try context.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    func loadItems() {
        let request : NSFetchRequest<Note> = Note.fetchRequest()
        do {
            noteArray = try context.fetch(request)
        } catch {
            print(error)
        }
        tableView.reloadData()
    }
}
