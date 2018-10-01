//
//  TableViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController, UISearchBarDelegate {
   
   // @IBOutlet weak var searchBar: UISearchBar!
    
    var currentNotes = [[String: Any]]()
    
    var notes = [Note]()
  
    @IBAction func pushAddAction(_ sender: Any) {
        
        //performSegue(withIdentifier: "makingTransition", sender: ["index": -1])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editvc = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editvc.isExist = false
        navigationController?.pushViewController(editvc, animated: true)
        
        /*
        let alertController = UIAlertController(title: "Create new note", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alertController.addTextField { (textField) in
            textField.placeholder = "Description"
        }
        let alertAction1 = UIAlertAction(title: "Cancel", style: .default) { (alert) in
            
        }
        let alertAction2 = UIAlertAction(title: "Create", style: .cancel) { (alert) in
            let title = alertController.textFields![0].text
            let description = alertController.textFields![1].text
            addItem(title: title!, description: description!)
            self.tableView.reloadData()
        }
        
        alertController.addAction(alertAction1)
        alertController.addAction(alertAction2)
        present(alertController, animated: true, completion: nil)
        */
 
 }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.groupTableViewBackground
       
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
        currentNotes = NotesItems
    }
    
    private func setUpSearchBar() {
        //searchBar.delegate = self
       // searchBar.isHidden = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getNotes()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableCell

        // Configure the cell...
        let currentItem = notes[indexPath.row]
        cell.textLabel?.text = currentItem.title
        cell.detailTextLabel?.text = currentItem.text
        if  let imageData = currentItem.image {
            cell.imageView?.image = UIImage(data: imageData)
          
                let itemSize = CGSize(width:42.0, height:42.0)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
                let imageRect = CGRect(x:0.0, y:0.0, width:itemSize.width, height:itemSize.height)
                cell.imageView?.image!.draw(in:imageRect)
                cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        let item = notes[indexPath.row]
         
        //performSegue(withIdentifier: "makingTransition", sender: item)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editvc = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editvc.editNote = item
        navigationController?.pushViewController(editvc, animated: true)
        
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentItem = notes[indexPath.row]
            // Delete the row from the data source
            
            deleteNote(currentItem)
            getNotes()
            //tableView.deleteRows(at: [indexPath], with: .fade)
           
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        
        tableView.reloadData()
        
    }
 */
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentNotes = NotesItems
            tableView.reloadData()
            return
            
        }
        currentNotes = NotesItems.filter({note -> Bool in
            
            if  let title = note["Title"] as? String {
                return title.lowercased().contains(searchText.lowercased())
            }
             else {
                return false
            }
        })
        tableView.reloadData()
        
    }
    /*
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        
    }*/

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       // let svc = segue.destination as! EditViewController
        //svc.note = sender as! [String: Any]
        
    }
    
    func getNotes() {
        print(Note.self)
        let notes = PersistentService.fetch(Note.self)
        self.notes = notes
        self.tableView.reloadData()
        print(self.notes)
    }
    
    func deleteNote(_ note: Note) {
        PersistentService.delete(note)
        
    }
   
    
}



