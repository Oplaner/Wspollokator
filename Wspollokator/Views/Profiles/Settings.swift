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
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var inputImage: UIImage?
    @State private var showingImagePicker = false
    @State private var isUpdatingName = false
    @State private var isUpdatingSurname = false
    @State private var isUpdatingEmail = false
    @State private var isUpdatingDescription = false
    @State private var isShowingConfirmationDialog = false
    
    private func formDidAppear() {
        name = viewModel.currentUser!.name
        surname = viewModel.currentUser!.surname
        email = viewModel.currentUser!.email
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
    
    private func updateEmail() async {
        isUpdatingEmail = true
        email = email.trimmingCharacters(in: .whitespaces)
        
        if email.isEmpty || email == viewModel.currentUser!.email {
            email = viewModel.currentUser!.email
        } else {
            do {
                if try await viewModel.changeCurrentUser(email: email) {
                    viewModel.objectWillChange.send()
                    viewModel.currentUser!.email = email
                } else {
                    email = viewModel.currentUser!.email
                    alertType = .error
                    alertMessage = "Wystąpił błąd podczas aktualizacji adresu e-mail. Spróbuj ponownie."
                    isShowingAlert = true
                }
            } catch {
                email = viewModel.currentUser!.email
                alertType = .error
                
                switch error as! ViewModel.EmailChangeError {
                case .emailAlreadyTaken:
                    alertMessage = "Wprowadzony adres e-mail jest już zajęty przez innego użytkownika."
                }
                
                isShowingAlert = true
            }
        }
        
        isUpdatingEmail = false
    }
    
    func loadImage() async {
        guard let inputImage = inputImage else { return }
        
        viewModel.objectWillChange.send()
        
        if await viewModel.changeCurrentUserAvatarImage(avatarImage: inputImage) {
            viewModel.currentUser!.avatarImage = Image(uiImage: inputImage)
        }
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
                            Text("Zmień zdjęcie")
                                .foregroundColor(Appearance.buttonColor)
                        }
                    }
                    Spacer()
                }
            }
            
            Section {
                HStack {
                    Text("Imię")
                        .foregroundColor(Appearance.textColor)
                    Spacer()
                    TextField("Imię", text: $name)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Appearance.alternateColor)
                        .onAppear(perform: formDidAppear)
                        .onSubmit {
                            Task {
                                await updateName()
                            }
                        }
                    
                    if isUpdatingName {
                        Spacer()
                        ProgressView()
                    }
                }
                
                HStack {
                    Text("Nazwisko")
                        .foregroundColor(Appearance.textColor)
                    Spacer()
                    TextField("Nazwisko", text: $surname)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Appearance.alternateColor)
                        .onAppear(perform: formDidAppear)
                        .onSubmit {
                            Task {
                                await updateSurname()
                            }
                        }
                    
                    if isUpdatingSurname {
                        Spacer()
                        ProgressView()
                    }
                }
                
                HStack {
                    Text("E-mail")
                        .foregroundColor(Appearance.textColor)
                    Spacer()
                    TextField("E-mail", text: $email)
                        .multilineTextAlignment(.trailing)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .foregroundColor(Appearance.alternateColor)
                        .onAppear(perform: formDidAppear)
                        .onSubmit {
                            Task {
                                await updateEmail()
                            }
                        }
                    
                    if isUpdatingEmail {
                        Spacer()
                        ProgressView()
                    }
                }
                
                NavigationLink {
                    PasswordChange()
                } label: {
                    Text("Hasło")
                        .foregroundColor(Appearance.textColor)
                }
                
                NavigationLink {
                    DescriptionChange(alertType: $alertType, alertMessage: $alertMessage, isShowingAlert: $isShowingAlert, isUpdatingDescription: $isUpdatingDescription)
                } label: {
                    HStack {
                        Text("Mój opis")
                            .foregroundColor(Appearance.textColor)
                        
                        if isUpdatingDescription {
                            Spacer()
                            ProgressView()
                        }
                    }
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
        .sheet(isPresented: $showingImagePicker){
            ImagePicker(image: $inputImage)
        }
        .onChange(of: inputImage) { _ in
            Task {
                await loadImage()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .submitLabel(.done)
        .confirmationDialog("Wybierz akcję", isPresented: $isShowingConfirmationDialog) {
            Button("Wybierz zdjęcie") {
                showingImagePicker = true
            }
            
            if viewModel.currentUser!.avatarImage != nil {
                Button("Usuń zdjęcie", role: .destructive) {
                    // TODO: Remove avatar image file.
                    viewModel.currentUser!.avatarImage = nil
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
