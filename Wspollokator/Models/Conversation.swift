//
//  Conversation.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import Foundation

struct Conversation: Identifiable {
    let id: Int
    var participantsIDs: [Int]
    var messages: [Message]
    
    func generateSummary() -> ConversationSummary {
        let recentMessage = messages.max(by: { $0.timeSent > $1.timeSent })!
        return ConversationSummary(id: UUID(), conversationID: id, participantsIDs: participantsIDs, recentMessageAuthorID: recentMessage.authorID, recentMessageContent: recentMessage.content, recentMessageTimeSent: recentMessage.timeSent)
    }
}
