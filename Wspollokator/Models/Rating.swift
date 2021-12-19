//
//  Rating.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 19.12.21.
//

import Foundation

class Rating: Identifiable {
    let id: Int
    let author: User
    let rating: Int
    let comment: String
    let timeAdded: Date
    
    init(id: Int, author: User, rating: Int, comment: String, timeAdded: Date) {
        self.id = id
        self.author = author
        self.rating = rating
        self.comment = comment
        self.timeAdded = timeAdded
    }
}
