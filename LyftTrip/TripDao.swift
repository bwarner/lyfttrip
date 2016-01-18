//
//  TripDao.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation


protocol TripDao {
    func saveTrip(trip:Trip) throws
    func delete(trip:Trip) throws
    func findAll() -> [Trip]
}


class TripMemoryDao : TripDao {
    static var idCounter:Int64 = 0
    
    var trips = [Int64:Trip]()
    func saveTrip( trip:Trip) {
        let id = TripMemoryDao.idCounter++
        trip.id = Int64(id)
        trips[id] = trip
    }
    
    func findTrip(id:Int64) -> Trip? {
        return trips[id]
    }
    
    func delete(trip:Trip) {
        if let key = trip.id {
            trips.removeValueForKey(key)
        }
    }

    func findAll() -> [Trip] {
        return [Trip](trips.values)
    }
    
}