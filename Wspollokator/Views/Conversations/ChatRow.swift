//
//  ChatRow.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct ChatRow: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let avatarSize: CGFloat = 40
    let spacerMinLength: CGFloat = 50
    let spacing: CGFloat = 2
    let textPadding: CGFloat = 8
    let rowPadding: CGFloat = 15
    let cornerRadius: CGFloat = 10
    
    var message: Message
    var isGroupConversation: Bool
    
    private func formatTimeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy, hh:mm"
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack {
            if message.author == viewModel.currentUser! {
                Spacer(minLength: spacerMinLength)
                VStack(alignment: .trailing, spacing: spacing) {
                    Text(message.content)
                        .foregroundColor(.white)
                        .padding(textPadding)
                        .background(Color(UIColor.lightGray))
                        .cornerRadius(cornerRadius)
                    Text(formatTimeString(from: message.timeSent))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            } else {
                if isGroupConversation {
                    Avatar(image: message.author.avatarImage, size: avatarSize)
                    VStack(alignment: .leading, spacing: spacing) {
                        Text(message.content)
                            .foregroundColor(.white)
                            .padding(textPadding)
                            .background(Color("FillColor"))
                            .cornerRadius(cornerRadius)
                        Text(formatTimeString(from: message.timeSent))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer(minLength: spacerMinLength)
                } else {
                    VStack(alignment: .leading, spacing: spacing) {
                        Text(message.content)
                            .foregroundColor(.white)
                            .padding(textPadding)
                            .background(Color("FillColor"))
                            .cornerRadius(cornerRadius)
                        Text(formatTimeString(from: message.timeSent))
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Spacer(minLength: spacerMinLength)
                }
            }
        }
        .padding(.horizontal, rowPadding)
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRow(message: ViewModel.sampleConversations[1].messages[3], isGroupConversation: false)
            ChatRow(message: ViewModel.sampleConversations[1].messages[0], isGroupConversation: false)
            ChatRow(message: ViewModel.sampleConversations[0].messages[1], isGroupConversation: true)
        }
        .environmentObject(ViewModel.sample)
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
