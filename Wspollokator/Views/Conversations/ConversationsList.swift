//
//  ConversationsList.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 31/10/2021.
//

import SwiftUI

struct ConversationsList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var isShowingNewConversationSheet = false
    @State private var isShowingConversationView = false
    @State private var newConversationParticipants = [User]()
    
    private var sortedConversations: [Conversation] {
        viewModel.conversations.sorted { $0.recentMessage.timeSent > $1.recentMessage.timeSent }
    }
    
    private func formatConversationRow(_ conversation: Conversation) -> (images: [Image?], headline: String, caption: String, includesStarButton: Bool, relevantUser: User?) {
        let headline: String
        let caption: String
        let includesStarButton: Bool
        let relevantUser: User?
        let currentUser = viewModel.currentUser!
        let participants = conversation.participants.filter { $0 != currentUser }
        let images = participants.prefix(2).map { $0.avatarImage }
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
            ZStack {
                NavigationLink(isActive: $isShowingConversationView) {
                    ConversationView(conversation: Conversation(id: 0, participants: newConversationParticipants, messages: []))
                } label: {}
                
                List {
                    if viewModel.conversations.isEmpty {
                        Text("Brak wiadomości.")
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(sortedConversations) { conversation in
                            NavigationLink(destination: ConversationView(conversation: conversation)) {
                                let format = formatConversationRow(conversation)
                                ListRow(images: format.images, headline: format.headline, caption: format.caption, includesStarButton: format.includesStarButton, relevantUser: format.relevantUser)
                            }
                        }
                    }
                }
                .navigationTitle("Wiadomości")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        if viewModel.isUpdatingSavedList {
                            ProgressView()
                        }
                    }
                    
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isShowingNewConversationSheet = true
                        } label: {
                            Label("Nowa konwersacja", systemImage: "square.and.pencil")
                        }
                    }
                }
                .sheet(isPresented: $isShowingNewConversationSheet) {
                    NewConversation(isShowingConversationView: $isShowingConversationView, newConversationParticipants: $newConversationParticipants)
                }
            }
        }
    }
}

struct ConversationsList_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsList()
            .environmentObject(ViewModel.sample)
    }
}
