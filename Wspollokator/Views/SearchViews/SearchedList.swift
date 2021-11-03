//
//  SearchedList.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI

struct SearchedList: View {
    // Temporarily @State, ultimately @StateObject.
    @State var searchedUsers: [User]
    
    var body: some View {
        List {
            if searchedUsers.count == 0 {
                Text("Nie znaleziono osób")
                    .foregroundColor(Appearance.textColor)
            } else {
                ForEach(searchedUsers) { user in
                    NavigationLink(destination: UserProfile(user: user)) {
                        ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", caption: String.localizedStringWithFormat("%.1f km", user.distance), includesStarButton: false)
                    }
                }
                .onDelete {
                    searchedUsers.remove(atOffsets: $0)
                }
            }
        }
    }
}

struct SearchedList_Previews: PreviewProvider {
    static var previews: some View {
        SearchedList(searchedUsers: UserProfile_Previews.users)
    }
}
