//
//  Trip+CoreDataProperties.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Trip {

    @NSManaged var status: String?
    @NSManaged var route: String?
    @NSManaged var duration: String?
    @NSManaged var creationDate: NSDate?
    @NSManaged var trips: NSSet?

}
