//
//  SignUp.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct SignUp: View {
    @State private var name = ""
    @State private var surname = ""
    @State private var email = ""
    @State private var userpassword = ""
    var body: some View {
        NavigationView {
            ZStack {
                
                Appearance.backgroundColor
                    .ignoresSafeArea()
                VStack {
                    Image("pat_mat")
                        .resizable()
                        .frame(width: 300, height: 300, alignment: .center)
                        .clipShape(Circle())
                        .opacity(0.2)
                    Spacer()
                }
                VStack(spacing: 20) {
                    Spacer()
                    Text("Rejestracja")
                        .foregroundColor(Appearance.textColor)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 30)
                    VStack {
                        TextField("Imię", text: $name)
                            .padding([.top, .bottom, .leading], 5)
                            .background()
                            .cornerRadius(8)
                            .padding([.leading, .trailing],  40)
                            .shadow(color: .black, radius: 5)
                        TextField("Nazwisko", text: $surname)
                            .padding([.top, .bottom, .leading], 5)
                            .background()
                            .cornerRadius(8)
                            .padding([.leading, .trailing],  40)
                            .shadow(color: .black, radius: 5)
                        TextField("Adres e-mail", text: $email)
                            .padding([.top, .bottom, .leading], 5)
                            .background()
                            .cornerRadius(8)
                            .padding([.leading, .trailing],  40)
                            .shadow(color: .black, radius: 5)
                        SecureField("Hasło", text: $userpassword)
                            .padding([.top, .bottom, .leading], 5)
                            .background()
                            .cornerRadius(8)
                            .padding([.leading, .trailing],  40)
                            .shadow(color: .black, radius: 5)
                        SecureField("Powtórz hasło", text: $userpassword)
                            .padding([.top, .bottom, .leading], 5)
                            .background()
                            .cornerRadius(8)
                            .padding([.leading, .trailing],  40)
                            .shadow(color: .black, radius: 5)
                    }
                    Button {
                        print("Button tapped")
                    } label: {
                        Text("Załóż konto")
                            .padding(5)
                            .font(.headline)
                            .foregroundColor(Appearance.textColor)
                            .background(Appearance.buttonColor)
                            .cornerRadius(8)
                            .shadow(color: .black, radius: 5)
                    }
                    Spacer()
                    NavigationLink(destination: ContentView())  {
                        Text("Zaloguj się")
                            .foregroundColor(Appearance.textColor)
                            .padding(.bottom, 20)
                    }
                }
            }
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct SignUp_Previews: PreviewProvider {
    static var previews: some View {
        SignUp()
    }
}
