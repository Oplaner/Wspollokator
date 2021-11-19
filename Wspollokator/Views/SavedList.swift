//
//  SavedList.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import SwiftUI

struct SavedList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                var savedUsers = viewModel.currentUser!.savedUsers
                
                if savedUsers.count == 0 {
                    Text("Brak zapisanych osób")
                        .foregroundColor(Appearance.textColor)
                } else {
                    ForEach(savedUsers) { user in
                        let distance = user.getDistance(from: viewModel.currentUser!)
                        let caption = distance != nil ? String.localizedStringWithFormat("%.1f km", Float(distance!)) : nil
                        
                        NavigationLink(destination: UserProfile(user: user)) {
                            ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", caption: caption, includesStarButton: false, relevantUser: nil)
                        }
                    }
                    .onDelete {
                        viewModel.objectWillChange.send()
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
        SavedList()
            .environmentObject(ViewModel.sample)
    }
}
