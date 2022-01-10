//
//  ListMapSearchView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI

struct ListMapSearchView: View {
    private enum SearchResultsViewMode: String, CaseIterable {
        case list = "Lista"
        case map = "Mapa"
    }
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var viewMode: SearchResultsViewMode = .list
    @State private var isShowingFilters = false
    
    /// Returns a sorted array of users matching the filtering criteria, or nil in case the current user has not set their `pointOfInterest`.
    private var searchResults: [User]? {
        let currentUser = viewModel.currentUser!
        
        guard currentUser.pointOfInterest != nil else { return nil }
        
        var distances = [String: Double]()
        
        return viewModel.users.filter({ user in
            guard user != currentUser && user.isSearchable, let distance = user.distance(from: currentUser), distance - user.targetDistance <= viewModel.searchTargetDistance else { return false }
            
            for option in FilterOption.allCases {
                if viewModel.searchPreferences[option] != .neutral && user.preferences[option] != viewModel.searchPreferences[option] {
                    return false
                }
            }
            
            distances[user.id] = distance
            
            return true
        }).sorted(by: {
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
                    SearchedList(searchResults: searchResults)
                } else if viewMode == .map {
                    MapView(searchResults: searchResults)
                }
            }
            .navigationTitle("Szukaj")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if viewModel.isUpdatingSavedList {
                        ProgressView()
                    }
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingFilters = true
                    } label: {
                        Label("Filtry", systemImage: "slider.horizontal.3")
                    }
                }
            }
            .sheet(isPresented: $isShowingFilters) {
                FilterViewContainer(targetDistance: $viewModel.searchTargetDistance, preferencesSource: $viewModel.searchPreferences)
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
