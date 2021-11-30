//
//  ConversationView.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct ConversationView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let scrollViewPadding: CGFloat = 15
    
    @State private var conversation: Conversation
    @State private var text: String = ""
    @State private var isSendingMessage = false
    @State private var isShowingAlert = false
    
    private var title: String {
        let participants = conversation.participants.filter { $0 != viewModel.currentUser! }
        
        if participants.count == 1 {
            let user = participants.first!
            return "\(user.name) \(user.surname)"
        } else {
            return participants.map({ $0.name }).joined(separator: ", ")
        }
    }
    
    private var sortedMessages: [Message] {
        conversation.messages.sorted(by: { $0.timeSent < $1.timeSent })
    }
    
    init(conversation: Conversation) {
        self.conversation = conversation
    }
    
    private func scrollToBottom(withReader reader: ScrollViewProxy) {
        withAnimation {
            reader.scrollTo("bottom", anchor: .bottom)
        }
    }
    
    private func sendMessage() async {
        isSendingMessage = true
        
        let (createdConversation, sentMessage, success) = await viewModel.sendMessage(text.trimmingCharacters(in: .whitespaces), in: conversation)
        
        if success {
            viewModel.objectWillChange.send()
            
            if createdConversation != nil {
                conversation = createdConversation!
                viewModel.conversations.append(conversation)
            } else {
                conversation.messages.append(sentMessage!)
            }
            
            text = ""
        } else {
            isShowingAlert = true
        }
        
        isSendingMessage = false
    }
    
    var body: some View {
        VStack {
            ScrollViewReader { reader in
                ScrollView {
                    Spacer()
                        .frame(height: scrollViewPadding)
                    
                    ForEach(sortedMessages) { message in
                        ChatRow(message: message, isGroupConversation: conversation.participants.count > 2)
                    }
                    
                    Spacer()
                        .frame(height: scrollViewPadding)
                        .id("bottom")
                }
                .onAppear {
                    scrollToBottom(withReader: reader)
                }
                .onChange(of: conversation.messages.count) { _ in
                    scrollToBottom(withReader: reader)
                }
            }
            
            ZStack(alignment: .trailing) {
                TextField("Wpisz wiadomość", text: $text)
                    .textFieldStyle(.roundedBorder)
                    .foregroundColor(Appearance.textColor)
                    .disabled(isSendingMessage)
                    .submitLabel(.send)
                    .onSubmit {
                        Task {
                            await sendMessage()
                        }
                    }
                
                if isSendingMessage {
                    ProgressView()
                        .offset(x: -8)
                }
            }
            .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
        .alert("Błąd", isPresented: $isShowingAlert, actions: {}) {
            Text("Wystąpił błąd podczas wysyłania wiadomości. Spróbuj ponownie.")
        }
    }
}

struct Conversation_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(conversation: ViewModel.sampleConversations[0])
            .environmentObject(ViewModel.sample)
    }
}
