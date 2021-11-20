//
//  SearchedList.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI

struct SearchedList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var searchedUsers: [User]?
    
    var body: some View {
        List {
            if searchedUsers == nil {
                Text("Aby móc wyszukiwać współlokatorów, ustaw swój punkt")
                    .foregroundColor(Appearance.textColor)
            } else if searchedUsers!.isEmpty {
                Text("Nie znaleziono osób spełniających zadane kryteria")
                    .foregroundColor(Appearance.textColor)
            } else {
                ForEach(searchedUsers!) { user in
                    NavigationLink(destination: UserProfile(user: user)) {
                        ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", caption: String.localizedStringWithFormat("%.1f km", Float(user.distance(from: viewModel.currentUser!)!)), includesStarButton: true, relevantUser: user)
                    }
                }
            }
        }
    }
}

struct SearchedList_Previews: PreviewProvider {
    static var previews: some View {
        SearchedList(searchedUsers: ViewModel.sampleUsers)
            .environmentObject(ViewModel.sample)
    }
}
