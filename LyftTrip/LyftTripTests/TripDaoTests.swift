//
//  TripDaoTests.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/17/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import XCTest
@testable import LyftTrip

class TripDaoTests: XCTestCase {

    var tripDao:TripDao!
    override func setUp() {
        super.setUp()
        tripDao = TripMemoryDao()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testAddDetail() {
            var trip = Trip()
            let detail = TripDetail(trip: trip, timestamp: NSDate(), longitude: 100, latitude: 100)
            trip.add(detail)
            XCTAssertGreaterThan(trip.details.count,0)
        
    }

}
