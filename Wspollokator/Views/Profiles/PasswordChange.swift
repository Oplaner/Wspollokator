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
    
    private func updatePassword() async {
        focusedFieldNumber = nil
        isSettingNewPassword = true
        
        do {
            if try await viewModel.changeCurrentUserPassword(oldPassword: oldPassword, newPassword: newPassword1, confirmation: newPassword2) {
                alertTitle = "Sukces"
                alertMessage = "Twoje hasło zostało zmienione."
                passwordDidChange = true
            } else {
                alertTitle = "Błąd"
                alertMessage = "Wystąpił błąd. Spróbuj ponownie."
            }
        } catch {
            alertTitle = "Błąd"
            
            switch error as! ViewModel.PasswordChangeError {
            case .invalidOldPassword:
                alertMessage = "Stare hasło jest nieprawidłowe."
            case .unmatchingNewPasswords:
                alertMessage = "Podane nowe hasła są niezgodne."
            case .oldAndNewPasswordsEqual:
                alertMessage = "Nowe hasło powinno być inne niż stare."
            case .invalidNewPasswordFormat:
                alertMessage = "Podane hasło nie jest wystarczająco bezpieczne. Hasło musi składać się z co najmniej 8 znaków, zawierać przynajmniej 1 literę i nie może tworzyć popularnych wyrażeń."
            }
        }
        
        isShowingAlert = true
        isSettingNewPassword = false
    }
    
    var body: some View {
        Form {
            Section {
                SecureField("Stare hasło", text: $oldPassword)
                    .focused($focusedFieldNumber, equals: 1)
                    .submitLabel(.next)
                    .disabled(isSettingNewPassword)
                    .onSubmit {
                        focusedFieldNumber = 2
                    }
                SecureField("Nowe hasło", text: $newPassword1)
                    .focused($focusedFieldNumber, equals: 2)
                    .submitLabel(.next)
                    .disabled(isSettingNewPassword)
                    .onSubmit {
                        focusedFieldNumber = 3
                    }
                SecureField("Powtórz nowe hasło", text: $newPassword2)
                    .focused($focusedFieldNumber, equals: 3)
                    .submitLabel(.done)
                    .disabled(isSettingNewPassword)
                    .onSubmit {
                        focusedFieldNumber = nil
                    }
            }
            
            Section {
                Button {
                    Task {
                        await updatePassword()
                    }
                } label: {
                    HStack {
                        Text("Zmień hasło")
                        
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
        .navigationBarBackButtonHidden(isSettingNewPassword)
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
