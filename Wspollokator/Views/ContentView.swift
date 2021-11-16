//
//  ContentView.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 25/10/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ListMapSearchView()
                .tabItem {
                    Label("Szukaj", systemImage: "magnifyingglass")
                }
            
            ConversationsList(summaries: ConversationsList_Previews.summaries)
                .tabItem {
                    Label("Wiadomości", systemImage: "message.fill")
                }
            
            SavedList(savedUsers: UserProfile_Previews.users)
                .tabItem {
                    Label("Zapisane", systemImage: "star.fill")
                }
            
            MyProfile(user: UserProfile_Previews.users[0], distance: 5, preferencesSource: [.animals: .positive, .smoking: .negative])
                .tabItem {
                    Label("Mój profil", systemImage: "person.fill")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
