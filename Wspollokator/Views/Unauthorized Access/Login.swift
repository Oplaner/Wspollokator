//
//  Login.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct Login: View {
    @EnvironmentObject var viewModel: ViewModel
    @FocusState private var focusedFieldNumber: Int?
    
    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticating = false
    @State private var isShowingAlert = false
    @State private var alertMessage = ""
    @State private var isShowingSignUpView = false
    @State private var didAuthenticate = false
    
    private var emailTrimmed: String {
        email.trimmingCharacters(in: .whitespaces)
    }
    
    private func authenticateUser() async {
        focusedFieldNumber = nil
        isAuthenticating = true
        
        do {
            if try await viewModel.authenticateUser(withEmail: emailTrimmed, password: password) {
                viewModel.isUserAuthenticated = true
            } else {
                alertMessage = "Wystąpił błąd. Spróbuj ponownie."
                isShowingAlert = true
                isAuthenticating = false
            }
        } catch {
            switch error as! ViewModel.LoginError {
            case .invalidCredentials:
                alertMessage = "Wprowadzone dane są nieprawidłowe."
            }
            
            isShowingAlert = true
            isAuthenticating = false
        }
    }
    
    var body: some View {
        VStack {
            Image("pat_mat")
                .resizable()
                .frame(width: 200, height: 200)
                .clipShape(Circle())
            
            Text("WSPÓŁLOKATORZY")
                .foregroundColor(Appearance.textColor)
                .font(.largeTitle)
                .bold()
            VStack {
                Group {
                    TextField("Adres e-mail", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .focused($focusedFieldNumber, equals: 1)
                        .submitLabel(.next)
                        .onSubmit {
                            focusedFieldNumber = 2
                        }
                    SecureField("Hasło", text: $password)
                        .focused($focusedFieldNumber, equals: 2)
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
                        await authenticateUser()
                    }
                } label: {
                    Text("Zaloguj się")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Appearance.textColor)
                }
                .disabled(didAuthenticate || isAuthenticating || emailTrimmed.isEmpty || password.isEmpty)
                
                if isAuthenticating {
                    ProgressView()
                }
            }
            
            Spacer()
            
            Button {
                focusedFieldNumber = nil
                email = ""
                password = ""
                isShowingSignUpView = true
            } label: {
                Text("Załóż konto")
                    .foregroundColor(Appearance.textColor)
                    .padding(.bottom, 20)
            }
            .disabled(didAuthenticate || isAuthenticating)
        }
        .background(Appearance.backgroundColor)
        .alert("Błąd", isPresented: $isShowingAlert) {
            Button("OK") {
                focusedFieldNumber = 1
            }
        } message: {
            Text(alertMessage)
        }
        .sheet(isPresented: $isShowingSignUpView) {
            SignUp()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
            .environmentObject(ViewModel.sample)
    }
}
