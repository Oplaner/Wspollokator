//
//  SavedList.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import SwiftUI

struct SavedList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    /// Returns a dictionary, in which keys correspond to users' `id`s and values represent their distances from the current user.
    private func fetchDistances() -> [Int: Double] {
        var distances = [Int: Double]()
        
        for user in viewModel.currentUser!.savedUsers {
            if let distance = user.distance(from: viewModel.currentUser!) {
                distances[user.id] = distance
            }
        }
        
        return distances
    }
    
    /// Sorts current user's `savedUsers` array. Users who have their distance from the current user undefined are in the second part of the final array.
    private func sortedUsers(usingDistances distances: [Int: Double]) -> [User] {
        var usersWithDistanceDefined = [User]()
        var usersWithDistanceUndefined = [User]()
        
        for user in viewModel.currentUser!.savedUsers {
            if distances.keys.contains(user.id) {
                usersWithDistanceDefined.append(user)
            } else {
                usersWithDistanceUndefined.append(user)
            }
        }
        
        let sortedUsersWithDistanceDefined = usersWithDistanceDefined.sorted(by: {
            if distances[$0.id]! != distances[$1.id]! {
                return distances[$0.id]! < distances[$1.id]!
            } else {
                return User.sortingPredicate(user1: $0, user2: $1)
            }
        })
        let sortedUsersWithDistanceUndefined = usersWithDistanceUndefined.sorted(by: User.sortingPredicate)
        
        return sortedUsersWithDistanceDefined + sortedUsersWithDistanceUndefined
    }
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.currentUser!.savedUsers.isEmpty {
                    Text("Brak zapisanych osób.")
                        .foregroundColor(.secondary)
                } else {
                    let distances = fetchDistances()
                    let sortedUsers = sortedUsers(usingDistances: distances)
                    
                    ForEach(sortedUsers) { user in
                        let distance = distances[user.id]
                        let caption = distance != nil ? String.localizedStringWithFormat("%.1f km", distance!) : nil
                        
                        NavigationLink(destination: UserProfile(user: user)) {
                            ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", caption: caption, includesStarButton: false, relevantUser: nil)
                        }
                    }
                    .onDelete { indexSet in
                        Task {
                            for index in indexSet {
                                await viewModel.changeCurrentUserSavedList(removing: sortedUsers[index])
                            }
                        }
                    }
                }
            }
            .navigationTitle("Zapisane osoby")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.isUpdatingSavedList {
                        ProgressView()
                    }
                }
            }
        }
    }
}

struct SavedList_Previews: PreviewProvider {
    static var previews: some View {
        SavedList()
            .environmentObject(ViewModel.sample)
    }
}
