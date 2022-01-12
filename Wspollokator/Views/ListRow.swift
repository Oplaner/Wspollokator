//
//  ListRow.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 29/10/2021.
//

import SwiftUI

struct ListRow: View {
    @EnvironmentObject var viewModel: ViewModel
    
    let height: CGFloat = 60
    let padding: CGFloat = 10
    let outlineWidth: CGFloat = 3
    
    var images: [Image?]
    var headline: String
    var caption: String?
    var includesStarButton: Bool
    var relevantUser: User?
    
    var body: some View {
        HStack(spacing: padding) {
            if images.count == 2 /* Group conversations. */ {
                let avatarSize = 2 * height / 3
                
                HStack(spacing: 0) {
                    Avatar(image: images[0], size: avatarSize)
                        .overlay(Circle().stroke(Color(uiColor: .secondarySystemGroupedBackground), lineWidth: outlineWidth))
                    Avatar(image: images[1], size: avatarSize)
                        .overlay(Circle().stroke(Color(uiColor: .secondarySystemGroupedBackground), lineWidth: outlineWidth))
                        .offset(x: -0.5 * avatarSize, y: -0.5 * avatarSize)
                }
                .padding(.trailing, -0.5 * avatarSize)
                .padding(.top, 0.5 * avatarSize)
            } else if images.count == 1 /* Single person avatar. */ {
                Avatar(image: images.first!, size: height)
                    .overlay(Circle().stroke(Color(uiColor: .secondarySystemGroupedBackground), lineWidth: outlineWidth))
            } else /* Default. */ {
                Avatar(size: height)
                    .overlay(Circle().stroke(Color(uiColor: .secondarySystemGroupedBackground), lineWidth: outlineWidth))
            }
            
            VStack(alignment: .leading) {
                Text(headline)
                    .lineLimit(2)
                
                if caption != nil {
                    Text(caption!)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            if includesStarButton && relevantUser != nil {
                Button {
                    Task {
                        if viewModel.currentUser!.savedUsers.contains(relevantUser!) {
                            await viewModel.changeCurrentUserSavedList(byRemoving: relevantUser!)
                        } else {
                            await viewModel.changeCurrentUserSavedList(byAdding: relevantUser!)
                        }
                    }
                } label: {
                    Image(systemName: viewModel.currentUser!.savedUsers.contains(relevantUser!) ? "star.fill" : "star")
                        .frame(width: 50, height: 50, alignment: .center)
                        .font(.system(size: 25))
                }
                .buttonStyle(.borderless)
            }
        }
        .padding(.vertical, padding)
    }
}

struct ListRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ListRow(images: [Image("avatar2"), nil], headline: "Anna, Carol", caption: "Anna: lorem ipsum...", includesStarButton: false)
            ListRow(images: [Image("avatar3")], headline: "Mark Williams", caption: "1,4 km", includesStarButton: true, relevantUser: ViewModel.sampleUsers[2])
        }
        .environmentObject(ViewModel.sample)
        .previewLayout(.fixed(width: 300, height: 80))
    }
}
