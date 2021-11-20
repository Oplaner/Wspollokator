//
//  Conversation.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import Foundation

class Conversation: Identifiable {
    let id: Int
    
    var participants: [User]
    var messages: [Message]
    
    var recentMessage: Message {
        messages.max(by: { $0.timeSent > $1.timeSent })!
    }
    
    init(id: Int, participants: [User], messages: [Message]) {
        self.id = id
        self.participants = participants
        self.messages = messages
    }
}
