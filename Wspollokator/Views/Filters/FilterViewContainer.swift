//
//  FilterContainerView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 12/11/2021.
//

import SwiftUI

struct FilterViewContainer: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var distance: Double
    @Binding var preferencesSource: [FilterOption: FilterAttitude]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    FilterView(distance: $distance, preferencesSource: $preferencesSource)
                }
                Section {
                    Button {
                        // TODO: Reset filters according to user's preferences
                    } label: {
                        Text("Ustaw zgodnie z moimi preferencjami")
                            .foregroundColor(Appearance.textColor)
                    }
                }
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Gotowe")
                            .foregroundColor(Appearance.textColor)
                            .bold()
                    }
                }
            }
        }
    }
}

struct FilterContainerView_Previews: PreviewProvider {
    static var previews: some View {
        FilterViewContainer(distance: .constant(5), preferencesSource: .constant([.animals: .positive, .smoking: .negative]))
    }
}
