//
//  Conversation.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import Foundation

class Conversation: Identifiable, Equatable {
    let id: String
    
    var participants: [User]
    var messages: [Message]
    
    var recentMessage: Message {
        messages.max(by: { $0.timeSent < $1.timeSent })!
    }
    
    init(id: String, participants: [User], messages: [Message]) {
        self.id = id
        self.participants = participants
        self.messages = messages
    }
    
    static func == (lhs: Conversation, rhs: Conversation) -> Bool {
        lhs.id == rhs.id
    }
}
