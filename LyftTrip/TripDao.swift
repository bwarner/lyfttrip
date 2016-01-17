//
//  TripDao.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation


protocol TripDao {
    func startTrip() -> Result<Trip>
    func add(detail:TripDetail, forTrip trip:Trip) -> Result<TripDetail>
    func endTrip(trip:Trip) -> Result<Trip>
    func trip(key:Int) -> Trip?
}


class TripMemory:TripDao {
    
    let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
    var trips = Dictionary<Int,Trip>();
    static var nextTrip:Int = 1
    
    func startTrip() -> Result<Trip> {
        var trip = Trip()
        trip.id = TripMemory.nextTrip
        trip.creationDate = NSDate()
        trips[TripMemory.nextTrip] = trip
        TripMemory.nextTrip++
        return .Value(trip)
    }
    
    func add(detail:TripDetail, var forTrip trip:Trip) -> Result<TripDetail>{
        trip.details.append(detail)
        return .Value(detail)
    }
 
    func endTrip(var trip:Trip) -> Result<Trip> {
        var duration = "No duration"
        let route = "No Route"
        if trip.details.count > 1 {
            if let first = trip.details.first, last = trip.details.last,
                components = calendar?.components([.Day,NSCalendarUnit.Hour, NSCalendarUnit.Minute,NSCalendarUnit.Second], fromDate: first.timestamp, toDate: last.timestamp, options: NSCalendarOptions(rawValue: 0)) {
                duration = "\(components.hour):\(components.minute):\(components.second) minutes"
            }
        }
        trip.route = route
        trip.duration = duration
        return .Value(trip)
    }

    func trip(key:Int) -> Trip? {
        return trips[key]
    }

}