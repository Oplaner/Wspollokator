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
    
    @State private var isSearchable = false
    @State private var targetDistance = ViewModel.defaultTargetDistance
    @State private var isChangingTargetDistance = false
    @State private var preferences = ViewModel.defaultPreferences
    @State private var alertType = SettingsAlertType.logout
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    @State private var isUpdating = false
    
    private func viewDidAppear() {
        isSearchable = viewModel.currentUser!.isSearchable
        targetDistance = viewModel.currentUser!.targetDistance
        preferences = viewModel.currentUser!.preferences
    }
    
    private func updateSearchableState() async {
        guard isSearchable != viewModel.currentUser!.isSearchable else { return }
        isUpdating = true
        
        if await viewModel.changeCurrentUser(searchableState: isSearchable) {
            viewModel.objectWillChange.send()
            viewModel.currentUser!.isSearchable = isSearchable
        } else {
            isSearchable = viewModel.currentUser!.isSearchable
            alertType = .error
            alertMessage = "Wystąpił błąd podczas aktualizacji statusu widoczności. Spróbuj ponownie."
            isShowingAlert = true
        }
        
        isUpdating = false
    }
    
    private func updateTargetDistance() async {
        guard targetDistance != viewModel.currentUser!.targetDistance else { return }
        isUpdating = true
        
        if await viewModel.changeCurrentUser(targetDistance: targetDistance) {
            viewModel.objectWillChange.send()
            viewModel.currentUser!.targetDistance = targetDistance
        } else {
            targetDistance = viewModel.currentUser!.targetDistance
            alertType = .error
            alertMessage = "Wystąpił błąd podczas aktualizacji preferowanej odległości. Spróbuj ponownie."
            isShowingAlert = true
        }
        
        isUpdating = false
    }
    
    private func updatePreferences() async {
        guard preferences != viewModel.currentUser!.preferences else { return }
        isUpdating = true
        
        if await viewModel.changeCurrentUser(preferences: preferences) {
            viewModel.objectWillChange.send()
            viewModel.currentUser!.preferences = preferences
        } else {
            preferences = viewModel.currentUser!.preferences
            alertType = .error
            alertMessage = "Wystąpił błąd podczas aktualizacji preferencji. Spróbuj ponownie."
            isShowingAlert = true
        }
        
        isUpdating = false
    }
    
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
                    
                    HStack {
                        Text("Średnia ocena")
                        Spacer()
                        
                        if viewModel.currentUser!.ratings.count == 0 {
                            Text("—")
                                .foregroundColor(.secondary)
                        } else {
                            RatingStars(score: .constant(viewModel.currentUser!.averageScore), isInteractive: false)
                        }
                    }
                    
                    if viewModel.currentUser!.ratings.count > 0 {
                        NavigationLink("Opinie o mnie (\(viewModel.currentUser!.ratings.count))") {
                            RatingList(relevantUser: viewModel.currentUser!)
                        }
                    }
                }
                Section {
                    Toggle("Szukam współlokatora", isOn: $isSearchable)
                        .tint(Color.accentColor)
                } footer: {
                    let negation = isSearchable ? "" : "nie "
                    Text("Twój profil \(negation)będzie widoczny w wynikach wyszukiwania.")
                }
                Section {
                    NavigationLink("Mój punkt") {
                        MapViewContainer(alertType: $alertType, alertMessage: $alertMessage, isShowingAlert: $isShowingAlert, isUpdating: $isUpdating)
                    }
                    FilterView(targetDistance: $targetDistance, isChangingTargetDistance: $isChangingTargetDistance, preferencesSource: $preferences)
                        .disabled(viewModel.currentUser!.pointOfInterest == nil)
                } header: {
                    Text("Moje preferencje")
                } footer: {
                    if viewModel.currentUser!.pointOfInterest == nil {
                        Text("Aby móc zmieniać preferencje, ustaw swój punkt.")
                    }
                }
            }
            .navigationTitle("Mój profil")
            .onAppear(perform: viewDidAppear)
            .onChange(of: isSearchable) { _ in
                Task {
                    await updateSearchableState()
                }
            }
            .onChange(of: isChangingTargetDistance) { _ in
                if !isChangingTargetDistance {
                    Task {
                        await updateTargetDistance()
                    }
                }
            }
            .onChange(of: preferences) { _ in
                Task {
                    await updatePreferences()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    if isUpdating {
                        ProgressView()
                    }
                }
                
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
