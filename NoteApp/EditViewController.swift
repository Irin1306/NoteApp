//
//  EditViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var note = [String: Any]()
    
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    let picker = UIImagePickerController()
    
    var selectedImage : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var textDescription: UITextView!
   
    @IBAction func pushEditAction(_ sender: Any) {
        
        let title = textTitle.text
        let description = textDescription.text
        let index = note["index"] as? Int
        
        if imageView != nil && imageView.image != nil {
            let imageData = UIImageJPEGRepresentation(imageView.image!, 100)
            addItem(title: title!, description: description!, index: index!, image: imageData!)
            
        } else {
            addItem(title: title!, description: description!, index: index!, image: 1)
            
        }        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pushAddPictureAction(_ sender: Any) {
        
        picker.isEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
   
    
    override func viewDidLoad() {
        
        if let title = note["Title"] as? String  {
            if !title.isEmpty {
                textTitle.text = title
            }
        }
        if let description = note["Description"] as? String  {
            if !description.isEmpty {
                textDescription.text = description
                
            }
        }
        if let imageData = note["image"] as? Data {
            if !imageData.isEmpty {
               imageView.image = UIImage(data: imageData)
            }
            else {
                imageViewHeight.constant = 0
                
            }
        } else {
            imageViewHeight.constant = 0
            
        }
        
        picker.delegate = self
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageViewHeight.constant = 128
        imageView.image = chosenImage
        //self.performSegue(withIdentifier: "ShowEditView", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }   
    
}



