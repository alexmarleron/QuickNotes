//
//  ViewController.swift
//  QuickNotes
//
//  Created by san on 20.03.2023.
//

import UIKit

class NotesViewController: UITableViewController {

    var notesArray = [Note]()
    let dataFile = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Notes.plist")
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFile!)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.noteCell, for: indexPath)
        let note = notesArray[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
    
    //MARK: - Add new note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: NSLocalizedString(Constants.addNewNote, comment: ""), message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString(Constants.addNote, comment: ""), style: .default) { UIAlertAction in
            let newNote = Note()
            newNote.title = textField.text!
            
            self.notesArray.append(newNote)
            
            let encoder = PropertyListEncoder()
            
            do {
                let data = try encoder.encode(self.notesArray)
                try data.write(to: self.dataFile!)
              
            } catch {
                print(error)
            }
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = NSLocalizedString(Constants.create, comment: "")
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
        
    }
}

