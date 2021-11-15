//
//  ConversationView.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct ConversationView: View {
    //@EnvironmentObject var obj: observed
    @State private var text :  String = ""
    @State private var value: CGFloat = 0
    var conversation : Conversation
    let title: String
    init(conversation: Conversation)
    {
        self.conversation = conversation
        if conversation.participants.count ==  1{
            let user = conversation.participants[0]
            title = "\(user.name) \(user.surname)"
        }
        else {
            title = conversation.participants.map({ $0.name }).joined(separator: ", ")
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    ScrollViewReader { reader in
                        VStack {
                            ForEach(conversation.messages) { msg in
                                ChatRow(user: msg.user, message: msg.content, time: msg.time, numOfParticipants: conversation.participants.count)
                                    .id(msg.id)
                            }.onChange(of: conversation.messages) { _ in
                                withAnimation {
                                    reader.scrollTo(conversation.messages.last?.id, anchor: .bottom)
                                }
                            }.onAppear {
                                withAnimation {
                                    reader.scrollTo(conversation.messages.last?.id, anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                .padding()
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                
                TextField("Aa", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 15)
                
//                MultiTextField()
//                    .frame(height: self.obj.size < 150 ? self.obj.size : 150)
//                    .padding(.horizontal, 10)
//                    .background(Color(UIColor.lightGray))
//                    .cornerRadius(10)
//                    .padding(.horizontal,  15)
            }
            //Xcode 12 automatic keyboard handling
//                .onAppear {
//                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { (noti) in
//
//                        let value = noti.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
//                        let height = value.height
//
//                        self.value = height
//                    }
//
//                    NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { (noti) in
//                        self.value = 0
//                    }
//                }
        }
        
    }
}
struct Conversation_Previews: PreviewProvider {
    static var conversation = Conversation(participants: [
        UserProfile_Previews.users[0]]
                                    , messages: [
        Message(user: UserProfile_Previews.users[0], content: "Hi", time: Date()),
        Message(user: UserProfile_Previews.users[1], content: "Hello", time: Date()),
        Message(user: UserProfile_Previews.users[0], content: "How are you?", time: Date()),
        Message(user: UserProfile_Previews.users[1], content: "I'm fine, thanks", time: Date()),
        Message(user: UserProfile_Previews.users[0], content: "How are you?", time: Date()),
        Message(user: UserProfile_Previews.users[1], content: "I'm fine, thanks", time: Date()),
        Message(user: UserProfile_Previews.users[0], content: "How are you?", time: Date()),
        Message(user: UserProfile_Previews.users[1], content: "I'm fine, thanks", time: Date()),
        Message(user: UserProfile_Previews.users[0], content: "How are you?", time: Date()),
        Message(user: UserProfile_Previews.users[1], content: "I'm fine, thanks", time: Date()),
        Message(user: UserProfile_Previews.users[0], content: "How are you?", time: Date()),
        Message(user: UserProfile_Previews.users[1], content: "I'm fine, thanks", time: Date()),
        Message(user: UserProfile_Previews.users[1], content: "Last message!", time: Date())
    ])
    static var previews: some View {
        ConversationView(conversation: conversation)
            //.environmentObject(observed())
    }
}
