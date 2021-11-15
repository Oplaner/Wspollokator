//
//  ListMapSearchView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI

struct ListMapSearchView: View {
    @State private var selectedSegmentType: SelectedSegmentType = .list
    
    @State private var showFilterView = false
    @State private var filterOffset: CGFloat = UIScreen.main.bounds.height + 40
    
    var body: some View {
        ZStack {
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
                            showFilterView.toggle()
                        } label: {
                            Text("Filtry")
                        }
                    }
                }
                .disabled(showFilterView)
                
                
            }
            
            GeometryReader { geometry in
                VStack {
                    FilterViewContainer(showFilterView: $showFilterView)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .customCornerRadius(24, corners: [.topLeft, .topRight])
                        .offset(y: filterOffset)
                        .onChange(of: showFilterView) { newValue in
                            if newValue {
                                // showing
                                withAnimation {
                                    // half distance fromm top of view
                                    self.filterOffset = geometry.size.height / 2.0
                                }
                            } else {
                                // hiding
                                withAnimation {
                                    // 40 points under of view
                                    self.filterOffset = (geometry.size.height) + 40
                                }
                            }
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
