//
//  SearchedList.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI

struct SearchedList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var searchResults: [User]?
    
    var body: some View {
        List {
            if searchResults == nil {
                Text("Aby móc wyszukiwać współlokatorów, ustaw swój punkt.")
                    .foregroundColor(.secondary)
            } else if searchResults!.isEmpty {
                Text("Nie znaleziono osób spełniających zadane kryteria.")
                    .foregroundColor(.secondary)
            } else {
                ForEach(searchResults!) { user in
                    NavigationLink(destination: UserProfile(user: user)) {
                        ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", caption: viewModel.currentUser!.distanceRange(for: user)!, includesStarButton: true, relevantUser: user)
                    }
                }
            }
        }
    }
}

struct SearchedList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SearchedList(searchResults: ViewModel.sampleUsers)
                .environmentObject(ViewModel.sample)
        }
    }
}
