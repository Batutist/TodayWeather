//
//  MessageMO+CoreDataClass.swift
//  
//
//  Created by Andrey Buksha on 26.07.17.
//
//

import Foundation
import CoreData
import ChattoAdditions

@objc(MessageMO)
public class MessageMO: NSManagedObject {
    static let entityName = "MessageMO"
    static func getObject(with id: String, from context: NSManagedObjectContext) -> MessageMO? {
        let fetchRequest: NSFetchRequest<MessageMO> = MessageMO.fetchRequest()
        
        fetchRequest.predicate = NSPredicate.init(format: "uid==%@", id)
        
        if let result = try? context.fetch(fetchRequest), !result.isEmpty {
            return result.first
        } else {
            return nil
        }
    }
    static func createObjectInContext(_ context: NSManagedObjectContext) -> MessageMO? {
        guard let messageMO = NSEntityDescription.insertNewObject(forEntityName: MessageMO.entityName, into: context) as? MessageMO else {return nil}
        return messageMO
    }
}


extension MessageMO: ManagedObjectProtocol {
    func toEntity() -> Message? {
        
        guard let messageId = uid else {return nil}
        guard let messageConversationId = conversationId else {return nil}
        guard let messageSenderId = senderId else {return nil}
        let messageType =  Message.chatItemType
        guard let messageSenderName = senderName else {return nil}
        guard let messageDate = date as Date? else {return nil}
        guard let messageText = text else {return nil}
        guard let messageStatus = MessageStatus(stringValue: status ?? "") else {return nil}
        
        let user = Message(uid: messageId,
                           conversationId: messageConversationId,
                           senderId: messageSenderId,
                           type: messageType,
                           senderName: messageSenderName,
                           date: messageDate,
                           text: messageText,
                           status: messageStatus)
        return user
    }
}
