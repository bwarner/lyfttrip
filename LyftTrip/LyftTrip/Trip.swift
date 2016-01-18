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

struct Trip {
    var route: String?
    var duration: String?
    var startDate: NSDate?
    var id:Int64?
    var first:CLLocation?
    var last:CLLocation?
}
