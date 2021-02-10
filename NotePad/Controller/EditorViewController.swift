//
//  EditorViewController.swift
//  NotePad
//
//  Created by Oybek on 2/9/21.
//

import UIKit
import CoreData
class EditorViewController: UIViewController {
    @IBOutlet weak var editorTextView: UITextView!
    
    var context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var row = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNote()
        title = selectedNote!.title!
    }
    
    var selectedNote : Note? {
        didSet {
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        updateNote(with: editorTextView.text!)
    }
    
    // MARK: - Update Note
    func updateNote(with text: String) {
        let request : NSFetchRequest<NoteText> = NoteText.fetchRequest()
        do {
            var results = try context.fetch(request)
            func newItem() {
                print("Creating new item")
                let note = NoteText(context: context)
                note.text = text
                note.parentNoteTitle = selectedNote
                results.append(note)
            }
            if results.count == 0 {
                print("first item creating")
                newItem()
                try context.save()
            } else if results.indices.contains(row) == false {
                print("item not exists so creating new item")
                newItem()
                try context.save()
            } else if results[row].parentNoteTitle?.title == selectedNote!.title! {
                print("exists")
                // should update it
                results[row].setValue(text, forKey: "text")
                try context.save()
            } else {
                print("other error")
            }
        } catch {
            print(error)
            print("Update error")
        }
    }
    
    // MARK: - Load Note
    func loadNote() {
        let request : NSFetchRequest<NoteText> = NoteText.fetchRequest()
        let predicate = NSPredicate(format: "parentNoteTitle.title MATCHES %@", selectedNote!.title!)
        request.predicate = predicate
        do {
            let results = try context.fetch(request)
            let r = results.count - 1
            if r == -1 {
                print("item does not exist")
            } else if r == row {
                print("showing")
                editorTextView.text = results[row].text
            } else if r == 0 {
                editorTextView.text = results[0].text
            } else {
                print("error")
            }
        } catch {
            print(error)
            print("loadError")
        }
    }
    
}
