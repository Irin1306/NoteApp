//
//  EditViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit
import CoreData
import Photos
 
class EditViewController: UIViewController, UIImagePickerControllerDelegate,
    UINavigationControllerDelegate, UITextViewDelegate {
    
    let cayenne = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 1)
    
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
            navigationController?.pushViewController(ivc, animated: true)
            
        }
       
        
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
        
        
        if title != "" {
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
            
        } else {
            //
        }
        
        
    }
    
    @IBAction func pushAddPictureAction(_ sender: Any) {
        checkPermission()
        
    }
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]        
      
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).backgroundColor = cayenne
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).isTranslucent = false
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).barTintColor = cayenne
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).tintColor = UIColor.yellow
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).titleTextAttributes = textAttributes
        
        
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        textTitle.delegate = self
        textDescription.delegate = self
      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
            imageView.image = UIImage(data: imageData as Data)
            img = imageData as Data
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
    
    
    func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
           photoLibrary()
         
        case .denied:
            print("permission denied")
            addAlertForSettings()
            
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    self.photoLibrary()
                  
                }else{
                    print("restriced manually")
                    self.addAlertForSettings()
                }
            })
        case .restricted:
            print("permission restricted")
            self.addAlertForSettings()
        
        }
    }
    
    func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){          
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func addAlertForSettings() {
        let alert = UIAlertController(title: "Photo", message: "Photo access is necessary to select photos", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        // Add "OK" Button to alert, pressing it will bring you to the settings app
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        // Show the alert with animation
        self.present(alert, animated: true)
        
    }
    
    func createNote(id: String, created: Date, title: String, text: String, image: Data?) {
        
        let newNote = Note(context: PersistentService.context)
        newNote.id = id
        newNote.created = created as NSDate
        newNote.title = title
        newNote.text = text
        if let imageData = image {
            newNote.image = imageData as NSData
        }
        PersistentService.saveContext()
        
    }
    
    func updateNote(title: String, text: String, image: Data?) {
        
        editNote?.title = title
        editNote?.text = text
        if let imageData = image {
            editNote?.image = imageData as NSData
        }
        PersistentService.saveContext()
        
    }
  
}



