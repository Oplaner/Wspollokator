//
//  SavedList.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import SwiftUI

struct SavedList: View {
    // Temporarily @State, ultimately @StateObject.
    @State var savedUsers: [User]
    
    var body: some View {
        NavigationView {
            List {
                if savedUsers.count == 0 {
                    Text("Brak zapisanych osób")
                        .foregroundColor(Appearance.textColor)
                } else {
                    ForEach(savedUsers) { user in
                        NavigationLink(destination: UserProfile()) {
                            ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", caption: String.localizedStringWithFormat("%.1f km", user.distance), includesStarButton: false)
                        }
                    }
                    .onDelete {
                        savedUsers.remove(atOffsets: $0)
                    }
                }
            }
            .navigationTitle("Zapisane osoby")
        }
    }
}

struct SavedList_Previews: PreviewProvider {
    static let users = [
        User(avatarImage: Image("avatar"), name: "John", surname: "Appleseed", distance: 1.4, isSaved: true),
        User(avatarImage: nil, name: "Anna", surname: "Nowak", distance: 2, isSaved: true)
    ]
    
    static var previews: some View {
        SavedList(savedUsers: users)
    }
}
