//
//  Conversation.swift
//  Erotiq
//
//  Created by Andrey Buksha on 04.07.17.
//  Copyright © 2017 Andrey Bucksha. All rights reserved.
//

import Foundation
import SwiftyJSON
import CoreData


struct Conversation {
    var id: String
    var recipientId: String
    
    var lastMessage: Message? {
        return messages.last
    }
    var messages: [Message]
    
    init(id: String, messages: [Message], recipientId: String) {
        self.id = id
        self.messages = messages
        self.recipientId = recipientId
    }
    
    var isCreateOnServer: Bool {
        guard let firstChar = id.characters.first else {return false}
        return firstChar != "-"
    }
    
    init(json: JSON) {
        id = json["id"].stringValue
        
        let messageId = json["last_message"]["id"].stringValue
        let text = json["last_message"]["body"].stringValue
        let senderName = json["last_sender"]["nickname"].stringValue
        let senderId = json["last_sender"]["id"].stringValue
        let type = Message.chatItemType
        
        let lastMessage = Message(uid: messageId,
                              conversationId: id,
                              senderId: senderId,
                              type: type,
                              senderName: senderName,
                              date: Date(),
                              text: text,
                              status: .success)
        
        let savedConv = DataManager.shared.getConversationWithId(id)
        messages = savedConv?.messages ?? [lastMessage]
        
        var users = [User]()
        if let usersArray = json["users"].array {
            for userJson in usersArray {
                let user = User(json: userJson)
                if user.id != UserLoginData.shared.userID {
                    users.append(user)
                } 
            }
        }
        recipientId = users.first?.id ?? ""
    }
}



extension Conversation: ManagedObjectConvertible {
    func toManagedObject(in context: NSManagedObjectContext) -> ConversationMO? {
        guard let conversationMO = ConversationMO.getObject(with: id, from: context) ??
                                   ConversationMO.createObjectInContext(context)
            else {return nil}

        
        conversationMO.id = id
        conversationMO.recipientId = recipientId
        
        let messagesMO = messages.flatMap({$0.toManagedObject(in: context)})
        conversationMO.messages = NSSet(array: messagesMO)
        
        return conversationMO
    }
    
    func deleteManagedObject(in context: NSManagedObjectContext) {
        guard let conversationMO = ConversationMO.getObject(with: id, from: context) else {return}
        context.delete(conversationMO)
    }
}
