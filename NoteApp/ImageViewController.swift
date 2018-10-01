//
//  ImageViewController.swift
//  NoteApp
//
//  Created by USER on 26/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit
import CoreData



class ImageViewController: UIViewController {
    
    var note: Note?
    var img: Data?
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func deleteImageAction(_ sender: Any) {
       
        updateNote()
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let image = UIImage(data: img!)  {
            
            imageView.image = image
        }
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    } 
 
    
    func updateNote() {
        
        note?.image = nil
        PersistentService.saveContext()
        
    }
    
}
