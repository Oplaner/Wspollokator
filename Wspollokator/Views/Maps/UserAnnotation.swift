//
//  UserAnnotation.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 07.12.21.
//

import SwiftUI

struct UserAnnotation: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let overlayWidth: CGFloat = 2
    
    var user: User
    var size: CGFloat
    
    var body: some View {
        if user == viewModel.currentUser! {
            ZStack {
                Circle()
                    .frame(width: size, height: size)
                    .foregroundColor(.white)
                    .overlay(Circle().stroke(Color.gray, lineWidth: overlayWidth))
                Text("TY")
                    .font(.headline)
            }
        } else {
            NavigationLink {
                UserProfile(user: user)
            } label: {
                Avatar(image: user.avatarImage, size: size)
                    .overlay(Circle().stroke(Color.gray, lineWidth: overlayWidth))
            }
        }
    }
}

struct MapAnnotation_Previews: PreviewProvider {
    static let previewSize: CGFloat = 50
    
    static var previews: some View {
        Group {
            UserAnnotation(user: ViewModel.sampleUsers[0], size: previewSize)
            UserAnnotation(user: ViewModel.sampleUsers[1], size: previewSize)
        }
        .environmentObject(ViewModel.sample)
        .previewLayout(.fixed(width: previewSize + 10, height: previewSize + 10))
    }
}
