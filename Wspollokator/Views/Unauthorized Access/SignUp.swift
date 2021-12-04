//
//  SignUp.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct SignUp: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var password1 = ""
    @State private var password2 = ""
    
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
                        TextField("Nazwisko", text: $surname)
                        TextField("Adres e-mail", text: $email)
                        SecureField("Hasło", text: $password1)
                        SecureField("Powtórz hasło", text: $password2)
                    }
                    .padding([.top, .bottom, .leading], 5)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                }
                
                Button {
                    // TODO: Send a request for new user account.
                } label: {
                    Text("Załóż konto")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Appearance.textColor)
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Zaloguj się")
                        .foregroundColor(Appearance.textColor)
                        .padding(.bottom, 20)
                }
            }
        }
        .background(Appearance.backgroundColor)
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
