//
//  WriteTransaction.swift
//  TodayWeather
//
//  Created by Sergey on 15.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift

public final class WriteTransaction {
    
    private let realm: Realm
    internal init(realm: Realm) {
        self.realm = realm
    }
    public func add<T:Persistable>(_ value: T, update: Bool) {
        realm.add(value.toManagedObject(), update: update)
    }
    
    public func update<T: Persistable>(_ type: T.Type, values: [T.PropertyValue]) {
        
        var dictionary: [String: Any] = [:]
        
        values.forEach {
            let pair = $0.propertyValuePair
            dictionary[pair.name] = pair.value
        }
        
        realm.create(T.ManagedObject.self, value: dictionary, update: true)
    }
}
