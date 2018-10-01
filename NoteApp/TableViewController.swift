//
//  TableViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//
import Foundation
import UIKit
import CoreData

class TableViewController: UITableViewController, UISearchBarDelegate {
   
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    var currentNotes = [Note]()
    
    var notes = [Note]()
    
   //var search = ""
    let cayenne = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 1)
    //let cayenneWithAlpha = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 0.4)
    
    
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
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: cayenne]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = cayenne
        
        let glassIconView = textFieldInsideSearchBar?.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = cayenne
        
        //let clearButton = textFieldInsideSearchBar?.value(forKey: "clearButton") as! UIButton
        //clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        //clearButton.tintColor = cayenne
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
      
    }
    
    private func setUpSearchBar() {
        searchBar.delegate = self
        
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
        return currentNotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableCell

        // Configure the cell...
        let currentItem = currentNotes[indexPath.row]
        cell.textLabel?.text = currentItem.title
        cell.detailTextLabel?.text = currentItem.text
        
        /*
        let strTitle: NSString = currentItem.title as NSString
        let strText: NSString = currentItem.text as NSString
        let attributeTitle = NSMutableAttributedString.init(string: currentItem.title)
        let attributeText = NSMutableAttributedString.init(string: currentItem.text)
        attributeTitle.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: UIColor.red,
                                    range: strTitle.range(of: search))
        attributeText.addAttribute(kCTForegroundColorAttributeName as NSAttributedStringKey, value: UIColor.red,
                                    range: strTitle.range(of: search))
        cell.textLabel?.attributedText = attributeTitle
        cell.detailTextLabel?.attributedText = attributeTitle
        */
        
        tableView.rowHeight = 76.0
       // cell.layer.borderWidth = 0.3
       // cell.layer.borderColor = cayenne.cgColor
        
        let labelSize = CGSize(width:52.0, height:18.0)
        let labelRect = CGRect(x:16.0, y:58.0, width:labelSize.width, height:labelSize.height)
        let label = UILabel(frame: labelRect)
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
     
        label.text = formatter.string(from: currentItem.created)
        label.font = UIFont.italicSystemFont(ofSize: 8.0)
        cell.contentView.addSubview(label)
        
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
        
        let item = currentNotes[indexPath.row]
         
        //performSegue(withIdentifier: "makingTransition", sender: item)
        
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

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let currentItem = currentNotes[indexPath.row]
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
            currentNotes = notes
           // search = ""
            tableView.reloadData()
            return
            
        }
        currentNotes = notes.filter{
            $0.title.lowercased().contains(searchText.lowercased()) ||
            $0.text.lowercased().contains(searchText.lowercased())
            
        }
     
       //search = searchText.lowercased()
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
/*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
       // let svc = segue.destination as! EditViewController
        //svc.note = sender as! [String: Any]
        
    }
 */
    
    func getNotes() {
        print(Note.self)
        let notes = PersistentService.fetch(Note.self)
        self.notes = notes
        currentNotes = self.notes
        self.tableView.reloadData()
        print(self.notes)
    }
    
    func deleteNote(_ note: Note) {
        PersistentService.delete(note)
        
    }
    
}

