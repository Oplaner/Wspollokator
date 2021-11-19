//
//  ConversationsList.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 31/10/2021.
//

import SwiftUI

struct ConversationsList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    private func formatConversationRow(_ conversation: Conversation) -> (images: [Image?], headline: String, caption: String, includesStarButton: Bool, relevantUser: User?) {
        let headline: String
        let caption: String
        let includesStarButton: Bool
        let relevantUser: User?
        let currentUser = viewModel.currentUser!
        let participants = conversation.participants.filter { $0 != currentUser }
        let images = participants.map { $0.avatarImage }
        let recentMessage = conversation.recentMessage
        
        if participants.count == 1 {
            relevantUser = participants.first!
            headline = "\(relevantUser!.name) \(relevantUser!.surname)"
            includesStarButton = true
        } else {
            relevantUser = nil
            headline = participants.map({ $0.name }).joined(separator: ", ")
            includesStarButton = false
        }
        
        if recentMessage.author == currentUser {
            caption = "Ty: \(recentMessage.content)"
        } else {
            caption = "\(recentMessage.author.name): \(recentMessage.content)"
        }
        
        return (images, headline, caption, includesStarButton, relevantUser)
    }
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.conversations.count == 0 {
                    Text("Brak wiadomości")
                        .foregroundColor(Appearance.textColor)
                } else {
                    ForEach(viewModel.conversations) { conversation in
                        NavigationLink(destination: ConversationView(conversation: conversation)) {
                            let format = formatConversationRow(conversation)
                            ListRow(images: format.images, headline: format.headline, caption: format.caption, includesStarButton: format.includesStarButton, relevantUser: format.relevantUser)
                        }
                    }
                    .onDelete { indexSet in
                        for index in indexSet {
                            viewModel.conversations[index].participants.removeAll { $0 == viewModel.currentUser! }
                            viewModel.conversations.remove(at: index)
                        }
                    }
                }
            }
            .navigationTitle("Wiadomości")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ConversationsList_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsList()
            .environmentObject(ViewModel.sample)
    }
}
