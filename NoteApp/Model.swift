//
//  Model.swift
//  NoteApp
//
//  Created by USER on 18/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import Foundation

var NotesItems: [[String: Any]] {
    set {
        UserDefaults.standard.set(newValue, forKey: "NotesDataKey")
        UserDefaults.standard.synchronize()
        
    }
    get {
        if let array = UserDefaults.standard.array(forKey: "NotesDataKey") as? [[String: Any]] {
            return array
        } else {
            return []
        }
        
    }
}



func addItem(title: String, description: String, index: String, image: String) {
    
        NotesItems.append(["Title": title, "Description": description, "index": index, "image": image])
    
}

func updateItem(title: String, description: String, index: String, image: String) {
    
    for i in 0...NotesItems.count {
        if NotesItems[i]["index"] as! String == index {
            NotesItems[i].updateValue(title, forKey: "Title")
            NotesItems[i].updateValue(description, forKey: "Description")
            NotesItems[i].updateValue(index, forKey: "index")
            NotesItems[i].updateValue(image, forKey: "image")
            return
        }
    }
}
func updateByRemoveImg(index: String) {
        
        for i in 0...NotesItems.count {
            if NotesItems[i]["index"] as! String == index {
                let image = ""
                NotesItems[i].updateValue(image, forKey: "image")
                return
         }
     }
}

 
    /*
    for var i in  NotesItems  {
        if  i["index"] as! String == index {
            print(123154564)
            i.updateValue(title, forKey: "Title")
            i.updateValue(description, forKey: "Description")
            i.updateValue(index, forKey: "index")
            i.updateValue(image, forKey: "image")

            print(i)
            
            
        }
    } */
    
 


func removeItem(atIndex: Int) {
    NotesItems.remove(at: atIndex)
}

 
func moveItem(fromIndex: Int, toIndex: Int) {
    let from = NotesItems[fromIndex]
    NotesItems.remove(at: fromIndex)
    NotesItems.insert(from, at: toIndex)
    
}

 


