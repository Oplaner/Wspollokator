//
//  ListMapSearchView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI

enum SearchResultsViewMode: String, CaseIterable {
    case list = "Lista"
    case map = "Mapa"
}

struct ListMapSearchView: View {
    @EnvironmentObject var viewModel: ViewModel
    @State private var viewMode: SearchResultsViewMode = .list
    @State private var isShowingFilters = false
    
    /// Returns an array of users matching the filtering criteria or nil in case the current user has not set their point of interest.
    private var filteredUsers: [User]? {
        get {
            let currentUser = viewModel.currentUser!
            
            guard currentUser.pointOfInterest != nil else { return nil }
            
            return viewModel.users.filter { user in
                guard user != currentUser && user.isSearchable, let distance = user.getDistance(from: currentUser), distance <= currentUser.targetDistance else { return false }
                
                for option in FilterOption.allCases {
                    if currentUser.preferences[option] != .neutral && user.preferences[option] != currentUser.preferences[option] {
                        return false
                    }
                }
                
                return true
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Przełącz widok", selection: $viewMode) {
                    ForEach(SearchResultsViewMode.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                
                if viewMode == .list {
                    SearchedList(searchedUsers: filteredUsers)
                } else if viewMode == .map {
                    MapView()
                }
            }
            .navigationTitle("Szukaj")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        isShowingFilters.toggle()
                    } label: {
                        Text("Filtry")
                    }
                    .sheet(isPresented: $isShowingFilters) {
                        FilterViewContainer(targetDistance: $viewModel.searchTargetDistance, preferencesSource: $viewModel.searchPreferences)
                    }
                }
            }
        }
    }
}

struct ListMapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ListMapSearchView()
            .environmentObject(ViewModel.sample)
    }
}
