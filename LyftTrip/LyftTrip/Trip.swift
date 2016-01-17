//
//  Trip.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation
import FMDB

struct Trip {
    
    let insertSQL = "insert into trip(status, route, duration) values(?, ?, ?)"
    let createSQL = "CREATE TABLE IF NOT EXISTS trip (id integer primary key, status text not null, route text null, duration text route)"
    
    var status: String?
    var route: String?
    var duration: String?
    var creationDate: NSDate?
    var id:Int?
    var details = [TripDetail]()

    static func createTable(queue:FMDatabaseQueue) {
    
    }
    
}
