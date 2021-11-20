//
//  MyProfile.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct MyProfile: View {
    @EnvironmentObject var viewModel: ViewModel
    
    private var user: User {
        get {
            viewModel.currentUser!
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Avatar(image: user.avatarImage, size: 80)
                        Text("\(user.name) \(user.surname)")
                            .font(.title2)
                    }
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
                } footer: {
                    let negation = viewModel.currentUser!.isSearchable ? "" : "nie "
                    Text("Twój profil \(negation)będzie widoczny w wynikach wyszukiwania.")
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
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Mój profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings()) {
                        Label("Ustawienia", systemImage: "gearshape")
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
