//
//  EditViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit



class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, ClassIVCDelegate {
    
    
    var notes = [String: Any]()
    var img: String? = nil
   
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    
    func onDeleted() -> [String: Any] {
        [notes]
        notes["image"] = ""
        return notes
    }
    
    @IBAction func tapImageViewAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ivc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
        if let imgPath = img {
            ivc.img = imgPath
            ivc.notes = notes
            
        }
        ivc.delegate = self
        navigationController?.pushViewController(ivc, animated: true)
    }
    
    let picker = UIImagePickerController()
    
    
    var selectedImage : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var textDescription: UITextView!
   
    @IBAction func pushEditAction(_ sender: Any) {
        
        let title = textTitle.text != "Add the title" ? textTitle.text : ""
        let description = textDescription.text != "Add the description" ? textDescription.text : ""
        let uuid = NSUUID().uuidString
        
        if imageView != nil && imageView.image != nil {
            
            //let imageData = UIImageJPEGRepresentation(imageView.image!, 100)
          
            let imagePath = saveImageToDocumentDirectory(imageView.image!)
            
            if notes["ind"] != nil {
                addItem(title: title!, description: description!, index: uuid, image: imagePath)
                
            } else {
                updateItem(title: title!, description: description!, index: notes["index"] as! String, image: imagePath)
            }
            
        } else {
            if notes["ind"] != nil {
                addItem(title: title!, description: description!, index: uuid, image: "")
                
            } else {
                updateItem(title: title!, description: description!, index: notes["index"] as! String, image: "")
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
        
        print("editViewController")
        
        print(notes)
        if let title = notes["Title"] as? String {
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
        
        if let description = notes["Description"] as? String  {
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
        
        if let imageData = notes["image"] as? String {   //Data {
            //imageView.image = UIImage(data: imageData)
            if !imageData.isEmpty {
                imageView?.image = getSavedImage(imageData)
                img = imageData
            } else {
                imageViewHeight.constant = 0
            }
            
        } else {
            imageViewHeight.constant = 0
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewHeight.constant = 128
        imageView?.image = chosenImage
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
  
}



