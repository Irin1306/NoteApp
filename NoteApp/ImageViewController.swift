//
//  ImageViewController.swift
//  NoteApp
//
//  Created by USER on 26/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import UIKit

protocol ClassIVCDelegate: class {
    func onDeleted() -> [String: Any]
    
}

class ImageViewController: UIViewController {
    
    var notes = [String: Any]()
    var img = ""
    
    @IBOutlet weak var imageView: UIImageView!
    
    weak var delegate: ClassIVCDelegate?
    
    @IBAction func deleteImageAction(_ sender: Any) {
        let isDeleted = deleteImage(img)
        let ind = notes["ind"] as? Int
        if isDeleted && ind != -1 {
            print("deleteImageAction\(ind ?? -1)")
            
            updateItem(title: notes["Title"] as! String, description: notes["Description"] as! String,
                       index: notes["index"] as! String, image: "")
            
            delegate?.onDeleted()
            
        }
        navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(img, notes)
        if !img.isEmpty {
            imageView?.image = getSavedImage(img)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
