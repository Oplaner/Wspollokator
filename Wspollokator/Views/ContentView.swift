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
        Group {
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
                .alert("Błąd", isPresented: $viewModel.didReportErrorUpdatingSavedList) {
                    Button("OK") {
                        viewModel.didReportErrorUpdatingSavedList = false
                    }
                } message: {
                    Text("Wystąpił błąd podczas aktualizacji listy zapisanych osób. Spróbuj ponownie.")
                }
                .onReceive(viewModel.userDataTimer) { output in
                    Task {
                        await viewModel.refresh()
                    }
                }
            } else {
                Login()
            }
        }
        .navigationViewStyle(.stack)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ViewModel.sample)
    }
}
