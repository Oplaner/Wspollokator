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
                ScrollViewReader { reader in
                    ScrollView {
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
                        .padding()
                    }
                }
                .navigationTitle(title)
                .navigationBarTitleDisplayMode(.inline)
                
                TextField("Wpisz wiadomość", text: $text)
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
    static var conversation = Conversation(
        participants: [UserProfile_Previews.users[0]],
        messages: [
            Message(user: UserProfile_Previews.users[0], content: "Lorem ipsum dolor sit amet", time: Date()),
            Message(user: UserProfile_Previews.users[1], content: "Donec et est magna 😜", time: Date()),
            Message(user: UserProfile_Previews.users[0], content: "Nam sollicitudin orci urna", time: Date()),
            Message(user: UserProfile_Previews.users[1], content: "Vestibulum ante ipsum primis in faucibus orci luctus", time: Date()),
            Message(user: UserProfile_Previews.users[0], content: "Nunc ac ex lobortis, tempor lorem eu, consequat tellus 🐶", time: Date()),
            Message(user: UserProfile_Previews.users[1], content: "Praesent", time: Date()),
            Message(user: UserProfile_Previews.users[0], content: "Curabitur rhoncus at ex nec volutpat. Aenean eget purus et justo varius elementum.", time: Date()),
            Message(user: UserProfile_Previews.users[1], content: "Ut consectetur tellus nibh, vel luctus massa fermentum quis. Nam et iaculis mi. Nunc sem nisl, tempus sed interdum consequat, pulvinar at nulla. 🍪", time: Date()),
            Message(user: UserProfile_Previews.users[1], content: "Cras feugiat urna et", time: Date()),
            Message(user: UserProfile_Previews.users[0], content: "Quisque! 🔥", time: Date()),
            Message(user: UserProfile_Previews.users[1], content: "Suspendisse 🎉", time: Date())
        ]
    )
    static var previews: some View {
        ConversationView(conversation: conversation)
            //.environmentObject(observed())
    }
}
