//
//  Settings.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 12/11/2021.
//

import SwiftUI

struct Settings: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @Binding var alertType: MyProfile.SettingsAlertType
    @Binding var alertMessage: String
    @Binding var isShowingAlert: Bool
    @State private var inputImage: UIImage?
    @State private var name = ""
    @State private var surname = ""
    @State private var shouldSetInitialUserDetails = true
    @State private var isShowingImagePicker = false
    @State private var isShowingNameChangeView = false
    @State private var isShowingSurnameChangeView = false
    @State private var isUpdatingAvatarImage = false
    @State private var isUpdatingName = false
    @State private var isUpdatingSurname = false
    @State private var isUpdatingDescription = false
    @State private var isShowingConfirmationDialog = false
    
    private func formDidAppear() {
        name = viewModel.currentUser!.name
        surname = viewModel.currentUser!.surname
    }
    
    private func updateAvatarImage() async {
        isUpdatingAvatarImage = true
        
        let image = inputImage == nil ? nil : ViewModel.resizeImage(inputImage!)
        
        if await viewModel.changeCurrentUser(avatarImage: image) {
            viewModel.objectWillChange.send()
            viewModel.currentUser!.avatarImage = image == nil ? nil : Image(uiImage: image!)
        } else {
            alertType = .error
            alertMessage = "Wystąpił błąd podczas aktualizacji zdjęcia. Spróbuj ponownie."
            isShowingAlert = true
        }
        
        isUpdatingAvatarImage = false
        inputImage = nil
    }
    
    private func updateName() async {
        isUpdatingName = true
        name = name.trimmingCharacters(in: .whitespaces)
        
        if name.isEmpty || name == viewModel.currentUser!.name {
            name = viewModel.currentUser!.name
        } else {
            if await viewModel.changeCurrentUser(name: name) {
                viewModel.objectWillChange.send()
                viewModel.currentUser!.name = name
            } else {
                name = viewModel.currentUser!.name
                alertType = .error
                alertMessage = "Wystąpił błąd podczas aktualizacji imienia. Spróbuj ponownie."
                isShowingAlert = true
            }
        }
        
        isUpdatingName = false
    }
    
    private func updateSurname() async {
        isUpdatingSurname = true
        surname = surname.trimmingCharacters(in: .whitespaces)
        
        if surname.isEmpty || surname == viewModel.currentUser!.surname {
            surname = viewModel.currentUser!.surname
        } else {
            if await viewModel.changeCurrentUser(surname: surname) {
                viewModel.objectWillChange.send()
                viewModel.currentUser!.surname = surname
            } else {
                surname = viewModel.currentUser!.surname
                alertType = .error
                alertMessage = "Wystąpił błąd podczas aktualizacji nazwiska. Spróbuj ponownie."
                isShowingAlert = true
            }
        }
        
        isUpdatingSurname = false
    }
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    VStack {
                        Avatar(image: viewModel.currentUser!.avatarImage, size: 80)
                        Button {
                            isShowingConfirmationDialog = true
                        } label: {
                            HStack(spacing: 8) {
                                Text("Zmień zdjęcie")
                                
                                if isUpdatingAvatarImage {
                                    ProgressView()
                                }
                            }
                        }
                        .disabled(isUpdatingAvatarImage)
                    }
                    Spacer()
                }
            }
            
            Section {
                NavigationLink(isActive: $isShowingNameChangeView) {
                    InlineFieldChange(fieldName: "Imię", fieldValue: $name, isPresented: $isShowingNameChangeView)
                } label: {
                    HStack {
                        Text("Imię")
                        Spacer()
                        Text(name)
                            .foregroundColor(.secondary)
                        
                        if isUpdatingName {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
                
                NavigationLink(isActive: $isShowingSurnameChangeView) {
                    InlineFieldChange(fieldName: "Nazwisko", fieldValue: $surname, isPresented: $isShowingSurnameChangeView)
                } label: {
                    HStack {
                        Text("Nazwisko")
                        Spacer()
                        Text(surname)
                            .foregroundColor(.secondary)
                        
                        if isUpdatingSurname {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
                
                NavigationLink {
                    DescriptionChange(alertType: $alertType, alertMessage: $alertMessage, isShowingAlert: $isShowingAlert, isUpdatingDescription: $isUpdatingDescription)
                } label: {
                    HStack {
                        Text("Mój opis")
                        
                        if isUpdatingDescription {
                            Spacer()
                            ProgressView()
                        }
                    }
                }
            }
            
            Section {
                HStack {
                    Text("E-mail")
                    Spacer()
                    Text(viewModel.currentUser!.email)
                        .foregroundColor(.secondary)
                }
                
                NavigationLink {
                    PasswordChange()
                } label: {
                    Text("Hasło")
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("Wyloguj się", role: .destructive) {
                        alertType = .logout
                        alertMessage = "Czy na pewno chcesz się wylogować?"
                        isShowingAlert = true
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Ustawienia")
        .navigationBarTitleDisplayMode(.inline)
        .confirmationDialog("Wybierz akcję", isPresented: $isShowingConfirmationDialog) {
            Button("Wybierz zdjęcie") {
                isShowingImagePicker = true
            }
            
            if viewModel.currentUser!.avatarImage != nil {
                Button("Usuń zdjęcie", role: .destructive) {
                    Task {
                        await updateAvatarImage()
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ImagePicker(image: $inputImage)
        }
        .onAppear {
            if shouldSetInitialUserDetails {
                name = viewModel.currentUser!.name
                surname = viewModel.currentUser!.surname
                shouldSetInitialUserDetails = false
            }
        }
        .onChange(of: inputImage) { newValue in
            if newValue != nil {
                Task {
                    await updateAvatarImage()
                }
            }
        }
        .onChange(of: isShowingNameChangeView) { isShowing in
            if !isShowing {
                Task {
                    await updateName()
                }
            }
        }
        .onChange(of: isShowingSurnameChangeView) { isShowing in
            if !isShowing {
                Task {
                    await updateSurname()
                }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Settings(alertType: .constant(.logout), alertMessage: .constant(""), isShowingAlert: .constant(false))
                .environmentObject(ViewModel.sample)
        }
    }
}
