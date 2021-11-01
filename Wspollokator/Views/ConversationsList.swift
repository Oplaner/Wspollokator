//
//  ConversationsList.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 31/10/2021.
//

import SwiftUI

struct ConversationsList: View {
    // Temporarily @State, ultimately @StateObject.
    @State var summaries: [ConversationSummary]
    
    func formatConversationSummary(_ summary: ConversationSummary) -> (images: [Image?], headline: String, caption: String, includesStarButton: Bool, isStarred: Bool?) {
        let images: [Image?]
        let headline: String
        let caption: String
        let includesStarButton: Bool
        let isStarred: Bool?
        let id = UUID() // Temporary ID of ourselves.
        
        if summary.participants.count == 1 {
            let user = summary.participants.first!
            
            images = [summary.participants.first!.avatarImage]
            headline = "\(user.name) \(user.surname)"
            
            // TODO: Add comparison against our own user ID.
            if summary.recentMessageAuthorID == id {
                caption = "Ty: \(summary.recentMessageContent)"
            } else {
                caption = "\(user.name): \(summary.recentMessageContent)"
            }
            
            includesStarButton = true
            isStarred = user.isSaved
        } else {
            images = [summary.participants[0].avatarImage, summary.participants[1].avatarImage]
            headline = summary.participants.map({ $0.name }).joined(separator: ", ")
            
            // TODO: Add comparison against our own user ID.
            if summary.recentMessageAuthorID == id {
                caption = "Ty: \(summary.recentMessageContent)"
            } else {
                let user = summary.participants.first(where: { $0.id == summary.recentMessageAuthorID })!
                caption = "\(user.name): \(summary.recentMessageContent)"
            }
            
            includesStarButton = false
            isStarred = nil
        }
        
        return (images, headline, caption, includesStarButton, isStarred)
    }
    
    var body: some View {
        NavigationView {
            List {
                if summaries.count == 0 {
                    Text("Brak wiadomości")
                        .foregroundColor(Appearance.textColor)
                } else {
                    ForEach(summaries) { summary in
                        // Temporary destination!
                        NavigationLink(destination: ContentView()) {
                            let format = formatConversationSummary(summary)
                            ListRow(images: format.images, headline: format.headline, caption: format.caption, includesStarButton: format.includesStarButton, isStarred: format.isStarred)
                        }
                    }
                    .onDelete {
                        // TODO: Remove ourselves from conversation (using conversationID).
                        summaries.remove(atOffsets: $0)
                    }
                }
            }
            .navigationTitle("Wiadomości")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ConversationsList_Previews: PreviewProvider {
    static var summaries: [ConversationSummary] {
        let john = UserProfile_Previews.users[0]
        let anna = UserProfile_Previews.users[1]
        return [
            ConversationSummary(conversationID: UUID(), participants: [john, anna], recentMessageAuthorID: anna.id, recentMessageContent: "Lorem ipsum dolor sit amet!"),
            ConversationSummary(conversationID: UUID(), participants: [john], recentMessageAuthorID: UUID(), recentMessageContent: "altum, videtur 🎉")
        ]
    }
    
    static var previews: some View {
        ConversationsList(summaries: summaries)
            
    }
}
