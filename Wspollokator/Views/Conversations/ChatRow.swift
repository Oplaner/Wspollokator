//
//  ChatRow.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct ChatRow: View {
    var user : User
    var message: String
    var time: Date
    var numOfParticipants: Int
    private var groupedConv: Bool {
        get {
            return numOfParticipants > 1 ? true : false
        }
    }
    
    let avatarSize: CGFloat = 60
    let spacerMinLength: CGFloat = 50
    let spacing: CGFloat = 2
    let padding: CGFloat = 8
    let cornerRadius: CGFloat = 10
    
    func formatCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yy, hh:mm"
        
        return formatter.string(from: time)
    }
    var body: some View {
        HStack() {
                        
            //Temporary cuurent user ID
            if user.id == UserProfile_Previews.users[0].id {
                HStack {
                    Spacer(minLength: spacerMinLength)
                        VStack(alignment: .trailing, spacing: spacing) {
                            Text(message)
                                .foregroundColor(.white)
                                .padding(padding)
                                .background(Color(UIColor.lightGray))
                                .cornerRadius(cornerRadius)
                            Text(formatCurrentDate())
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
//                        Avatar(image: user.avatarImage, size: avatarSize)
                }
            }
            else {
                if groupedConv {
                    HStack {
                        Avatar(image: user.avatarImage, size: avatarSize)
                        VStack(alignment: .leading, spacing: spacing) {
                            Text(message)
                                .foregroundColor(.white)
                                .padding(padding)
                                .background(Appearance.fillColor)
                                .cornerRadius(cornerRadius)
                            Text(formatCurrentDate())
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        Spacer(minLength: spacerMinLength)
                    }
                } else {
                    VStack(alignment: .leading, spacing: spacing) {
                        Text(message)
                            .foregroundColor(.white)
                            .padding(padding)
                            .background(Appearance.fillColor)
                            .cornerRadius(cornerRadius)
                        Text(formatCurrentDate())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                    Spacer(minLength: spacerMinLength)
                }
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ChatRow(user: UserProfile_Previews.users[0], message: "Lorem ipsum", time: Date(), numOfParticipants: 1)
            ChatRow(user: UserProfile_Previews.users[1], message: "Lorem ipsum dolor sit amen, Lorem ipsum dolor sit amen", time: Date(), numOfParticipants: 1)

        }
        .previewLayout(.fixed(width: 400, height: 100))
    }
}
