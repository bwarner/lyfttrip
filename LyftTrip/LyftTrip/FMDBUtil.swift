//
//  FMDBUtil.swift
//  LyftTrip
//
//  Created by Byron Warner on 1/17/16.
//  Copyright © 2016 Byron Warner. All rights reserved.
//

import Foundation
import FMDB


enum Result<T> {
    case Value(T)
    case Error(NSError)
}

extension Result {
    func map<U>(f: T -> U) -> Result<U> {
        switch self {
        case let .Value(value):
            return Result<U>.Value(f(value))
        case let .Error(error):
            return Result<U>.Error(error)
        }
    }
    
    static func flatten<T>(result: Result<Result<T>>) -> Result<T> {
        switch result {
        case let .Value(innerResult):
            return innerResult
        case let .Error(error):
            return Result<T>.Error(error)
        }
    }
    
    func flatMap<U>(f: T -> Result<U>) -> Result<U> {
        return Result.flatten(map(f))
    }
}

class DBWrapper {
    
    let database:FMDatabase
    
    init(database:FMDatabase) {
        self.database = database
    }
    
    func executeUpdate(query:String) -> Result<Bool> {
        do {
            try database.executeUpdate(query, values: nil)
        }
        catch {
            return Result.Error(database.lastError())
        }
        return Result.Value(true)
    }
    
}