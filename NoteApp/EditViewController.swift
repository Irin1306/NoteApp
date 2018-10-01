//
//  EditViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit
import CoreData
 
class EditViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UITextViewDelegate {
    
    
    var editNote: Note?
    var img: Data?
    var isExist = true
    

    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
   
    
    @IBAction func tapImageViewAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ivc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
        if let imgPath = img {
            ivc.img = imgPath
            ivc.note = editNote
            
        }
       
        navigationController?.pushViewController(ivc, animated: true)
    }
    
    let picker = UIImagePickerController()
    
    
    var selectedImage : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var textDescription: UITextView!
   
    @IBAction func pushEditAction(_ sender: Any) {
        
        let title = textTitle.text != "Add the title" ? textTitle.text : ""
        let text = textDescription.text != "Add the description" ? textDescription.text : ""
        let uuid = NSUUID().uuidString
        let created = Date()
        
        
        if imageView != nil && imageView.image != nil {
            
            let imageData = UIImageJPEGRepresentation(imageView.image!, 0.3)
            
            if !isExist {
                
                createNote(id: uuid, created: created, title: title!, text: text!, image: imageData)
              
            } else {
                
                updateNote(title: title!, text: text!, image: imageData)
                
            }
            
        } else {
            if  !isExist {
                
                createNote(id: uuid, created: created, title: title!, text: text!, image: nil)
                
            } else {
                
                updateNote(title: title!, text: text!, image: nil)                
                
            }
            
        }        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pushAddPictureAction(_ sender: Any) {
        
        picker.isEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
   
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        textTitle.delegate = self
        textDescription.delegate = self
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        if let title = editNote?.title {
            if !title.isEmpty {
                textTitle.text = title
            } else {
                textTitle.text = "Add the title"
                textTitle.textColor = UIColor.lightGray
            }
        } else {
            textTitle.text = "Add the title"
            textTitle.textColor = UIColor.lightGray
        }
        
        if let description = editNote?.text {
            if !description.isEmpty {
                textDescription.text = description
            } else {
                textDescription.text = "Add the description"
                textDescription.textColor = UIColor.lightGray
                
            }
        } else {
            textDescription.text = "Add the description"
            textDescription.textColor = UIColor.lightGray
            
        }
        
        if let imageData = editNote?.image {
            imageView.image = UIImage(data: imageData)
            img = imageData
        } else {
            imageViewHeight.constant = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageViewHeight.constant = 128
            imageView?.image = chosenImage
        }
        //self.performSegue(withIdentifier: "ShowEditView", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
       
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
       
        if textView.text.isEmpty {
            if textView == textTitle {
                textView.text = "Add the title"
            } else if textView == textDescription {
                textView.text = "Add the description"
                
            }
            textView.textColor = UIColor.lightGray
        }
        
    }
    
    func createNote(id: String, created: Date, title: String, text: String, image: Data?) {
        
        let newNote = Note(context: PersistentService.context)
        newNote.id = id
        newNote.created = created
        newNote.title = title
        newNote.text = text
        if let imageData = image {
            newNote.image = imageData
        }
        PersistentService.saveContext()
        
    }
    
    func updateNote(title: String, text: String, image: Data?) {
        
        editNote?.title = title
        editNote?.text = text
        if let imageData = image {
            editNote?.image = imageData
        }
        PersistentService.saveContext()
        
    }
  
}



