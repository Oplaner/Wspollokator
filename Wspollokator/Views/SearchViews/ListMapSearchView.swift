//
//  ListMapSearchView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI

struct ListMapSearchView: View {
    @State private var selectedSegmentType: SelectedSegmentType = .list
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("Choose a type", selection: $selectedSegmentType) {
                    ForEach(SelectedSegmentType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(EdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8))
                
                Spacer()
                
                if selectedSegmentType == .list {
                    SearchedList(searchedUsers: UserProfile_Previews.users)
                } else {
                    MapView()
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("Szukaj")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // TO DO: Action that displays filter view
                    } label: {
                        Text("Filtry")
                    }
                }
            }
            
            
        }
    }
}

enum SelectedSegmentType: String, CaseIterable {
    case list = "Lista"
    case map = "Mapa"
}

struct ListMapSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ListMapSearchView()
    }
}
