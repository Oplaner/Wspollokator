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
    
    static let avatarSize: CGFloat = 160
    
    let padding: CGFloat = 20
    
    var user: User
    @State private var nearestLocationName: String?
    @State private var isShowingNewRatingView = false
    @State private var isShowingConversationView = false
    
    /// An existing conversation with `user` or a template for a new one.
    private var conversation: Conversation {
        viewModel.conversations.filter({ $0.participants.count == 2 && $0.participants.contains(user) }).first ?? Conversation(id: 0, participants: [viewModel.currentUser!, user], messages: [])
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: padding) {
                ZStack(alignment: .bottomTrailing) {
                    Avatar(image: user.avatarImage, size: UserProfile.avatarSize)
                    
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color(uiColor: .systemBackground))
                        
                        Button {
                            Task {
                                if viewModel.currentUser!.savedUsers.contains(user) {
                                    await viewModel.changeCurrentUserSavedList(removing: user)
                                } else {
                                    await viewModel.changeCurrentUserSavedList(adding: user)
                                }
                            }
                        } label: {
                            Image(systemName: viewModel.currentUser!.savedUsers.contains(user) ? "star.fill" : "star")
                                .frame(width: 50, height: 50, alignment: .center)
                                .font(.system(size: 25))
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
                                .foregroundColor(.secondary)
                        } else {
                            Text(String.localizedStringWithFormat("%.1f km", distance))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
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
                
                Divider()
                
                HStack {
                    Text("Średnia ocena")
                        .bold()
                    Spacer()
                    
                    if user.ratings.count == 0 {
                        Text("—")
                            .bold()
                            .foregroundColor(.secondary)
                    } else {
                        RatingStars(score: .constant(user.averageScore), isInteractive: false)
                    }
                }
                
                if user.ratings.count == 0 {
                    Button("Dodaj opinię") {
                        isShowingNewRatingView = true
                    }
                } else {
                    NavigationLink("Pokaż opinie (\(user.ratings.count))") {
                        RatingList(relevantUser: user)
                    }
                }
                
                Divider()
                
                NavigationLink(isActive: $isShowingConversationView) {
                    ConversationView(conversation: conversation)
                } label: {
                    Button {
                        isShowingConversationView = true
                    } label: {
                        Text("Wyślij wiadomość")
                            .bold()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .padding(padding)
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if viewModel.isUpdatingSavedList {
                    ProgressView()
                }
            }
        }
        .sheet(isPresented: $isShowingNewRatingView) {
            NewRating(relevantUser: user)
        }
        .task {
            nearestLocationName = await user.fetchNearestLocationName()
        }
    }
}

struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            UserProfile(user: ViewModel.sampleUsers[1])
                .environmentObject(ViewModel.sample)
        }
    }
}
