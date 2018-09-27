//
//  helper.swift
//  NoteApp
//
//  Created by USER on 26/09/2018.
//  Copyright © 2018 My. All rights reserved.
//

import Foundation
import UIKit


let fm = FileManager.default
let directoryPath =  NSHomeDirectory().appending("/Documents/")


func saveImageToDocumentDirectory(_ chosenImage: UIImage) -> String {
    
    if !fm.fileExists(atPath: directoryPath) {
        do {
            try fm.createDirectory(at: NSURL.fileURL(withPath: directoryPath), withIntermediateDirectories: true, attributes: nil)
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
    if let dir = try? fm.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
        //print(named)
        return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        
    }
    return nil
}

func deleteImage(_ named: String) -> Bool {
    var isSuccess = false
     do {
        let filepath = directoryPath.appending(named)
    
        // Check if file exists
        if fm.fileExists(atPath: filepath) {
            // Delete file
            try fm.removeItem(atPath: filepath)
            isSuccess = true
        } else {
            print("File does not exist")
        }
        } catch {
            print("error")
        }
    print(isSuccess)
    return isSuccess
    
}


func deleteAllImage() {

    guard var items = try? fm.contentsOfDirectory(atPath: directoryPath )  else{
        return
    }
    print(items)
    
    do {
        items = try fm.contentsOfDirectory(atPath: directoryPath )
        
        for item in items {
            let filepath = directoryPath.appending(item)
            print(filepath)
            // Check if file exists
            if fm.fileExists(atPath: filepath) {
                // Delete file
                try fm.removeItem(atPath: filepath)
            } else {
                print("File does not exist")
            }
            
        }
    } catch {
        // failed to read directory – bad permissions, perhaps?
    }
    
    print(items)
}

