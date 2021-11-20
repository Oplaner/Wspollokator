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
            } else if $0.surname != $1.surname {
                return $0.surname < $1.surname
            } else if $0.name != $1.name {
                return $0.name < $1.name
            } else {
                return $0.id < $1.id
            }
        })
        let sortedUsersWithDistanceUndefined = usersWithDistanceUndefined.sorted(by: {
            if $0.surname != $1.surname {
                return $0.surname < $1.surname
            } else if $0.name != $1.name {
                return $0.name < $1.name
            } else {
                return $0.id < $1.id
            }
        })
        
        return sortedUsersWithDistanceDefined + sortedUsersWithDistanceUndefined
    }
    
    var body: some View {
        NavigationView {
            List {
                if viewModel.currentUser!.savedUsers.isEmpty {
                    Text("Brak zapisanych osób")
                        .foregroundColor(Appearance.textColor)
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
                        var destinationIndexSet = IndexSet()
                        
                        for index in indexSet {
                            if let userIndex = viewModel.currentUser!.savedUsers.firstIndex(of: sortedUsers[index]) {
                                destinationIndexSet.insert(userIndex)
                            }
                        }
                        
                        viewModel.objectWillChange.send()
                        viewModel.currentUser!.savedUsers.remove(atOffsets: destinationIndexSet)
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
        SavedList()
            .environmentObject(ViewModel.sample)
    }
}
