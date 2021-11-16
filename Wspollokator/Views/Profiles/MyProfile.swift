//
//  MyProfile.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 04/11/2021.
//

import SwiftUI

struct MyProfile: View {
    //@EnvironmentObject user
    var user : User
    //in future this info will be prvided by vmodel User
    @State private var isLFM: Bool = false
    @State var showSettings: Bool = false
    var body: some View {
        NavigationView{
            List {
                Section {
                    HStack {
                        Avatar(image: user.avatarImage, size: 80)
                        Text("\(user.name) \(user.surname)")
                            .font(.title2)
                    }
                }
                Section {
                    Toggle("Szukam współlokatora", isOn: $isLFM)
                }
                Section {
                    NavigationLink(destination: ContentView()) {
                        Text("Mój punkt")
                    }
                    FilterView(showFilterView: .constant(true))
                } header: {
                    Text("Moje preferencje")
                }
            }
            .listStyle(.grouped)
            .navigationTitle("Mój profil")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: Settings(user: user)) {
                        Label("Ustawienia", systemImage: "gearshape")
                            .foregroundColor(Appearance.textColor)
                    }
                }
            }
        }
    }
}

struct MyProfile_Previews: PreviewProvider {
    static var previews: some View {
        MyProfile(user: UserProfile_Previews.users[0])
    }
}
