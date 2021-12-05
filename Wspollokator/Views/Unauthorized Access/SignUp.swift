//
//  SignUp.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct SignUp: View {
    private enum SignUpAlertType {
        case error
        case success
        
        var title: String {
            switch self {
            case .error: return "Błąd"
            case .success: return "Sukces!"
            }
        }
    }
    
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedFieldNumber: Int?
    
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    @State private var isCreatingUserAccount = false
    @State private var alertType = SignUpAlertType.error
    @State private var alertMessage = ""
    @State private var isShowingAlert = false
    @State private var didCreateUserAccount = false
    
    private var nameTrimmed: String {
        name.trimmingCharacters(in: .whitespaces)
    }
    
    private var surnameTrimmed: String {
        surname.trimmingCharacters(in: .whitespaces)
    }
    
    private var emailTrimmed: String {
        email.trimmingCharacters(in: .whitespaces)
    }
    
    private func createUserAccount() async {
        focusedFieldNumber = nil
        isCreatingUserAccount = true
        
        do {
            if try await viewModel.createUserAccount(name: nameTrimmed, surname: surnameTrimmed, email: emailTrimmed, password1: password1, password2: password2) {
                alertType = .success
                alertMessage = "Twoje konto zostało pomyślnie utworzone. Teraz nastąpi automatyczne logowanie."
            } else {
                alertType = .error
                alertMessage = "Wystąpił błąd. Spróbuj ponownie."
            }
        } catch {
            alertType = .error
            
            switch error as! ViewModel.SignUpError {
            case .emailAlreadyTaken:
                alertMessage = "Wprowadzony adres e-mail jest już zajęty przez innego użytkownika."
            case .unmatchingPasswords:
                alertMessage = "Podane hasła są niezgodne."
            }
        }
        
        isShowingAlert = true
        isCreatingUserAccount = false
    }
    
    var body: some View {
        ZStack {
            VStack {
                Image("pat_mat")
                    .resizable()
                    .frame(width: 300, height: 300)
                    .clipShape(Circle())
                    .opacity(0.2)
                Spacer()
            }
            
            VStack {
                Spacer()
                
                Text("Rejestracja")
                    .foregroundColor(Appearance.textColor)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack {
                    Group {
                        TextField("Imię", text: $name)
                            .focused($focusedFieldNumber, equals: 1)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedFieldNumber = 2
                            }
                        
                        TextField("Nazwisko", text: $surname)
                            .focused($focusedFieldNumber, equals: 2)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedFieldNumber = 3
                            }
                        
                        TextField("Adres e-mail", text: $email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .focused($focusedFieldNumber, equals: 3)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedFieldNumber = 4
                            }
                        
                        SecureField("Hasło", text: $password1)
                            .focused($focusedFieldNumber, equals: 4)
                            .submitLabel(.next)
                            .onSubmit {
                                focusedFieldNumber = 5
                            }
                        
                        SecureField("Powtórz hasło", text: $password2)
                            .focused($focusedFieldNumber, equals: 5)
                            .submitLabel(.done)
                            .onSubmit {
                                focusedFieldNumber = nil
                            }
                    }
                    .padding([.top, .bottom, .leading], 5)
                    .foregroundColor(Appearance.textColor)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                }
                
                HStack(spacing: 8) {
                    Button {
                        Task {
                            await createUserAccount()
                        }
                    } label: {
                        Text("Załóż konto")
                            .font(.headline)
                            .bold()
                            .foregroundColor(Appearance.textColor)
                    }
                    .disabled(didCreateUserAccount || isCreatingUserAccount || nameTrimmed.isEmpty || surnameTrimmed.isEmpty || emailTrimmed.isEmpty || password1.isEmpty || password2.isEmpty)
                    
                    if isCreatingUserAccount {
                        ProgressView()
                    }
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Zaloguj się")
                        .foregroundColor(Appearance.textColor)
                        .padding(.bottom, 20)
                }
                .disabled(didCreateUserAccount || isCreatingUserAccount)
            }
        }
        .background(Appearance.backgroundColor)
        .alert(alertType.title, isPresented: $isShowingAlert) {
            if alertType == .success {
                Button("OK") {
                    viewModel.isUserAuthenticated = true
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
            .environmentObject(ViewModel.sample)
    }
}
