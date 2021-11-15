//
//  Message.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import Foundation

struct Message: Identifiable, Equatable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return true
    }
    
    let id = UUID()
    
    let user: User
    let content: String
    let time: Date
}
