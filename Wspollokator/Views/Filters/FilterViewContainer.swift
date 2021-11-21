//
//  FilterContainerView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 12/11/2021.
//

import SwiftUI

struct FilterViewContainer: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var targetDistance: Double
    @Binding var preferencesSource: [FilterOption: FilterAttitude]
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    FilterView(targetDistance: $targetDistance, preferencesSource: $preferencesSource)
                }
                
                if viewModel.searchTargetDistance != viewModel.currentUser!.targetDistance || viewModel.searchPreferences != viewModel.currentUser!.preferences {
                    Section {
                        Button {
                            withAnimation {
                                viewModel.searchTargetDistance = viewModel.currentUser!.targetDistance
                                viewModel.searchPreferences = viewModel.currentUser!.preferences
                            }
                        } label: {
                            Text("Ustaw zgodnie z moimi preferencjami")
                                .foregroundColor(Appearance.buttonColor)
                        }
                    }
                }
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(Appearance.textColor)
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
        FilterViewContainer(targetDistance: .constant(5), preferencesSource: .constant([.animals: .positive, .smoking: .negative]))
            .environmentObject(ViewModel.sample)
    }
}
