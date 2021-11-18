//
//  ViewModel.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 18.11.21.
//

import CoreLocation
import Foundation
import SwiftUI

class ViewModel: ObservableObject {
    var currentUserID: Int?
    @Published var users: [User]
    @Published var conversations: [Conversation]
    
    init(currentUserID: Int?, users: [User], conversations: [Conversation]) {
        self.currentUserID = currentUserID
        self.users = users
        self.conversations = conversations
    }
    
#if DEBUG
    static let sampleUsers = [
        User(
            id: 1,
            avatarImage: Image("avatar1"),
            name: "John",
            surname: "Appleseed",
            email: "john.appleseed@apple.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.22322350545386, longitude: 21.01232058780615), // Arigator Ramen Shop, ul. Piękna 54
            targetDistance: 3,
            preferences: [.animals: .positive, .smoking: .negative],
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer viverra leo sed lacus aliquet, ut hendrerit dolor porttitor. Nullam vel ligula justo. Donec sit amet eleifend magna. Suspendisse potenti. Mauris eu rutrum sapien. Integer consectetur eu sapien sit amet venenatis. Etiam rhoncus lacus sit amet dui aliquet, vitae lacinia sapien semper.",
            savedUsersIDs: [2, 3],
            isSearchable: true
        ),
        User(
            id: 2,
            avatarImage: Image("avatar2"),
            name: "Anna",
            surname: "Brown",
            email: "anna.brown@gmail.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.23078106134393, longitude: 20.99624683259071), // ul. Sienna 68
            targetDistance: 7.2,
            preferences: [.animals: .negative, .smoking: .neutral],
            description: "Etiam vitae tempor augue. Integer nibh magna, vehicula sed elementum quis, imperdiet eget leo. Cras sed suscipit tellus. In laoreet mattis nunc sed auctor. Integer facilisis magna massa.",
            savedUsersIDs: [1],
            isSearchable: true
        ),
        User(
            id: 3,
            avatarImage: Image("avatar3"),
            name: "Mark",
            surname: "Williams",
            email: "mark.williams@yahoo.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.180284667251996, longitude: 21.060619730182783), // ul. Truskawiecka
            targetDistance: 10,
            preferences: [.animals: .neutral, .smoking: .positive],
            description: "Nunc sed velit rutrum, maximus magna at, hendrerit nisl. Suspendisse potenti.",
            savedUsersIDs: [],
            isSearchable: true
        ),
        User(
            id: 4,
            avatarImage: Image("avatar4"),
            name: "Amy",
            surname: "Smith",
            email: "amy.smith@outlook.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.204754538085254, longitude: 21.02354461310359), // Cafe Mozaika, ul. Puławska 53
            targetDistance: 6,
            preferences: [.animals: .neutral, .smoking: .neutral],
            description: "Maecenas nec porta urna. Sed neque orci, convallis eget tempus et, vulputate et augue. Donec porta dui quis ultrices cursus. Sed pharetra nunc commodo velit blandit sollicitudin. Praesent posuere augue nec pellentesque scelerisque. Curabitur tristique pretium enim, nec lobortis est semper vel. Donec elementum ex non metus maximus fermentum ut ut diam. Fusce eu mollis libero.",
            savedUsersIDs: [2],
            isSearchable: true
        ),
        User(
            id: 5,
            avatarImage: nil,
            name: "Carol",
            surname: "Johnson",
            email: "carol.johnson@example.co.uk",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.216761821455016, longitude: 21.018691400178643), // ul. Oleandrów
            targetDistance: 4.1,
            preferences: [.animals: .negative, .smoking: .negative],
            description: "Etiam eleifend quis quam et gravida. Curabitur eu vestibulum elit.",
            savedUsersIDs: [2, 4],
            isSearchable: true
        )
    ]
    
    static let sampleConversations = [
        Conversation(
            id: 1,
            participantsIDs: [1, 2, 3],
            messages: [
                Message(
                    id: 1,
                    authorID: 1,
                    content: "Lorem ipsum dolor sit amet",
                    timeSent: Date(timeIntervalSince1970: 1636633543)
                ),
                Message(
                    id: 2,
                    authorID: 2,
                    content: "Donec et est magna 😜",
                    timeSent: Date(timeIntervalSince1970: 1636634665)
                ),
                Message(
                    id: 3,
                    authorID: 1,
                    content: "Nam sollicitudin orci urna",
                    timeSent: Date(timeIntervalSince1970: 1636634987)
                ),
                Message(
                    id: 4,
                    authorID: 3,
                    content: "Vestibulum ante ipsum primis in faucibus orci luctus",
                    timeSent: Date(timeIntervalSince1970: 1636635106)
                ),
                Message(
                    id: 5,
                    authorID: 2,
                    content: "Nunc ac ex lobortis, tempor lorem eu, consequat tellus 🐶",
                    timeSent: Date(timeIntervalSince1970: 1636641097)
                ),
                Message(
                    id: 6,
                    authorID: 1,
                    content: "Praesent",
                    timeSent: Date(timeIntervalSince1970: 1636656847)
                )
            ]
        ),
        Conversation(
            id: 2,
            participantsIDs: [1, 5],
            messages: [
                Message(
                    id: 7,
                    authorID: 5,
                    content: "Curabitur rhoncus at ex nec volutpat. Aenean eget purus et justo varius elementum.",
                    timeSent: Date(timeIntervalSince1970: 1636981561)
                ),
                Message(
                    id: 8,
                    authorID: 1,
                    content: "Ut consectetur tellus nibh, vel luctus massa fermentum quis. Nam et iaculis mi. Nunc sem nisl, tempus sed interdum consequat, pulvinar at nulla. 🍪",
                    timeSent: Date(timeIntervalSince1970: 1637005586)
                ),
                Message(
                    id: 9,
                    authorID: 5,
                    content: "Cras feugiat urna et",
                    timeSent: Date(timeIntervalSince1970: 1637005622)
                ),
                Message(
                    id: 10,
                    authorID: 1,
                    content: "Suspendisse! 🎉",
                    timeSent: Date(timeIntervalSince1970: 1637068971)
                )
            ]
        )
    ]
    
    static let sampleViewModel = ViewModel(currentUserID: 1, users: sampleUsers, conversations: sampleConversations)
#endif
}
