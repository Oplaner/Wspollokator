//
//  Login.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct Login: View {
    let padding: CGFloat = 20
    @State private var email = ""
    @State private var userpassword = ""
    var body: some View {
        NavigationView {
            ZStack() {
                Appearance.backgroundColor
                    .ignoresSafeArea()
                VStack(spacing: padding) {
                    Image("pat_mat")
                        .resizable()
                        .frame(width: 200, height: 200, alignment: .center)
                        .clipShape(Circle())
                    Text("WSPÓŁLOKATORZY")
                        .foregroundColor(Appearance.textColor)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    VStack {
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
                    }
                    Button {
                        print("Button tapped")
                    } label: {
                        Text("Zaloguj się")
                            .padding(5)
                            .font(.headline)
                            .foregroundColor(Appearance.textColor)
                            .background(Appearance.buttonColor)
                            .cornerRadius(8)
                            .shadow(color: .black, radius: 5)
                    }
                    Spacer()
                    NavigationLink(destination: ContentView())  {
                        Text("Załóż konto")
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

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
