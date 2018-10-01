//
//  Note+CoreDataProperties.swift
//  NoteApp
//
//  Created by USER on 28/09/2018.
//  Copyright © 2018 My. All rights reserved.
//
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var created: Date
    @NSManaged public var id: String
    @NSManaged public var image: Data?
    @NSManaged public var text: String
    @NSManaged public var title: String

}
