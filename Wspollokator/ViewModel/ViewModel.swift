//
//  ViewModel.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 18.11.21.
//

import CoreLocation
import SwiftUI

@MainActor class ViewModel: ObservableObject {
    enum SignUpError: Error {
        case emailAlreadyTaken
        case unmatchingPasswords
    }
    
    enum LoginError: Error {
        case invalidCredentials
    }
    
    enum EmailChangeError: Error {
        case emailAlreadyTaken
    }
    
    enum PasswordChangeError: Error {
        case invalidOldPassword
        case unmatchingNewPasswords
        case oldAndNewPasswordsEqual
    }
    
    static let defaultTargetDistance: Double = 5
    
    /// Returns a preferences dictionary with neutral attitude to each filter option.
    nonisolated static var defaultPreferences: [FilterOption: FilterAttitude] {
        var preferences = [FilterOption: FilterAttitude]()
        
        for option in FilterOption.allCases {
            preferences[option] = .neutral
        }
        
        return preferences
    }
    
    @Published var isUserAuthenticated: Bool
    @Published var currentUser: User?
    @Published var users: [User]
    @Published var conversations: [Conversation]
    @Published var searchTargetDistance = defaultTargetDistance
    @Published var searchPreferences = defaultPreferences
    
    init(currentUser: User?, users: [User], conversations: [Conversation]) {
        isUserAuthenticated = currentUser != nil
        self.currentUser = currentUser
        self.users = users
        self.conversations = conversations
    }
    
    func authenticateUser(withEmail email: String, password: String) async throws -> Bool {
        let encryptedPassword = encryptPassword(password)
        
        if let user = await Networking.fetchUser(withEmail: email, encryptedPassword: encryptedPassword) {
            currentUser = user
            return await downloadCurrentUserData()
        } else {
            throw LoginError.invalidCredentials
        }
    }
    
    func changeCurrentUser(avatarImage image: UIImage?) async -> Bool {
        await Networking.update(avatarImage: image, forUser: currentUser!)
    }
    
    func changeCurrentUser(name: String) async -> Bool {
        await Networking.update(name: name, forUser: currentUser!)
    }
    
    func changeCurrentUser(surname: String) async -> Bool {
        await Networking.update(surname: surname, forUser: currentUser!)
    }
    
    func changeCurrentUser(email: String) async throws -> Bool {
        if await !Networking.checkEmailAvailability(email) {
            throw EmailChangeError.emailAlreadyTaken
        } else {
            return await Networking.update(email: email, forUser: currentUser!)
        }
    }
    
    func changeCurrentUser(description: String) async -> Bool {
        await Networking.update(description: description, forUser: currentUser!)
    }
    
    func changeCurrentUser(pointOfInterest: CLLocationCoordinate2D?) async -> Bool {
        await Networking.update(pointOfInterest: pointOfInterest, forUser: currentUser!)
    }
    
    func changeCurrentUserPassword(oldPassword old: String, newPassword new1: String, confirmation new2: String) async throws -> Bool {
        var encryptedPassword = encryptPassword(old)
        
        guard await Networking.checkEncryptedPassword(encryptedPassword, forUser: currentUser!) else { throw PasswordChangeError.invalidOldPassword }
        guard new1 == new2 else { throw PasswordChangeError.unmatchingNewPasswords }
        guard new1 != old else { throw PasswordChangeError.oldAndNewPasswordsEqual }
        
        encryptedPassword = encryptPassword(new1)
        return await Networking.setNewPassword(encryptedPassword, forUser: currentUser!)
    }
    
    func createUserAccount(name: String, surname: String, email: String, password1: String, password2: String) async throws -> Bool {
        guard await Networking.checkEmailAvailability(email) else { throw SignUpError.emailAlreadyTaken }
        guard password1 == password2 else { throw SignUpError.unmatchingPasswords }
        
        let encryptedPassword = encryptPassword(password1)
        
        if let userID = await Networking.createUserAccount(name: name, surname: surname, email: email, encryptedPassword: encryptedPassword) {
            currentUser = User(id: userID, name: name, surname: surname, email: email)
            return await downloadCurrentUserData()
        } else {
            return false
        }
    }
    
    func logout() {
        // TODO: Stop background communication and remove scheduled refresh tasks.
        // TODO: Remove current user information from a local storage.
        
        searchTargetDistance = ViewModel.defaultTargetDistance
        searchPreferences = ViewModel.defaultPreferences
        isUserAuthenticated = false
        
        // Unsetting the current user must be delayed, otherwise the app will crash, because many views explicitly unwrap this optional and their bodies recompute prior to displaying the login view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = nil
        }
    }
    
    func resizeImage(_ image: UIImage) -> UIImage {
        let nativeImageSize = CGSize(width: image.scale * image.size.width, height: image.scale * image.size.height)
        let screenScale = UIScreen.main.scale
        let nativeTargetSize = screenScale * UserProfile.avatarSize // The largest size, in pixels, at which an avatar is displayed within the app.
        
        if nativeImageSize.width <= nativeTargetSize || nativeImageSize.height <= nativeTargetSize {
            return image
        } else {
            let scaleFactor = nativeTargetSize / min(nativeImageSize.width, nativeImageSize.height) / screenScale
            let newImageSize = CGSize(width: scaleFactor * image.size.width, height: scaleFactor * image.size.height)
            let renderer = UIGraphicsImageRenderer(size: newImageSize)
            let resizedImage = renderer.image { _ in
                image.draw(in: CGRect(origin: .zero, size: newImageSize))
            }
            
            return resizedImage
        }
    }
    
    func sendMessage(_ text: String, in conversation: Conversation) async -> (createdConversation: Conversation?, sentMessage: Message?, success: Bool) {
        let (messageID, timeSent) = await Networking.sendMessage(text, writtenBy: currentUser!)
        guard messageID != nil else { return (nil, nil, false) }
        let sentMessage = Message(id: messageID!, author: currentUser!, content: text, timeSent: timeSent!)
        
        if conversation.id == 0 { // A new conversation.
            guard let conversationID = await Networking.createConversation(withParticipants: conversation.participants) else {
                await Networking.deleteMessage(sentMessage)
                return (nil, nil, false)
            }
            let createdConversation = Conversation(id: conversationID, participants: conversation.participants, messages: [sentMessage])
            
            if await Networking.addMessage(sentMessage, to: createdConversation) {
                return (createdConversation, sentMessage, true)
            } else {
                await Networking.deleteMessage(sentMessage)
                await Networking.deleteConversation(createdConversation)
                return (nil, nil, false)
            }
        } else { // An existing conversation.
            if await Networking.addMessage(sentMessage, to: conversation) {
                return (nil, sentMessage, true)
            } else {
                await Networking.deleteMessage(sentMessage)
                return (nil, nil, false)
            }
        }
    }
    
    private func downloadCurrentUserData() async -> Bool {
        // TODO: Download all the required data for the current user, for example other users' data, conversations.
        true
    }
    
    private func encryptPassword(_ password: String) -> String {
        // TODO: Add an actual password encryption matching the one used in the database.
        password
    }
    
#if DEBUG
    // TODO: Remove "nonisolated" when map views are finished.
    nonisolated static var sampleUsers: [User] {
        let john = User(
            id: 1,
            avatarImage: Image("avatar1"),
            name: "John",
            surname: "Appleseed",
            email: "john.appleseed@apple.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.22322350545386, longitude: 21.01232058780615), // ul. Piękna 54
            targetDistance: 3,
            preferences: [.animals: .positive, .smoking: .negative],
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer viverra leo sed lacus aliquet, ut hendrerit dolor porttitor. Nullam vel ligula justo. Donec sit amet eleifend magna. Suspendisse potenti. Mauris eu rutrum sapien. Integer consectetur eu sapien sit amet venenatis. Etiam rhoncus lacus sit amet dui aliquet, vitae lacinia sapien semper.",
            isSearchable: true
        )
        let anna = User(
            id: 2,
            avatarImage: Image("avatar2"),
            name: "Anna",
            surname: "Brown",
            email: "anna.brown@apple.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.23078106134393, longitude: 20.99624683259071), // ul. Sienna 68
            targetDistance: 7.2,
            preferences: [.animals: .negative, .smoking: .neutral],
            description: "Etiam vitae tempor augue. Integer nibh magna, vehicula sed elementum quis, imperdiet eget leo. Cras sed suscipit tellus. In laoreet mattis nunc sed auctor. Integer facilisis magna massa.",
            isSearchable: true
        )
        let mark = User(
            id: 3,
            avatarImage: Image("avatar3"),
            name: "Mark",
            surname: "Williams",
            email: "mark.williams@apple.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.180284667251996, longitude: 21.060619730182783), // ul. Truskawiecka
            targetDistance: 10,
            preferences: [.animals: .neutral, .smoking: .positive],
            description: "Nunc sed velit rutrum, maximus magna at, hendrerit nisl. Suspendisse potenti.",
            isSearchable: true
        )
        let amy = User(
            id: 4,
            avatarImage: Image("avatar4"),
            name: "Amy",
            surname: "Smith",
            email: "amy.smith@apple.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.204754538085254, longitude: 21.02354461310359), // ul. Puławska 53
            targetDistance: 6,
            preferences: [.animals: .neutral, .smoking: .neutral],
            description: "Maecenas nec porta urna. Sed neque orci, convallis eget tempus et, vulputate et augue. Donec porta dui quis ultrices cursus. Sed pharetra nunc commodo velit blandit sollicitudin. Praesent posuere augue nec pellentesque scelerisque. Curabitur tristique pretium enim, nec lobortis est semper vel. Donec elementum ex non metus maximus fermentum ut ut diam. Fusce eu mollis libero.",
            isSearchable: true
        )
        let carol = User(
            id: 5,
            avatarImage: nil,
            name: "Carol",
            surname: "Johnson",
            email: "carol.johnson@apple.com",
            pointOfInterest: CLLocationCoordinate2D(latitude: 52.216761821455016, longitude: 21.018691400178643), // ul. Oleandrów
            targetDistance: 4.1,
            preferences: [.animals: .negative, .smoking: .negative],
            description: "Etiam eleifend quis quam et gravida. Curabitur eu vestibulum elit.",
            isSearchable: true
        )
        
        john.savedUsers = [anna, mark]
        anna.savedUsers = [john]
        amy.savedUsers = [anna]
        carol.savedUsers = [anna, amy]
        
        return [john, anna, mark, amy, carol]
    }
    
    static var sampleConversations: [Conversation] {
        let john = sampleUsers[0]
        let anna = sampleUsers[1]
        let mark = sampleUsers[2]
        let carol = sampleUsers[4]
        
        return [
            Conversation(
                id: 1,
                participants: [john, anna, mark],
                messages: [
                    Message(
                        id: 1,
                        author: john,
                        content: "Lorem ipsum dolor sit amet",
                        timeSent: Date(timeIntervalSince1970: 1636633543)
                    ),
                    Message(
                        id: 2,
                        author: anna,
                        content: "Donec et est magna 😜",
                        timeSent: Date(timeIntervalSince1970: 1636634665)
                    ),
                    Message(
                        id: 3,
                        author: john,
                        content: "Nam sollicitudin orci urna",
                        timeSent: Date(timeIntervalSince1970: 1636634987)
                    ),
                    Message(
                        id: 4,
                        author: mark,
                        content: "Vestibulum ante ipsum primis in faucibus orci luctus",
                        timeSent: Date(timeIntervalSince1970: 1636635106)
                    ),
                    Message(
                        id: 5,
                        author: anna,
                        content: "Nunc ac ex lobortis, tempor lorem eu, consequat tellus 🐶",
                        timeSent: Date(timeIntervalSince1970: 1636641097)
                    ),
                    Message(
                        id: 6,
                        author: john,
                        content: "Praesent",
                        timeSent: Date(timeIntervalSince1970: 1636656847)
                    )
                ]
            ),
            Conversation(
                id: 2,
                participants: [john, carol],
                messages: [
                    Message(
                        id: 7,
                        author: carol,
                        content: "Curabitur rhoncus at ex nec volutpat. Aenean eget purus et justo varius elementum.",
                        timeSent: Date(timeIntervalSince1970: 1636981561)
                    ),
                    Message(
                        id: 8,
                        author: john,
                        content: "Ut consectetur tellus nibh, vel luctus massa fermentum quis. Nam et iaculis mi. Nunc sem nisl, tempus sed interdum consequat, pulvinar at nulla. 🍪",
                        timeSent: Date(timeIntervalSince1970: 1637005586)
                    ),
                    Message(
                        id: 9,
                        author: carol,
                        content: "Cras feugiat urna et",
                        timeSent: Date(timeIntervalSince1970: 1637005622)
                    ),
                    Message(
                        id: 10,
                        author: john,
                        content: "Suspendisse! 🎉",
                        timeSent: Date(timeIntervalSince1970: 1637068971)
                    )
                ]
            )
        ]
    }
    
    static let sample = ViewModel(currentUser: sampleUsers[0], users: sampleUsers, conversations: sampleConversations)
#endif
}
