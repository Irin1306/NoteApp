//
//  ViewController.swift
//  NoteApp
//
//  Created by USER on 05/10/2018.
//  Copyright © 2018 My. All rights reserved.
//
 
import Foundation
import UIKit
import CoreData

class NotesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    @IBOutlet weak var cellTextLabel: UILabel!
    
    @IBOutlet weak var cellCreatedLabel: UILabel!
  
    
}

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    // MARK: Publics
    var notes = [Note]()
    
    let cayenne = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 1)
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: Privates
    
    // MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setUpSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        notes = getNotes()
        tableView.reloadData()
    }
    
    // MARK: - Action Handlers
    @IBAction func onAddAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editvc = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editvc.isExist = false
        navigationController?.pushViewController(editvc, animated: true)
        
    }

    // MARK: - Public
    
    // MARK: - Private
    private func setupUI() {
        
        //names
        
        //colors
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = cayenne
        textFieldInsideSearchBar?.tintColor = cayenne
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = cayenne
        
        //fonts
        
        //sizes
        tableView.rowHeight = 100.0
        
        //states
        
        //actions
        
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        
    }
    
    // MARK: - Delegates
   
    
   
    
    
    
    
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
        
    }
    
    
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? NotesTableViewCell
            else {return UITableViewCell()}
       
        // Configure the cell...
        let currentItem = notes[indexPath.row]
        cell.cellTitleLabel?.text = currentItem.title
        cell.cellTextLabel?.text = currentItem.text
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
       
        cell.cellCreatedLabel?.text = formatter.string(from: currentItem.created as Date)
        
        if  let imageData = currentItem.image {
            cell.cellImageView?.image = UIImage(data: imageData as Data)
        } else {
            cell.cellImageView?.image = nil
        }
        
        return cell
    }
 
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = notes[indexPath.row]
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editvc = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editvc.editNote = item
        navigationController?.pushViewController(editvc, animated: true)
        
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
 
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentItem = notes[indexPath.row]
            // Delete the row from the data source
            
            deleteNote(currentItem)
           //tableView.deleteRows(at: [indexPath], with: .fade)            
            notes = getNotes()
            tableView.reloadData()
            
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
            notes = getNotes()
            tableView.reloadData()
            return
            
        }
        notes = notes.filter{
            $0.title.lowercased().contains(searchText.lowercased()) ||
                $0.text.lowercased().contains(searchText.lowercased())
            
        }
       
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
    
    
    func getNotes() -> [Note] {
        return PersistentService.fetch(Note.self)       
        
    }
    
    func deleteNote(_ note: Note) {
        PersistentService.delete(note)
        
    }
    
}
