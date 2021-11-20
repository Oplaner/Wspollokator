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
                TextField("Adres e-mail", text: $email)
                    .padding([.top, .bottom, .leading], 5)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
                SecureField("Hasło", text: $password)
                    .padding([.top, .bottom, .leading], 5)
                    .background(.white)
                    .cornerRadius(8)
                    .padding(.horizontal, 40)
            }
            
            Button {
                print("Button tapped")
            } label: {
                Text("Zaloguj się")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Appearance.textColor)
                    .cornerRadius(8)
            }
            
            Spacer()
            
            NavigationLink(destination: ContentView())  {
                Text("Załóż konto")
                    .foregroundColor(Appearance.textColor)
                    .padding(.bottom, 20)
            }
        }
        .background(Appearance.backgroundColor)
    }
}

struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}
