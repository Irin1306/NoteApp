//
//  EditViewController.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
    
    var note = [String: Any]()
    
    
    @IBOutlet weak var imageViewHeight: NSLayoutConstraint!
    
    let picker = UIImagePickerController()
    
    var selectedImage : UIImage!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var textDescription: UITextView!
   
    @IBAction func pushEditAction(_ sender: Any) {
        
        let title = textTitle.text != "Add the title" ? textTitle.text : ""
        let description = textDescription.text != "Add the description" ? textDescription.text : ""    
        let index = note["index"] as? Int
        
        if imageView != nil && imageView.image != nil {
            
            //let imageData = UIImageJPEGRepresentation(imageView.image!, 100)
          
            let imagePath = saveImageToDocumentDirectory(imageView.image!)
            
            addItem(title: title!, description: description!, index: index!, image: imagePath)
            
        } else {
            addItem(title: title!, description: description!, index: index!, image: "")
            
        }        
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pushAddPictureAction(_ sender: Any) {
        
        picker.isEditing = false
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
        
    }
   
    
    override func viewDidLoad() {
        print(note)
        if let title = note["Title"] as? String {
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
        
        if let description = note["Description"] as? String  {
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

        if let imageData = note["image"] as? String {   //Data {
            //imageView.image = UIImage(data: imageData)
             if !imageData.isEmpty {
                imageView?.image = getSavedImage(imageData)
             } else {
                imageViewHeight.constant = 0
            }
                
        } else {
            imageViewHeight.constant = 0
        }
        
        
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        textTitle.delegate = self
        textDescription.delegate = self
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
        imageView?.image = chosenImage
        //self.performSegue(withIdentifier: "ShowEditView", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
        let directoryPath =  NSHomeDirectory().appending("/Documents/")
        if !FileManager.default.fileExists(atPath: directoryPath) {
            do {
                try FileManager.default.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error)
            }
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let filename = formatter.string(from: Date()).appending(".jpg")
        let filepath = directoryPath.appending(filename)
        let url = NSURL.fileURL(withPath: filepath)
        do {
            try UIImageJPEGRepresentation(chosenImage, 1.0)?.write(to: url, options: .atomic)
            print("file was saved at path \(filepath)");
            //return String.init("/Documents/\(filepath)")
            return filename
            
        } catch {
            print(error)
            print("file cant not be save at path \(filepath), with error : \(error)");
            return filename
        }
    }
    
    func getSavedImage(_ named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            print(named)
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
            
        }
        return nil
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



