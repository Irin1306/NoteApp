//
//  TableViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
   
    
    @IBAction func pushAddAction(_ sender: Any) {
        
        //performSegue(withIdentifier: "makingTransition", sender: ["index": -1])
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editvc = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editvc.notes = ["index": -1]
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
        
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor.groupTableViewBackground
        //deleteAllImage()
        //removeItem(atIndex: 0)
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
         //self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {    
        tableView.reloadData()
        print(NotesItems)
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
        return NotesItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       // let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MyTableCell

        // Configure the cell...
        let currentItem = NotesItems[indexPath.row]
        cell.textLabel?.text = currentItem["Title"] as? String
        cell.detailTextLabel?.text = currentItem["Description"] as? String
        if let imageData = currentItem["image"] as? String {  //Data {
            if !imageData.isEmpty {
                //cell.imageView?.image = UIImage(data: imageData)
                
                cell.imageView?.image = getSavedImage(imageData)                
                
                let itemSize = CGSize(width:42.0, height:42.0)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
                let imageRect = CGRect(x:0.0, y:0.0, width:itemSize.width, height:itemSize.height)
                cell.imageView?.image!.draw(in:imageRect)
                cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
                UIGraphicsEndImageContext()
 
            }
            
        }      
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(indexPath.row)
        var item = NotesItems[indexPath.row]
        print(item)
        
        item["index"] = indexPath.row
        print(item)
        //performSegue(withIdentifier: "makingTransition", sender: item)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let editvc = storyboard.instantiateViewController(withIdentifier: "EditViewController") as! EditViewController
        editvc.notes = item
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
            // Delete the row from the data source
            removeItem(atIndex: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        moveItem(fromIndex: fromIndexPath.row, toIndex: to.row)
        
        tableView.reloadData()
        
    }
    

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
        let svc = segue.destination as! EditViewController
        svc.notes = sender as! [String: Any]
        
    }   
    
    
}



