//
//  Message.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import Foundation

struct Message: Identifiable {
    let id: Int
    let authorID: Int
    let content: String
    let timeSent: Date
}
