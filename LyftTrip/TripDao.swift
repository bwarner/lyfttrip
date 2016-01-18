//
//  TripDao.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation


protocol TripDao {
    func saveTrip(trip:Trip)
    func findTrip(id:Int) -> Trip?
    func findAll() -> [Trip]
}


class TripMemoryDao : TripDao {
    static var idCounter = 0
    
    var trips = [Int:Trip]()
    func saveTrip(var trip:Trip) {
        let id = TripMemoryDao.idCounter++
        trip.id = id
        trips[id] = trip
    }
    
    func findTrip(id:Int) -> Trip? {
        return trips[id]
    }
    
    //: TODO sort trips
    func findAll() -> [Trip] {
        return [Trip](trips.values)
    }
    
}