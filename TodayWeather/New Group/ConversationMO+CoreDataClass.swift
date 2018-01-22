//
//  ConversationMO+CoreDataClass.swift
//  
//
//  Created by Andrey Buksha on 26.07.17.
//
//

import Foundation
import CoreData

@objc(ConversationMO)
public class ConversationMO: NSManagedObject {
    static let entityName = "ConversationMO"
    static func getObject(with id: String, from context: NSManagedObjectContext) -> ConversationMO? {
        let fetchRequest: NSFetchRequest<ConversationMO> = ConversationMO.fetchRequest()
        
        fetchRequest.predicate = NSPredicate.init(format: "id==%@", id)
        
        if let result = try? context.fetch(fetchRequest), !result.isEmpty {
            return result.first
        } else {
            return nil
        }
    }
    static func createObjectInContext(_ context: NSManagedObjectContext) -> ConversationMO? {
        guard let conversationMO = NSEntityDescription.insertNewObject(forEntityName: ConversationMO.entityName, into: context) as? ConversationMO else {return nil}
        return conversationMO
    }
}


extension ConversationMO: ManagedObjectProtocol {
    func toEntity() -> Conversation? {
        
        guard let conversationId = id else {return nil}
        
        guard let messagesArray = messages?.flatMap({ (any) -> Message? in
            guard let messageMO = any as? MessageMO else {return nil}
            return messageMO.toEntity()
        }).sorted(by: {
            switch ($0.status, $1.status) {
            case (.success, .failed):
                return true
            case (.failed, .success):
                return false
            default:
                return $0.date < $1.date
            }
        }) else {return nil}

        let conversation = Conversation(id: conversationId, messages: messagesArray, recipientId: recipientId ?? "")
        return conversation
    }
}
