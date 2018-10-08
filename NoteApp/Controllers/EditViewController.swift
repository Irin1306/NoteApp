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
        
        //editScrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height*2)
        //editScrollView.contentSize = view.bounds.size*2
        
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
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboardTitle), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboardTitle), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
       // notificationCenter.addObserver(self, selector: #selector(adjustForKeyboardDescription), name: Notification.Name.UIKeyboardWillHide, object: nil)
       // notificationCenter.addObserver(self, selector: #selector(adjustForKeyboardDescription), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    @objc func adjustForKeyboardTitle(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            textTitle.contentInset = UIEdgeInsets.zero
        } else {
            textTitle.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textTitle.scrollIndicatorInsets = textTitle.contentInset
        
        let selectedRange = textTitle.selectedRange
        textTitle.scrollRangeToVisible(selectedRange)
    }
    /*
    @objc func adjustForKeyboardDescription(notification: Notification) {
        let userInfo = notification.userInfo!
        
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == Notification.Name.UIKeyboardWillHide {
            textDescription.contentInset = UIEdgeInsets.zero
        } else {
            textDescription.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        
        textDescription.scrollIndicatorInsets = textDescription.contentInset
        
        let selectedRange = textDescription.selectedRange
        textDescription.scrollRangeToVisible(selectedRange)
    }*/
    
    // Call this method somewhere in your view controller setup code.
    
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    
    func keyboardWasShown(_ aNotification: Notification?) {
        let info = aNotification?.userInfo
        let kbSize: CGSize? = info?[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue.size
        
        let contentInsets: UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize?.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your app might not need or want this behavior.
        let aRect: CGRect = view.frame
        aRect.size.height -= kbSize?.height ?? 0.0
        if !aRect.contains(activeField.frame.origin) {
            scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }

    // Called when the UIKeyboardWillHideNotification is sent
    
    func keyboardWillBeHidden(_ aNotification: Notification?) {
        let contentInsets: UIEdgeInsets = .zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    //Additional methods for tracking the active text field.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        activeField = nil
    }

    //Adjusting the frame of the content view and scrolling a field above the keyboard
    func keyboardWasShown(_ aNotification: Notification?) {
        let info = aNotification?.userInfo
        let kbSize: CGSize? = info?[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue.size
        let bkgndRect: CGRect = activeField.superview.frame
        bkgndRect.size.height += kbSize?.height ?? 0.0
        activeField.superview.frame = bkgndRect
        scrollView.setContentOffset(CGPoint(x: 0.0, y: activeField.frame.origin.y - (kbSize?.height ?? 0.0)), animated: true)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        //NotificationCenter.default.removeObserver(self, selector: #selector(self.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        //NotificationCenter.default.removeObserver(self, selector: #selector(self.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    /*
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
        
    }*/
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



