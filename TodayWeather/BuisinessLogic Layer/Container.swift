//
//  Container.swift
//  TodayWeather
//
//  Created by Sergey on 15.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

public final class Container {
    
    private let realm: Realm
    
    
    internal init(realm: Realm) {
        self.realm = realm
    }
    
    public convenience init() throws {
        try self.init(realm: Realm())
    }
    
    public func write(_ block: (WriteTransaction) throws -> Void) throws {
        let transaction = WriteTransaction(realm: realm)
        try realm.write {
            try block(transaction)
        }
    }
    
    public func values<T: Persistable> (_ type: T.Type, matching query: T.Query) -> FetchedResults<T> {
        
        var results = realm.objects(T.ManagedObject.self)
        if let predicate = query.predicate {
            results = results.filter(predicate)
        }
        
        return FetchedResults(results: results)
    }
}
