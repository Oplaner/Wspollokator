//
//  Message.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import Foundation

class Message: Identifiable {
    let id: String
    let author: User
    let content: String
    let timeSent: Date
    
    init(id: String, author: User, content: String, timeSent: Date) {
        self.id = id
        self.author = author
        self.content = content
        self.timeSent = timeSent
    }
}
