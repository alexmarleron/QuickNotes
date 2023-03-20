//
//  ViewController.swift
//  QuickNotes
//
//  Created by san on 20.03.2023.
//

import UIKit

class NotesViewController: UITableViewController {

    let notesArray = ["Testing one", "Testing two", "Testing 3"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.noteCell, for: indexPath)
        let note = notesArray[indexPath.row]
        cell.textLabel?.text = note
        return cell
    }
}

