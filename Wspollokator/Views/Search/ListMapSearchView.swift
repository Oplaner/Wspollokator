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
    @State private var viewMode: SearchResultsViewMode = .list
    @State private var isShowingFilters = false
    
    /*
     Temporarily these two variables are marked as @State.
     Ultimately, they will be derived from an environment object.
     */
    @State var distance: Double
    @State var preferencesSource: [FilterOption: FilterAttitude]
    
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
                    SearchedList(searchedUsers: UserProfile_Previews.users)
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
                        FilterViewContainer(distance: $distance, preferencesSource: $preferencesSource)
                    }
                }
            }
        }
    }
}

struct ListMapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ListMapSearchView(distance: 5, preferencesSource: [.animals: .positive, .smoking: .negative])
    }
}
