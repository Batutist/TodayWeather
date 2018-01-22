//
//  Protocols.swift
//  TodayWeather
//
//  Created by Sergey on 15.01.2018.
//  Copyright © 2018 Sergey. All rights reserved.
//

import Foundation
import RealmSwift


protocol ManagedObjectProtocol {
    associatedtype Entity
    func toEntity() -> Entity?
}


public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    associatedtype Query: QueryType
//    associatedtype PropertyValue: PropertyValueType
    
    init(mangedObject: ManagedObject)
    
    func toManagedObject() -> ManagedObject
}


public protocol QueryType {
    var predicate: NSPredicate? { get }
}



public typealias PropertyValuePair = (name: String, value: Any)
public protocol PropertyValueType {
    var propertyValuePair: PropertyValuePair { get }
}



