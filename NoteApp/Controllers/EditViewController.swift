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

@IBDesignable extension UIImageView {
    
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
    
   
    // MARK: Publics
    let cayenne = UIColor.init(red: 0.498, green: 0, blue: 0, alpha: 1)
   
    var activeView: UITextView?
    var selectedImage : UIImage!
    var editNote: Note?
    var img: Data?
    var isExist = true
    
    var keyboardHeight: CGFloat = 0.0
    
    let picker = UIImagePickerController()
    
    let notificationCenter = NotificationCenter.default
   
    
    @IBOutlet weak var editScrollView: UIScrollView!
    
    @IBOutlet weak var textTitle: UITextView!
    
    @IBOutlet weak var textDescription: UITextView!
    
    @IBOutlet weak var noteImageView: UIImageView!
    
    @IBOutlet weak var noteImageViewHeight: NSLayoutConstraint!
    
    
    // MARK: Privates
    
    // MARK: - Memory management
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
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
    
    // MARK: - Action Handlers
    @IBAction func onShowImageAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let ivc = storyboard.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        
        if let imgPath = img {
            ivc.img = imgPath
            ivc.note = editNote
            navigationController?.pushViewController(ivc, animated: true)
        }
        
    }
    
    @IBAction func onEditAction(_ sender: Any) {     
        let title = textTitle.text
        let text = textDescription.text
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
            AlertService.addAlert(in: self, withTitle: "NoteApp", withMessage: "Add title to save note"){() in
                
                self.textTitle.becomeFirstResponder()
                
            }
        }
        
    }
    
    @IBAction func onAddImageAction(_ sender: Any) {
        checkPermission()
        
    }
   
    // MARK: - Public

    // MARK: - Private
    private func setupUI() {        
        //names
        

        //colors
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
        
        //fonts
        
        //states
        picker.delegate = self
        picker.modalPresentationStyle = .overCurrentContext
        textTitle.delegate = self
        textDescription.delegate = self

        //actions
        hideKeyboardWhenTappedAround()
       
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    deinit {
        notificationCenter.removeObserver(self, name: Notification.Name.UIKeyboardWillHide, object: nil)
        notificationCenter.removeObserver(self, name: Notification.Name.UIKeyboardWillChangeFrame, object: nil)
        
    }
    
    private func checkPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        
        switch status {
        case .authorized:
            photoLibrary()
            
        case .denied:
            print("permission denied")
            AlertService.addAlert(in: self, withTitle: "Photo", withMessage: "Photo access is necessary to select photos"){() in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            }
            
        case .notDetermined:
            print("Permission Not Determined")
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == PHAuthorizationStatus.authorized{
                    // photo library access given
                    print("access given")
                    self.photoLibrary()
                    
                }else{
                    print("restriced manually")
                    AlertService.addAlert(in: self, withTitle: "Photo", withMessage: "Photo access is necessary to select photos"){() in
                        UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
                    }
                }
            })
        case .restricted:
            print("permission restricted")
            AlertService.addAlert(in: self, withTitle: "Photo", withMessage: "Photo access is necessary to select photos"){() in
                UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
            }
        }
        
    }
    
    private func photoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    private func createNote(id: String, created: Date, title: String, text: String, image: Data?) {
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
    
    private func updateNote(title: String, text: String, image: Data?) {
        editNote?.title = title
        editNote?.text = text
        if let imageData = image {
            editNote?.image = imageData as NSData
            
        }
        PersistentService.saveContext()
        
    }

    // MARK: - Delegates
    //imagePicker
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            noteImageViewHeight.constant = 128
            noteImageView?.image = chosenImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    //keyboard
    @objc func adjustForKeyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        keyboardHeight = keyboardViewEndFrame.height
       
        if notification.name == Notification.Name.UIKeyboardWillHide {
             activeView?.contentInset = UIEdgeInsets.zero           
            
        } else {
            activeView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
         
        }
        
       activeView?.scrollIndicatorInsets = (activeView?.contentInset)!
       let selectedRange = activeView?.selectedRange
       activeView?.scrollRangeToVisible(selectedRange!)
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    func textViewShouldReturn(_ textView: UITextView) -> Bool {
        if textView.tag == 0 {
            textDescription.becomeFirstResponder()
        } else if textView.tag == 1 {
            textView.resignFirstResponder()
        }
        //self.view.endEditing(true)
        //return false
       return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeView = textView
        let textViewRealYPosition = textView.frame.origin.y + textView.frame.height - keyboardHeight
       // let textViewRealYPosition = textView.bounds.size.height - textView.contentSize.height - textView.frame.height
       // let textViewRealYPosition = view.bounds.size.height - keyboardHeight
        if textView == textDescription {
            editScrollView.setContentOffset(CGPoint(x: 0, y: textViewRealYPosition), animated: true)
           
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeView = nil
        editScrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    
    
}



