//
//  ContentView.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 25/10/2021.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        if viewModel.isUserAuthenticated {
            TabView {
                ListMapSearchView()
                    .tabItem {
                        Label("Szukaj", systemImage: "magnifyingglass")
                    }
                
                ConversationsList()
                    .tabItem {
                        Label("Wiadomości", systemImage: "message.fill")
                    }
                
                SavedList()
                    .tabItem {
                        Label("Zapisane", systemImage: "star.fill")
                    }
                
                MyProfile()
                    .tabItem {
                        Label("Mój profil", systemImage: "person.fill")
                    }
            }
        } else {
            Login()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel.sample)
    }
}
