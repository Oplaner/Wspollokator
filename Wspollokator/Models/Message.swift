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
    
    var formattedTimeSent: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy, HH:mm"
        formatter.timeZone = .autoupdatingCurrent
        return formatter.string(from: timeSent)
    }
    
    init(id: String, author: User, content: String, timeSent: Date) {
        self.id = id
        self.author = author
        self.content = content
        self.timeSent = timeSent
    }
}
