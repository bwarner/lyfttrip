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
        tripDao = TripMemory()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testStartTrip() {
        
        switch tripDao.startTrip() {
            case let .Value(trip):
                NSLog("Create trip \(trip)")
        case let .Error(error):
                XCTFail("Failed to create trip: \(error)")
        }
        
    }

    func testAddDetail() {
    
        let result = tripDao.startTrip().map { (trip:Trip) -> Result<TripDetail> in
            let detail = TripDetail(trip: trip, timestamp: NSDate(), longitude: 100, latitude: 100)
            return self.tripDao.add(detail, forTrip: trip)
            }.flatMap { (result:Result<TripDetail>) -> Result<Trip> in
                result.map(<#T##f: TripDetail -> U##TripDetail -> U#>)
                if let id = detail.trip.id, trip = tripDao.trip(id) {
                    return Result.Value(trip)
                }
                return Result.Error(NSError(domain: "Error", code: 0, userInfo:nil))
        }
        
    }

}
