//
//  ConversationSummary.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 31/10/2021.
//

import Foundation

struct ConversationSummary: Identifiable {
    let id: UUID
    let conversationID: Int
    let participantsIDs: [Int]
    let recentMessageAuthorID: Int
    let recentMessageContent: String
    let recentMessageTimeSent: Date
}
