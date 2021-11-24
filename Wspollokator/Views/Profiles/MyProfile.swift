//
//  MyProfile.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct MyProfile: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Avatar(image: viewModel.currentUser!.avatarImage, size: 80)
                        Text("\(viewModel.currentUser!.name) \(viewModel.currentUser!.surname)")
                            .font(.title2)
                    }
                    .padding(.vertical, 10)
                }
                Section {
                    let binding = Binding<Bool>(
                        get: { viewModel.currentUser!.isSearchable },
                        set: {
                            viewModel.objectWillChange.send()
                            viewModel.currentUser!.isSearchable = $0
                        }
                    )
                    Toggle("Szukam współlokatora", isOn: binding)
                        .tint(Appearance.buttonColor)
                } footer: {
                    let negation = viewModel.currentUser!.isSearchable ? "" : "nie "
                    Text("Twój profil \(negation)będzie widoczny w wynikach wyszukiwania.")
                        .foregroundColor(Appearance.alternateColor)
                }
                Section {
                    NavigationLink(destination: Text("Ustawianie punktu")) {
                        Text("Mój punkt")
                    }
                    
                    let distanceBinding = Binding<Double>(
                        get: { viewModel.currentUser!.targetDistance },
                        set: {
                            viewModel.objectWillChange.send()
                            viewModel.currentUser!.targetDistance = $0
                        }
                    )
                    let preferencesBinding = Binding<[FilterOption: FilterAttitude]>(
                        get: { viewModel.currentUser!.preferences },
                        set: {
                            viewModel.objectWillChange.send()
                            viewModel.currentUser!.preferences = $0
                        }
                    )
                    
                    FilterView(targetDistance: distanceBinding, preferencesSource: preferencesBinding)
                } header: {
                    Text("Moje preferencje")
                        .foregroundColor(Appearance.alternateColor)
                }
            }
            .navigationTitle("Mój profil")
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(Appearance.textColor)
            .onAppear {
                viewModel.objectWillChange.send()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Label("Ustawienia", systemImage: "gear")
                            .foregroundColor(Appearance.textColor)
                    }
                }
            }
        }
    }
}

struct MyProfile_Previews: PreviewProvider {
    static var previews: some View {
        MyProfile()
            .environmentObject(ViewModel.sample)
    }
}
