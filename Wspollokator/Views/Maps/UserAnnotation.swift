//
//  UserAnnotation.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 07.12.21.
//

import SwiftUI

struct UserAnnotation: View {
    let overlayWidth: CGFloat = 2
    
    var user: User
    var isCurrentUser: Bool
    var size: CGFloat
    
    var body: some View {
        if isCurrentUser {
            ZStack {
                Circle()
                    .frame(width: size, height: size)
                    .foregroundColor(Color(uiColor: .systemBackground))
                    .overlay(Circle().stroke(.gray, lineWidth: overlayWidth))
                Text("TY")
                    .font(.headline)
            }
        } else {
            NavigationLink {
                UserProfile(user: user)
            } label: {
                Avatar(image: user.avatarImage, size: size)
                    .overlay(Circle().stroke(.gray, lineWidth: overlayWidth))
            }
        }
    }
}

struct MapAnnotation_Previews: PreviewProvider {
    static let previewSize: CGFloat = 50
    
    static var previews: some View {
        Group {
            UserAnnotation(user: ViewModel.sampleUsers[0], isCurrentUser: true, size: previewSize)
            UserAnnotation(user: ViewModel.sampleUsers[1], isCurrentUser: false, size: previewSize)
        }
        .previewLayout(.fixed(width: previewSize + 10, height: previewSize + 10))
    }
}
