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

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    
}

class EditViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextViewDelegate, UIScrollViewDelegate {
    
    let cayenne = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 1)
    
    var activeView: UITextView?
    
    var editNote: Note?
    var img: Data?
    var isExist = true
    

    @IBOutlet weak var editScrollView: UIScrollView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var noteImageViewHeight: NSLayoutConstraint!
    
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
    
    
    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var textDescription: UITextView!
   
    @IBAction func pushEditAction(_ sender: Any) {
        
        let title = textTitle.text != "Add the title" ? textTitle.text : ""
        
        
        let text = textDescription.text != "Add the description" ? textDescription.text : ""
        let uuid = NSUUID().uuidString
        let created = Date()
        
        
        if title != "" {
            if noteImageView != nil && noteImageView.image != nil {
                
                let imageData = UIImageJPEGRepresentation(noteImageView.image!, 0.3)
                
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
      
        let borderColor: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        textTitle.layer.borderWidth = 0.5
        textDescription.layer.borderWidth = 0.5
        textTitle.layer.borderColor = borderColor.cgColor
        textDescription.layer.borderColor = borderColor.cgColor
        textTitle.layer.cornerRadius = 5.0
        textDescription.layer.cornerRadius = 5.0
        textTitle.tintColor = cayenne
        textDescription.tintColor = cayenne
        
        let textAttributes = [NSAttributedStringKey.foregroundColor: UIColor.yellow]        
      
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).backgroundColor = cayenne
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).isTranslucent = false
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).barTintColor = cayenne
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).tintColor = UIColor.white
        UINavigationBar.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).titleTextAttributes = textAttributes
        
        
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        textTitle.delegate = self
        textDescription.delegate = self
        
        hideKeyboardWhenTappedAround()
        
        
       // registerForKeyboardNotifications()
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
  
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        guard let active = activeView else {return}
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            active.contentInset = UIEdgeInsets.zero
        } else {
            active.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        active.scrollIndicatorInsets = active.contentInset
        
        let selectedRange = active.selectedRange
        active.scrollRangeToVisible(selectedRange)
    }
    
    /*
    func registerForKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWasShown(_:)), name: Notification.Name.UIKeyboardDidShow, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    @objc func keyboardWillHide(sender: NSNotification) {
        let userInfo = sender.userInfo
        let keyboardSize: CGSize = (userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        self.view.frame.origin.y += keyboardSize.height
    }
    
    @objc func keyboardWasShown(_ aNotification: Notification?) {
       let userInfo = aNotification?.userInfo
        let keyboardSize: CGSize = (userInfo![UIKeyboardFrameBeginUserInfoKey]! as AnyObject).cgRectValue.size
        let offset: CGSize = (userInfo![UIKeyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue.size
        
        if keyboardSize.height == offset.height {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y -= keyboardSize.height
            })
        } else {
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                self.view.frame.origin.y += keyboardSize.height - offset.height
            })
        }
    }
    */
    
    /*
    @objc func keyboardWasShown(_ aNotification: Notification?) {
        guard let active = activeView else {return}
        let userInfo = aNotification?.userInfo
        //let kbSize: CGSize? = (userInfo?[Notification.Name.UIKeyboardWillChangeFrame] as AnyObject).cgRectValue.size
        
      //  let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, (kbSize?.height)!, 0.0)
      //  editScrollView.contentInset = contentInsets
     //   editScrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
       // var aRect: CGRect = view.frame
       // aRect.size.height -= kbSize?.height ?? 0.0
     //   if !aRect.contains(active.frame.origin) {
     //       editScrollView.scrollRectToVisible(active.frame, animated: true)
    //    }
       
        let keyboardScreenEndFrame = (userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if aNotification?.name == Notification.Name.UIKeyboardWillHide {
            active.contentInset = UIEdgeInsets.zero
        } else {
            active.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        active.scrollIndicatorInsets = active.contentInset
        
        let selectedRange = active.selectedRange
        active.scrollRangeToVisible(selectedRange)
        
       // var bkgndRect: CGRect = active.superview!.frame
       // bkgndRect.size.height += kbSize?.height ?? 0.0
       // active.superview?.frame = bkgndRect
       // editScrollView.setContentOffset(CGPoint(x: 0.0, y: active.frame.origin.y - (kbSize?.height ?? 0.0)), animated: true)
        
    }
 */
/*
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(_ aNotification: Notification?) {
        let contentInsets: UIEdgeInsets = .zero
        editScrollView.contentInset = contentInsets
        editScrollView.scrollIndicatorInsets = contentInsets
    }
 */
    
    
     func textViewDidBeginEditing(_ textView: UITextView) {
        activeView = textView
     }
     
     func textViewDidEndEditing(_ textView: UITextView) {
        activeView = nil
     }
    
 

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        textTitle.text = editNote?.title
        
        if let description = editNote?.text {
           textDescription.text = description            
        }
        
        if let imageData = editNote?.image {
            noteImageView.image = UIImage(data: imageData as Data)
            img = imageData as Data
        } else {
            noteImageViewHeight?.constant = 0
        }
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            noteImageViewHeight.constant = 128
            noteImageView?.image = chosenImage
        }
        //self.performSegue(withIdentifier: "ShowEditView", sender: self)
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
       
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        self.view.endEditing(true)
        return false
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



