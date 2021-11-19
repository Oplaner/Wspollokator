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
                        set: { viewModel.currentUser!.isSearchable = $0 }
                    )
                    Toggle("Szukam współlokatora", isOn: binding)
                }
                Section {
                    NavigationLink(destination: Text("Ustawianie punktu")) {
                        Text("Mój punkt")
                    }
                    
                    let distanceBinding = Binding<Double>(
                        get: { viewModel.currentUser!.targetDistance },
                        set: { viewModel.currentUser!.targetDistance = $0 }
                    )
                    let preferencesBinding = Binding<[FilterOption: FilterAttitude]>(
                        get: { viewModel.currentUser!.preferences },
                        set: { viewModel.currentUser!.preferences = $0 }
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
