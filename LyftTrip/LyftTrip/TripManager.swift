//
//  TripManager.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/17/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation
import CoreLocation
import AddressBook
import Contacts

protocol TripManagerDelegate {
    func didCreateNewTrip()
    func didUpdateAuthorizationStatus(manager:CLLocationManager, status:CLAuthorizationStatus)
}

class TripManager: NSObject, CLLocationManagerDelegate {
    
    static let SPEED_THRESHOLD = 4.4704
    static let DISTANCE_THRESHOLD = 50.0
    static let TIMEOUT:NSTimeInterval = 10

    var currentTrip:Trip?
    let tripDao:TripDao
    var delegate:TripManagerDelegate?
    var lastMoved:CLLocation?
    var geoCoder = CLGeocoder()
    var timer:NSTimer?
    var distanceMoved:CLLocationDistance = 0
    let formatter:NSDateFormatter
    static let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)

    
    init(tripDao:TripDao) {
        self.tripDao = tripDao
        formatter = NSDateFormatter()
        formatter.dateStyle = .NoStyle
        formatter.timeStyle = .ShortStyle

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            updateLocation(manager, location: location)
        }
    }
    
    private func updateLocation(manager: CLLocationManager, location:CLLocation) -> Bool {
        if (currentTrip == nil) {
            if (location.speed >= TripManager.SPEED_THRESHOLD) {
                NSLog("Trip started")
                currentTrip = Trip()
                resetTimer()
            }
        }
        if let trip = currentTrip  {
            if trip.first == nil {
                trip.first = location
            }
            
            if let lastLocation = lastMoved {
                let distance = location.distanceFromLocation(lastLocation)
                distanceMoved += distance

                NSLog("distance between last moved is \(distanceMoved)")
                if distanceMoved > TripManager.DISTANCE_THRESHOLD {
                    NSLog("Movement Detected")
                    lastMoved = location
                    distanceMoved = 0
                    resetTimer()
                }
                else {
                }
            }
            else {
                lastMoved = location
            }
            trip.last = location
        }
        return true
    }
    
    private func resetTimer() {
        if let timer = timer {
            timer.invalidate()
        }
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(TripManager.TIMEOUT, target: self, selector: Selector("timeout"), userInfo: nil, repeats: false)
    }
    
     func timeout() {
        NSLog("Standing still timer triggered")
        if let currentTrip = currentTrip  {
            timer = nil
            finish(currentTrip) { (trip) in
                self.delegate?.didCreateNewTrip()
            }
        }
    }
    
    func finish(completion:(Trip)->()) {
        if let trip = currentTrip {
            finish(trip, completion: completion)
        }
    }

    private func finish(trip:Trip, completion:(Trip)->()) {
        NSLog("Trip finished")
        var duration = "(N/A)"
        var route = "N/A"
        
        if let start = trip.first, end = trip.last {
            let startStr = formatter.stringFromDate(start.timestamp)
            let endStr = formatter.stringFromDate(end.timestamp)
            let components = TripManager.calendar!.components([.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute], fromDate: start.timestamp, toDate: end.timestamp, options: NSCalendarOptions(rawValue: 0))
            var diff = ""
            if components.day == 0 {
                if (components.hour > 0) {
                    diff += "(\(components.hour)hrs "
                }
                diff +=  "\(components.minute)min"
                duration = NSString(format: "%@-%@ (%@)", startStr, endStr, diff) as String
            }
            
            
            var startAddress = "N/A"
            var endAddress = "N/A"

            geoCoder.reverseGeocodeLocation(start) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                if error == nil {
                    if let placemark = placemarks?.first, addressDictionary = placemark.addressDictionary, street = addressDictionary[kABPersonAddressStreetKey] as? String {
                        startAddress = street
                    }
                }
                self.geoCoder.reverseGeocodeLocation(start) { (placemarks:[CLPlacemark]?, error:NSError?) -> Void in
                    if error == nil {
                        if let placemark = placemarks?.first, addressDictionary = placemark.addressDictionary, street = addressDictionary[kABPersonAddressStreetKey] as? String {
                            endAddress = street
                        }
                    }
                    route = NSString(format: "%@ > %@", startAddress, endAddress) as String
                    trip.route = route
                    trip.duration = duration
                    try! self.tripDao.saveTrip(trip)
                    self.currentTrip = nil
                    completion(trip)
                }
            }
        }        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        if (error.code != 0 ) {
            NSLog("location error \(error)")
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        NSLog("didChangeAuthorizationStatus \(status)")
        if let delegate = delegate {
            if (status != .NotDetermined) {
                delegate.didUpdateAuthorizationStatus(manager, status: status)
            }
            else {
                NSLog("Unexpected status changed to NotDetermined")
            }
        }
    }
}