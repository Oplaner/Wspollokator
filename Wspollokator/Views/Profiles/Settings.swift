//
//  Settings.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 12/11/2021.
//

import SwiftUI

struct Settings: View {
    private enum ConfirmationDialogType {
        case avatarChange
        case logout
        
        var dialogTitle: String {
            switch self {
            case .avatarChange: return "Wybierz akcję"
            case .logout: return "Potwierdzenie"
            }
        }
        
        var dialogMessage: String? {
            switch self {
            case .avatarChange: return nil
            case .logout: return "Czy na pewno chcesz się wylogować?"
            }
        }
    }
    
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var isShowingConfirmationDialog = false
    @State private var confirmationDialogType = ConfirmationDialogType.avatarChange
    
    private func formDidAppear() {
        name = viewModel.currentUser!.name
        surname = viewModel.currentUser!.surname
        email = viewModel.currentUser!.email
    }
    
    private func submitForm() {
        let nameTrimmed = name.trimmingCharacters(in: .whitespaces)
        let surnameTrimmed = surname.trimmingCharacters(in: .whitespaces)
        let emailTrimmed = email.trimmingCharacters(in: .whitespaces)
        
        if nameTrimmed.isEmpty {
            name = viewModel.currentUser!.name
        } else {
            name = nameTrimmed
            viewModel.objectWillChange.send()
            viewModel.currentUser!.name = name
        }
        
        if surnameTrimmed.isEmpty {
            surname = viewModel.currentUser!.surname
        } else {
            surname = surnameTrimmed
            viewModel.objectWillChange.send()
            viewModel.currentUser!.surname = surname
        }
        
        if emailTrimmed.isEmpty {
            email = viewModel.currentUser!.email
        } else {
            email = emailTrimmed
            viewModel.objectWillChange.send()
            viewModel.currentUser!.email = email
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
                            confirmationDialogType = .avatarChange
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
                        .onSubmit(submitForm)
                }
                
                HStack {
                    Text("Nazwisko")
                        .foregroundColor(Appearance.textColor)
                    Spacer()
                    TextField("Nazwisko", text: $surname)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(Appearance.alternateColor)
                        .onAppear(perform: formDidAppear)
                        .onSubmit(submitForm)
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
                        .onSubmit(submitForm)
                }
                
                NavigationLink {
                    PasswordChange()
                } label: {
                    Text("Hasło")
                        .foregroundColor(Appearance.textColor)
                }
                
                NavigationLink {
                    DescriptionChange()
                } label: {
                    Text("Mój opis")
                        .foregroundColor(Appearance.textColor)
                }
            }
            
            Section {
                HStack {
                    Spacer()
                    Button("Wyloguj się", role: .destructive) {
                        confirmationDialogType = .logout
                        isShowingConfirmationDialog = true
                    }
                    Spacer()
                }
            }
        }
        .navigationTitle("Ustawienia")
        .navigationBarTitleDisplayMode(.inline)
        .submitLabel(.done)
        .confirmationDialog(confirmationDialogType.dialogTitle, isPresented: $isShowingConfirmationDialog) {
            switch confirmationDialogType {
            case .avatarChange:
                Button("Wybierz zdjęcie") {
                    // TODO: Show image picker.
                }
                
                if viewModel.currentUser!.avatarImage != nil {
                    Button("Usuń zdjęcie", role: .destructive) {
                        // TODO: Remove avatar image file.
                        viewModel.currentUser!.avatarImage = nil
                    }
                }
            case .logout:
                Button("Tak", role: .destructive) {
                    viewModel.logout()
                }
            }
        } message: {
            if let message = confirmationDialogType.dialogMessage {
                Text(message)
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Settings()
                .environmentObject(ViewModel.sample)
        }
    }
}
