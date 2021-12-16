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
    @State private var inputTargetDistance = ViewModel.defaultTargetDistance
    @State private var inputPreferences = ViewModel.defaultPreferences
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    FilterView(targetDistance: $inputTargetDistance, preferencesSource: $inputPreferences)
                }
                
                if inputTargetDistance != viewModel.currentUser!.targetDistance || inputPreferences != viewModel.currentUser!.preferences {
                    Section {
                        Button {
                            withAnimation {
                                inputTargetDistance = viewModel.currentUser!.targetDistance
                                inputPreferences = viewModel.currentUser!.preferences
                            }
                        } label: {
                            Text("Ustaw zgodnie z moimi preferencjami")
                        }
                    }
                }
            }
            .navigationTitle("Filtry")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                inputTargetDistance = targetDistance
                inputPreferences = preferencesSource
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        targetDistance = inputTargetDistance
                        preferencesSource = inputPreferences
                        dismiss()
                    } label: {
                        Text("Gotowe")
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
