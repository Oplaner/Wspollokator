//
//  ConversationSummary.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 31/10/2021.
//

import Foundation

struct ConversationSummary: Identifiable {
    let id = UUID()
    let conversationID: UUID
    let participants: [User] // Should not contain ourselves.
    let recentMessageAuthorID: UUID
    let recentMessageContent: String
}
