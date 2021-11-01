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
                        NavigationLink(destination: UserProfile(user: user)) {
                            ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", caption: String.localizedStringWithFormat("%.1f km", user.distance), includesStarButton: false)
                        }
                    }
                    .onDelete {
                        savedUsers.remove(atOffsets: $0)
                    }
                }
            }
            .navigationTitle("Zapisane osoby")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct SavedList_Previews: PreviewProvider {
    static var previews: some View {
        SavedList(savedUsers: UserProfile_Previews.users)
    }
}
