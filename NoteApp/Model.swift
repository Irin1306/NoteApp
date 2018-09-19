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

func addItem(title: String, description: String, index: Int, image: Any?) {
    if index == -1 {
        NotesItems.append(["Title": title, "Description": description, "image": image as Any ])
    } else {
        NotesItems[index] = ["Title": title, "Description": description, "image": image as Any]
    }
    
}

func removeItem(atIndex: Int) {
    NotesItems.remove(at: atIndex)
}

 
func moveItem(fromIndex: Int, toIndex: Int) {
    let from = NotesItems[fromIndex]
    NotesItems.remove(at: fromIndex)
    NotesItems.insert(from, at: toIndex)
    
}

 


