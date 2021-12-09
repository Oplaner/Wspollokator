//
//  MyProfile.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI
import MapKit

struct MyProfile: View {
    enum SettingsAlertType {
        case logout
        case error
        
        var title: String {
            switch self {
            case .logout: return "Potwierdzenie"
            case .error: return "Błąd"
            }
        }
    }
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var alertType = SettingsAlertType.logout
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    @State private var isUpdatingPointOfInterest = false
    
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
                        .tint(Color.accentColor)
                } footer: {
                    let negation = viewModel.currentUser!.isSearchable ? "" : "nie "
                    Text("Twój profil \(negation)będzie widoczny w wynikach wyszukiwania.")
                }
                Section {
                    NavigationLink {
                        MapViewContainer(alertType: $alertType, alertMessage: $alertMessage, isShowingAlert: $isShowingAlert, isUpdatingPointOfInterest: $isUpdatingPointOfInterest)
                    } label: {
                        HStack {
                            Text("Mój punkt")
                            
                            if isUpdatingPointOfInterest {
                                Spacer()
                                ProgressView()
                            }
                        }
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
            .navigationTitle("Mój profil")
            .onAppear {
                viewModel.objectWillChange.send()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings(alertType: $alertType, alertMessage: $alertMessage, isShowingAlert: $isShowingAlert)) {
                        Label("Ustawienia", systemImage: "gear")
                    }
                }
            }
            .alert(alertType.title, isPresented: $isShowingAlert) {
                switch alertType {
                case .logout:
                    Button("Nie", role: .cancel, action: {})
                    Button("Tak", role: .destructive) {
                        viewModel.logout()
                    }
                case .error:
                    Button("OK", action: {})
                }
            } message: {
                Text(alertMessage)
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
