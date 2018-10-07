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
    
    
   // override func layoutSubviews() {
     ///   super.layoutSubviews()
        
        //cellImageView.translatesAutoresizingMaskIntoConstraints = false
        
       // cellImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
       // cellImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true
       // cellImageView.leadingAnchor.constraint(equalTo: (superview?.leadingAnchor)!, constant: 8).isActive = true
       // cellImageView.topAnchor.constraint(equalTo: (superview?.topAnchor)!, constant: 8).isActive = true
        
        
  //  }
    
    
}

class NotesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    // MARK: Publics
    
    // MARK: Privates
    
    // MARK: - Memory management
    
    // MARK: - View LifeCycle
    //override func viewDidLoad() {
    //    super.viewDidLoad()
        
      //  setupUI()
        // Do any additional setup after loading the view.
   // }
    
    // MARK: - Action Handlers
    
    // MARK: - Public
    
    // MARK: - Private
   // private func setupUI() {
        
        
        //names
        
        //colors
        
        //fonts
        
        //states
        
        //actions
        
   // }
    
    // MARK: - Delegates
    
     @IBOutlet weak var tableView: UITableView!
    
     @IBOutlet weak var searchBar: UISearchBar!
    
    @IBAction func onAddAction(_ sender: Any) {
        
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
    
    
    
    var notes = [Note]()
    
    
    let cayenne = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 1)
    //let cayenneWithAlpha = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 0.4)
    
    
    
        
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSearchBar()
        //tableView.tableFooterView = UIView()
       // tableView.backgroundColor = UIColor.groupTableViewBackground
       
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]
       //navigationController?.navigationBar.titleTextAttributes = textAttributes
            
            
       // navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.titleTextAttributes = textAttributes
       // navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]
        
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideSearchBar?.textColor = cayenne
        textFieldInsideSearchBar?.tintColor = cayenne
        
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
        super.viewWillAppear(animated)
        
        notes = getNotes()
        tableView.reloadData()
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
        /*for char in currentItem.title {
         var str = ""
         str.append(char)
         if str == search {
         print("Found character: \()")
         
         }
         }
         */
        tableView.rowHeight = 100.0
        // cell.layer.borderWidth = 0.3
        // cell.layer.borderColor = cayenne.cgColor
        
       // let labelSize = CGSize(width:52.0, height:18.0)
       // let labelRect = CGRect(x:16.0, y:58.0, width:labelSize.width, height:labelSize.height)
       // let label = UILabel(frame: labelRect)
       // let formatter = DateFormatter()
       // formatter.dateFormat = "MM-dd HH:mm"
       // label.text = ""
       // label.text = formatter.string(from: currentItem.created)
       // label.font = UIFont.italicSystemFont(ofSize: 8.0)
       // cell.contentView.addSubview(label)
        
        if  let imageData = currentItem.image {
            cell.cellImageView?.image = UIImage(data: imageData as Data)
           /*
            let itemSize = CGSize(width:70.0, height:70.0)
            UIGraphicsBeginImageContextWithOptions(itemSize, false, 0.0)
            let imageRect = CGRect(x:0.0, y:0.0, width:itemSize.width, height:itemSize.height)
            cell.imageView?.image!.draw(in:imageRect)
            cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            */
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
