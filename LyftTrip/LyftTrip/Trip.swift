//
//  Trip.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation
import FMDB
import CoreLocation

class Trip {
    
    let insertSQL = "insert into trip(status, route, duration) values(?, ?, ?)"
    let createSQL = "CREATE TABLE IF NOT EXISTS trip (id integer primary key, status text not null, route text null, duration text route)"
    var status: String?
    var route: String?
    var duration: String?
    var startDate: NSDate?
    var id:Int64?
    var details = [TripDetail]()
    var first:CLLocation?
    var last:CLLocation?
    

    static func createTable(queue:FMDatabaseQueue) {
        
    }    
    init() {
    }
    
}



extension Trip  {
    
    static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    
    
    func add(detail:TripDetail) {
        details.append(detail)
    }
    
    func start() {
        startDate = NSDate()
    }
    
    func stopped() -> Bool {
        return (details.count > 10)
    }
    
    func end() {
        var duration = "No duration"
        let route = "No Route"
        if details.count > 1 {
            if let first = details.first, last = details.last,
                components = Trip.calendar?.components([.Day,NSCalendarUnit.Hour, NSCalendarUnit.Minute,NSCalendarUnit.Second], fromDate: first.timestamp, toDate: last.timestamp, options: NSCalendarOptions(rawValue: 0)) {
                    duration = "\(components.hour):\(components.minute):\(components.second) minutes"
            }
        }
        self.route = route
        self.duration = duration
    }
}
