//
//  Conversation.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import Foundation

struct Conversation: Identifiable {
    let id = UUID()
    
    let participants: [User] // Should not contain ourselves.
    let messages: [Message]
}
