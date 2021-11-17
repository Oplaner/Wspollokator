//
//  Conversation.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

struct Conversation: Identifiable {
    let id: Int
    var participants: [User]
    var messages: [Message]
}
