//
//  PasswordChange.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 23.11.21.
//

import SwiftUI

struct PasswordChange: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedFieldNumber: Int?
    
    @State private var oldPassword: String = ""
    @State private var newPassword1: String = ""
    @State private var newPassword2: String = ""
    @State private var isSettingNewPassword = false
    @State private var isShowingAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var passwordDidChange = false
    
    private func updatePassword() {
        focusedFieldNumber = nil
        isSettingNewPassword = true
        
        do {
            if try viewModel.currentUser!.changePassword(oldPassword: oldPassword, newPassword: newPassword1, confirmation: newPassword2) {
                alertTitle = "Sukces"
                alertMessage = "Twoje hasło zostało zmienione."
                passwordDidChange = true
            } else {
                alertTitle = "Błąd"
                alertMessage = "Wystąpił błąd. Spróbuj ponownie."
            }
        } catch {
            alertTitle = "Błąd"
            
            switch error as! User.PasswordChangeError {
            case .invalidOldPassword:
                alertMessage = "Stare hasło jest nieprawidłowe."
            case .unmatchingNewPasswords:
                alertMessage = "Podane nowe hasła są niezgodne."
            case .oldAndNewPasswordsEqual:
                alertMessage = "Nowe hasło powinno być inne niż stare."
            }
        }
        
        isShowingAlert = true
        isSettingNewPassword = false
    }
    
    var body: some View {
        Form {
            Section {
                SecureField("Stare hasło", text: $oldPassword, prompt: Text("Stare hasło"))
                    .focused($focusedFieldNumber, equals: 1)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedFieldNumber = 2
                    }
                SecureField("Nowe hasło", text: $newPassword1, prompt: Text("Nowe hasło"))
                    .focused($focusedFieldNumber, equals: 2)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedFieldNumber = 3
                    }
                SecureField("Powtórz nowe hasło", text: $newPassword2, prompt: Text("Powtórz nowe hasło"))
                    .focused($focusedFieldNumber, equals: 3)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedFieldNumber = nil
                    }
            }
            .foregroundColor(Appearance.textColor)
            
            Section {
                Button(action: updatePassword) {
                    HStack {
                        Text("Zmień hasło")
                            .tint(Appearance.buttonColor)
                        
                        Spacer()
                        
                        if isSettingNewPassword {
                            ProgressView()
                        }
                    }
                }
                .disabled(oldPassword.isEmpty || newPassword1.isEmpty || newPassword2.isEmpty || isSettingNewPassword)
            }
        }
        .navigationTitle("Zmiana hasła")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.focusedFieldNumber = 1
            }
        }
        .alert(alertTitle, isPresented: $isShowingAlert) {
            if passwordDidChange {
                Button("OK") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
}

struct PasswordChange_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            PasswordChange()
                .environmentObject(ViewModel.sample)
        }
    }
}
