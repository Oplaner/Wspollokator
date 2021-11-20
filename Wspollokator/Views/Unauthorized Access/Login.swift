//
//  Login.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingSignUpView = false
    
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
                    SecureField("Hasło", text: $password)
                }
                .padding([.top, .bottom, .leading], 5)
                .background(.white)
                .cornerRadius(8)
                .padding(.horizontal, 40)
            }
            
            Button {
                // TODO: Authenticate user.
            } label: {
                Text("Zaloguj się")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Appearance.textColor)
                    .cornerRadius(8)
            }
            
            Spacer()
            
            Button {
                isShowingSignUpView = true
            } label: {
                Text("Załóż konto")
                    .foregroundColor(Appearance.textColor)
                    .padding(.bottom, 20)
            }
        }
        .background(Appearance.backgroundColor)
        .sheet(isPresented: $isShowingSignUpView) {
            SignUp()
        }
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
