//
//  TripDetail.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/16/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation

struct TripDetail {
    var timestamp: NSDate
    var longitude: NSNumber
    var latitude: NSNumber
    var address: String?
    var trip:Trip

    init (trip:Trip, timestamp:NSDate, longitude:Double, latitude:Double) {
        self.timestamp = timestamp
        self.longitude = longitude
        self.latitude = latitude
        self.trip = trip
    }
}
