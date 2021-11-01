//
//  UserProfile.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.colorScheme) var colorScheme
    
    let padding: CGFloat = 20
    
    @StateObject var user: User // @StateObject might be temporary.
    
    var body: some View {
        ScrollView {
            VStack(spacing: padding) {
                ZStack(alignment: .bottomTrailing) {
                    Avatar(image: user.avatarImage, size: 160)
                    
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                        Button {
                            user.isSaved.toggle()
                        } label: {
                            Image(systemName: user.isSaved ? "star.fill" : "star")
                                .frame(width: 50, height: 50, alignment: .center)
                                .font(.system(size: 25))
                                .foregroundColor(Appearance.buttonColor)
                        }
                    }
                }
                
                VStack {
                    Text("\(user.name) \(user.surname)")
                        .font(.title)
                    Text(String.localizedStringWithFormat("%.1f km, w pobliżu \(user.nearestLocationName)", user.distance))
                        .font(.subheadline)
                }
                
                // TODO: User's preferences.
                
                Text(user.description)
                
                Button("Wyślij wiadomość") {
                    // TODO: Navigation to a new conversation.
                }
                .buttonStyle(.borderedProminent)
                .font(.headline)
                .tint(Appearance.buttonColor)
            }
        }
        .navigationTitle("Profil")
        .navigationBarTitleDisplayMode(.inline)
        .padding(.horizontal, padding)
        .foregroundColor(Appearance.textColor)
    }
}

struct UserProfile_Previews: PreviewProvider {
    static let users = [
        User(avatarImage: Image("avatar"), name: "John", surname: "Appleseed", distance: 1.4, nearestLocationName: "ul. Marszałkowska", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut posuere tempor neque vitae fermentum. Cras in gravida massa, quis cursus massa. Integer pulvinar vel nisi sed pellentesque. Mauris egestas urna sed ipsum sodales, quis pharetra quam maximus. Nullam et leo id magna efficitur lacinia sed eget turpis. Fusce malesuada maximus maximus. Donec nec porttitor leo, a cursus magna.", isSaved: true),
        User(avatarImage: nil, name: "Anna", surname: "Nowak", distance: 2, nearestLocationName: "ul. Foksal", description: "Etiam in euismod dui. Sed finibus aliquet ipsum gravida congue. Vestibulum vestibulum felis sodales orci ullamcorper tempus. Ut in tincidunt justo. Sed ac commodo dui. Morbi volutpat tincidunt commodo. Nulla tellus dui, iaculis vel nisi ornare, imperdiet consequat justo. Duis maximus, ligula ac viverra auctor, turpis velit hendrerit lorem, dapibus sagittis sapien eros vitae velit.", isSaved: false)
    ]
    
    static var previews: some View {
        UserProfile(user: users[0])
    }
}
