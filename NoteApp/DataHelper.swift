//
//  DataHelper.swift
//  NoteApp
//
//  Created by USER on 28/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import Foundation
import CoreData
import UIKit

public class DataHelper {
   
   /* var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var noteRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Note")
    
    
    
    func addNote(id: String, created: Date, title: String, text: String, image: Data?) {
        let newNote = NSEntityDescription.insertNewObject(forEntityName: "Note", into: managedObjectContext)
        
        newNote.setValue(id, forKey: "id")
        newNote.setValue(created, forKey: "created")
        newNote.setValue(title, forKey: "title")
        newNote.setValue(text, forKey: "text")
        if image != nil {
            newNote.setValue(image, forKey: "image")
            
        }
        
        do {
            try managedObjectContext.save()
        } catch {
            print("Failed addNewNote")
        }
    }
    
    
    
    func fetchNoteRequest() -> [NSManagedObject]{
        noteRequest.returnsObjectsAsFaults = false
        var result = [NSManagedObject]()
        do {
            let results = try managedObjectContext.fetch(noteRequest)
            for i in results {
                result.append(i as! NSManagedObject)
            }
        } catch {
            print("Failed fetchRequest")
        }
        print(result)
        return result
    }
    */
}
