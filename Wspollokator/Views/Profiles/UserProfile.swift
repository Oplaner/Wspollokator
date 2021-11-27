//
//  UserProfile.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import SwiftUI
import MapKit

struct UserProfile: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.colorScheme) var colorScheme
    
    let padding: CGFloat = 20
    
    var user: User
    @State private var nearestLocationName: String?
    
    var body: some View {
        ScrollView {
            VStack(spacing: padding) {
                ZStack(alignment: .bottomTrailing) {
                    Avatar(image: user.avatarImage, size: 160)
                    
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        
                        Button {
                            viewModel.objectWillChange.send()
                            
                            if let index = viewModel.currentUser!.savedUsers.firstIndex(of: user) {
                                viewModel.currentUser!.savedUsers.remove(at: index)
                            } else {
                                viewModel.currentUser!.savedUsers.append(user)
                            }
                        } label: {
                            Image(systemName: viewModel.currentUser!.savedUsers.contains(user) ? "star.fill" : "star")
                                .frame(width: 50, height: 50, alignment: .center)
                                .font(.system(size: 25))
                                .foregroundColor(Appearance.buttonColor)
                        }
                    }
                }
                
                VStack {
                    Text("\(user.name) \(user.surname)")
                        .font(.title)
                    
                    if let distance = user.distance(from: viewModel.currentUser!) {
                        if let locationName = nearestLocationName {
                            Text(String.localizedStringWithFormat("%.1f km, w pobliżu \(locationName)", distance))
                                .font(.subheadline)
                                .foregroundColor(Appearance.alternateColor)
                        } else {
                            Text(String.localizedStringWithFormat("%.1f km", distance))
                                .font(.subheadline)
                                .foregroundColor(Appearance.alternateColor)
                        }
                    }
                }
                
                Divider()
                
                ForEach(FilterOption.allCases, id: \.self) { filter in
                    HStack {
                        Text(filter.icon)
                            .font(.title)
                        Text(filter.title)
                            .font(.headline)
                        Spacer()
                        Text(user.preferences[filter]!.rawValue)
                            .font(.title2)
                    }
                    
                    Divider()
                }
                
                Text(user.description)
                
                Button("Wyślij wiadomość") {
                    // TODO: Navigation to a new conversation.
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
                .tint(Appearance.buttonColor)
            }
            .padding(padding)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .foregroundColor(Appearance.textColor)
        .task {
            nearestLocationName = await user.fetchNearestLocationName()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile(user: ViewModel.sampleUsers[1])
            .environmentObject(ViewModel.sample)
    }
}
