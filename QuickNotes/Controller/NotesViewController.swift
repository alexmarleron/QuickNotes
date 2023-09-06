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
        loadNotes()
        
        let newPresentNote = Note() //note for: При первом запуске приложение должно иметь одну заметку с текстом.
        newPresentNote.title = "Hello from code! First hardcoded note"
        notesArray.append(newPresentNote)
    }
    
    //MARK: - Add new note
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: NSLocalizedString(Constants.addNewNote, comment: ""), message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString(Constants.addNote, comment: ""), style: .default) { UIAlertAction in
            let newNote = Note()
            newNote.title = textField.text!
            self.notesArray.append(newNote)
            self.saveNote()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = NSLocalizedString(Constants.create, comment: "")
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    //MARK: - Saving and loading data
    
    func saveNote() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(notesArray)
            try data.write(to: dataFile!)
        } catch {
            print("Error saving note \(error)")
        }
        self.tableView.reloadData()
    }
    func loadNotes() {
        if let data = try? Data(contentsOf: dataFile!) {
            let decoder = PropertyListDecoder()
            do {
                notesArray = try decoder.decode([Note].self, from: data)
            } catch {
                print("Error loading note \(error)")
            }
        }
    }
}
//MARK: - TableView config

extension NotesViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.noteCell, for: indexPath)
        let note = notesArray[indexPath.row]
        cell.textLabel?.text = note.title
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var textField = UITextField()
        let noteSelected = notesArray[indexPath.row]
        let alert = UIAlertController(title: NSLocalizedString(Constants.editNote, comment: ""), message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: NSLocalizedString(Constants.updateNote, comment: ""), style: .default) { (action) in
            let editNote = Note()
            editNote.title = textField.text!
            noteSelected.title = editNote.title
            self.saveNote()
        }
        alert.addTextField { (alertTextField) in
            textField = alertTextField
            alertTextField.text = noteSelected.title
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notesArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            saveNote()
        }
    }
}
