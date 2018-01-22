//
//  DataManager.swift
//  Erotiq
//
//  Created by Andrey Buksha on 26.07.17.
//  Copyright © 2017 Andrey Bucksha. All rights reserved.
//

import Foundation
import CoreData


protocol ManagedObjectProtocol {
    associatedtype Entity
    func toEntity() -> Entity?
}


protocol ManagedObjectConvertible {
    associatedtype ManagedObject
    func toManagedObject(in context: NSManagedObjectContext) -> ManagedObject?
    func deleteManagedObject(in context: NSManagedObjectContext)
}



