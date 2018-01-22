//
//  Message.swift
//  Erotiq
//
//  Created by Andrey Buksha on 04.07.17.
//  Copyright © 2017 Andrey Bucksha. All rights reserved.
//

import Foundation
import SwiftyJSON
import Chatto
import ChattoAdditions
import CoreData


class Message: MessageModel {
    static var chatItemType: ChatItemType {
        return "text-message-type"
    }
    
    var conversationId: String!
    var text: String!
    var senderName: String!
    
    init(uid: String, conversationId: String, senderId: String, type: String, senderName: String, date: Date, text: String, status: MessageStatus) {
        self.conversationId = conversationId
        self.text = text
        self.senderName = senderName
        let isIncoming = senderId != UserLoginData.shared.userID
        super.init(uid: uid, senderId: senderId, type: type, isIncoming: isIncoming, date: date, status: status)
    }
    
    convenience init?(json: JSON) {
        let messageId = json["id"].stringValue
        let conversationId = json["conversation"]["id"].stringValue
        
        let senderId = json["user"]["id"].stringValue
        let type = Message.chatItemType
        let senderName = json["user"]["nickname"].stringValue
        let text = json["body"].stringValue
        
        let dateString = json["created_at"].stringValue
        let dateFormatter = DateFormatter.inputServerFormatter
        
        guard let date = dateFormatter.date(from: dateString) else {return nil}
        self.init(uid: messageId, conversationId: conversationId, senderId: senderId, type: type, senderName: senderName, date: date, text: text, status: .success)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension Message: ManagedObjectConvertible {
    
    func toManagedObject(in context: NSManagedObjectContext) -> MessageMO? {
        guard let messageMO = MessageMO.getObject(with: uid, from: context) ??
                              MessageMO.createObjectInContext(context)
            else {return nil}
        
        messageMO.uid = uid
        messageMO.type = type
        messageMO.conversationId = conversationId
        messageMO.text = text
        messageMO.senderId = senderId
        messageMO.senderName = senderName
        messageMO.isIncoming = isIncoming
        messageMO.date = date as NSDate
        messageMO.status = status.stringValue
        
        return messageMO
    }
    
    func deleteManagedObject(in context: NSManagedObjectContext) {
        guard let messageMO = MessageMO.getObject(with: uid, from: context) else {return}
        context.delete(messageMO)
    }
}
