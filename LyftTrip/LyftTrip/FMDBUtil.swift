//
//  FMDBUtil.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/17/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation
import FMDB
import CoreLocation

class DBWrapper {
    
    let database:FMDatabase

    let createSQL = "CREATE TABLE IF NOT EXISTS trip (id integer primary key, route text null, duration text route, start blob null, end blob null)"
    
    static func pathForDatabase() -> String  {
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true);
        let directory:String = paths[0] as String
        return "\(directory)/trips.sqlite"
    }
    
    static func wrapper() -> DBWrapper? {
        return DBWrapper(path: pathForDatabase())
    }
    
    init?(path:String) {
        self.database = FMDatabase(path: path)
        if (!self.database.open()) {
            return nil
        }
        database.executeStatements(createSQL)
    }
}


class FMDBTripDao : TripDao {
    
    var database:FMDatabase
    static let insertSQL = "insert into trip(route, duration, start, end) values(?, ?, ?, ?)"
    static let selectSQL = "select id, route, duration, start, end from trip"
    static let deleteSQL = "delete from trip where id = ?"
    
    init(wrapper:DBWrapper) {
        self.database = wrapper.database
    }
    
    func saveTrip(trip:Trip) throws {
        var params = [AnyObject]()
        
        if let route = trip.route {
            params.append(route)
        }
        else {
            params.append(NSNull())
        }
        
        if let duration = trip.duration {
            params.append(duration)
        }
        else {
            params.append(NSNull())
        }
        
        if let start = trip.first {
            let startData = NSKeyedArchiver.archivedDataWithRootObject(start)
            params.append(startData)
        }
        else {
            params.append(NSNull())
        }
        if let end = trip.last {
            let startData = NSKeyedArchiver.archivedDataWithRootObject(end)
            params.append(startData)
        }
        else {
            params.append(NSNull())
        }
        try database.executeUpdate(FMDBTripDao.insertSQL, values: params)
        trip.id = database.lastInsertRowId()
    }
    
    func delete(trip:Trip) throws {
        if let id = trip.id {
            if (!database.executeUpdate(FMDBTripDao.deleteSQL, withArgumentsInArray: [ NSNumber(longLong: id)])) {
                throw database.lastError()
            }
        }
    }

    func findAll() -> [Trip]  {
        var trips = [Trip]()
        do {
            let resultSet =  try database.executeQuery(FMDBTripDao.selectSQL, values: [])
            while resultSet.next() {
                let trip = Trip()
                trip.id = Int64(resultSet.longForColumn("id"))
                trip.duration = resultSet.stringForColumn("duration")
                trip.route = resultSet.stringForColumn("route")
                if let startData = resultSet.dataForColumn("start"), startLocation = NSKeyedUnarchiver.unarchiveObjectWithData(startData) as? CLLocation {
                    trip.first = startLocation
                }
                if let endData = resultSet.dataForColumn("start"), endLocation = NSKeyedUnarchiver.unarchiveObjectWithData(endData) as? CLLocation {
                    trip.last = endLocation
                }
                trips.append(trip)
            }
            resultSet.close()
        }
        catch {
            NSLog("Got error \(error)")
        }
        return trips
    }
    
}