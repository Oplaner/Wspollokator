//
//  Rating.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 19.12.21.
//

import Foundation

class Rating: Identifiable {
    let id: String
    let author: User
    let score: Int
    let comment: String
    let timeAdded: Date
    
    init(id: String, author: User, score: Int, comment: String, timeAdded: Date) {
        self.id = id
        self.author = author
        self.score = score
        self.comment = comment
        self.timeAdded = timeAdded
    }
}
