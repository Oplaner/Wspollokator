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
        case invalidEmailFormat
        case emailAlreadyTaken
        case unmatchingPasswords
        case invalidPasswordFormat
    }
    
    enum LoginError: Error {
        case invalidCredentials
    }
    
    enum PasswordChangeError: Error {
        case invalidOldPassword
        case unmatchingNewPasswords
        case oldAndNewPasswordsEqual
        case invalidNewPasswordFormat
    }
    
    static let refreshCurrentUserDataTimeInterval: Double = 60
    static let refreshConversationsTimeInterval: Double = 10
    static let refreshMessagesTimeInterval: Double = 5
    static let defaultTargetDistance: Double = 5
    private static let nearbyUsersDownloadRange: Double = 20 // To include users whose area of interest (of maximum 10 km radius) is within 10 km of the current user's point of interest.
    
    /// Returns a preferences dictionary with neutral attitude to each filter option.
    nonisolated static var defaultPreferences: [FilterOption: FilterAttitude] {
        var preferences = [FilterOption: FilterAttitude]()
        
        for option in FilterOption.allCases {
            preferences[option] = .neutral
        }
        
        return preferences
    }
    
    let userDataTimer = Timer.publish(every: refreshCurrentUserDataTimeInterval, tolerance: 1.0, on: .main, in: .common).autoconnect()
    
    @Published var isUserAuthenticated: Bool
    @Published var currentUser: User?
    @Published var users: [User]
    @Published var conversations: [Conversation]
    @Published var searchTargetDistance = defaultTargetDistance
    @Published var searchPreferences = defaultPreferences
    @Published var isUpdatingSavedList: Bool
    @Published var didReportErrorUpdatingSavedList: Bool
    @Published var isShowingConversationView: Bool
    
    init(currentUser: User? = nil, users: [User] = [], conversations: [Conversation] = []) {
        isUserAuthenticated = currentUser != nil
        self.currentUser = currentUser
        self.users = users
        self.conversations = conversations
        isUpdatingSavedList = false
        didReportErrorUpdatingSavedList = false
        isShowingConversationView = false
    }
    
    static func resizeImage(_ image: UIImage) -> UIImage {
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
    
    func createUserAccount(name: String, surname: String, email: String, password1: String, password2: String) async throws -> Bool {
        guard password1 == password2 else { throw SignUpError.unmatchingPasswords }
        
        if let userID = try await Networking.createUserAccount(name: name, surname: surname, email: email, password: password1) {
            currentUser = User(id: userID, name: name, surname: surname, email: email)
            return await downloadCurrentUserData()
        } else {
            return false
        }
    }
    
    func authenticateUser(withEmail email: String, password: String) async throws -> Bool {
        if let user = await Networking.fetchCurrentUser(withEmail: email, password: password) {
            currentUser = user
            
            if KeychainService.fetchLoginInformation() == nil && !KeychainService.saveLoginInformation(email: email, password: password) {
                KeychainService.deleteLoginInformation()
                _ = KeychainService.saveLoginInformation(email: email, password: password)
            }
            
            let searchSettings = UserDefaultsService.readSearchSettings()
            searchTargetDistance = searchSettings.targetDistance
            searchPreferences = searchSettings.preferences
            
            return await downloadCurrentUserData()
        } else {
            KeychainService.deleteLoginInformation()
            throw LoginError.invalidCredentials
        }
    }
    
    func changeCurrentUser(avatarImage image: UIImage?) async -> Bool {
        await Networking.update(avatarImage: image)
    }
    
    func changeCurrentUser(name: String) async -> Bool {
        await Networking.update(name: name)
    }
    
    func changeCurrentUser(surname: String) async -> Bool {
        await Networking.update(surname: surname)
    }
    
    func changeCurrentUser(description: String) async -> Bool {
        await Networking.update(description: description)
    }
    
    func changeCurrentUser(pointOfInterest: CLLocationCoordinate2D) async -> Bool {
        guard await Networking.update(pointOfInterest: pointOfInterest, targetDistance: currentUser!.targetDistance) else { return false }
        
        // Fetch new nearby users.
        if let newUsers = await Networking.fetchNearbyUsers(inRange: ViewModel.nearbyUsersDownloadRange, usingLocalUsersExtension: users) {
            for user in newUsers {
                if !users.contains(user) {
                    users.append(user)
                }
            }
            
            return true
        } else {
            return false
        }
    }
    
    func changeCurrentUser(searchableState: Bool) async -> Bool {
        await Networking.update(searchableState: searchableState)
    }
    
    func changeCurrentUser(targetDistance: Double) async -> Bool {
        await Networking.update(pointOfInterest: currentUser!.pointOfInterest!, targetDistance: targetDistance)
    }
    
    func changeCurrentUser(preferences: [FilterOption: FilterAttitude]) async -> Bool {
        await Networking.update(preferences: preferences)
    }
    
    func changeCurrentUserPassword(oldPassword old: String, newPassword new1: String, confirmation new2: String) async throws -> Bool {
        guard await Networking.checkPassword(old) else { throw PasswordChangeError.invalidOldPassword }
        guard new1 == new2 else { throw PasswordChangeError.unmatchingNewPasswords }
        guard new1 != old else { throw PasswordChangeError.oldAndNewPasswordsEqual }
        
        if try await Networking.setNewPassword(new1) {
            KeychainService.updateLoginInformation(email: currentUser!.email, password: new1)
            return true
        }
        
        return false
    }
    
    func changeCurrentUserSavedList(byAdding user: User) async {
        guard !currentUser!.savedUsers.contains(user) else { return }
        
        currentUser!.savedUsers.append(user)
        isUpdatingSavedList = true
        
        if await !Networking.updateSavedList(byAdding: user) {
            currentUser!.savedUsers.removeAll(where: { $0 == user })
            didReportErrorUpdatingSavedList = true
        }
        
        isUpdatingSavedList = false
    }
    
    func changeCurrentUserSavedList(byRemoving user: User) async {
        guard currentUser!.savedUsers.contains(user) else { return }
        
        currentUser!.savedUsers.removeAll(where: { $0 == user })
        isUpdatingSavedList = true
        
        if await !Networking.updateSavedList(byRemoving: user) {
            currentUser!.savedUsers.append(user)
            didReportErrorUpdatingSavedList = true
        }
        
        isUpdatingSavedList = false
    }
    
    func fetchRatings(of user: User) async -> [Rating]? {
        guard let ratings = await Networking.fetchRatings(of: user, usingLocalUsersExtension: users) else { return nil }
        
        for rating in ratings {
            let author = rating.author
            
            if !users.contains(author) {
                users.append(author)
            }
        }
        
        return ratings
    }
    
    func sendMessage(_ text: String, in conversation: Conversation) async -> (createdConversation: Conversation?, sentMessage: Message?, success: Bool) {
        if conversation.id == "0" /* A new conversation. */ {
            guard let conversationID = await Networking.createConversation(withParticipants: conversation.participants.filter({ $0 != currentUser! })) else { return (nil, nil, false) }
            
            let createdConversation = Conversation(id: conversationID, participants: conversation.participants, messages: [])
            
            if await Networking.sendMessage(text, in: createdConversation) {
                let sentMessage = Message(id: UUID().uuidString, author: currentUser!, content: text, timeSent: Date())
                createdConversation.messages.append(sentMessage)
                return (createdConversation, sentMessage, true)
            }
        } else if await Networking.sendMessage(text, in: conversation) /* An existing conversation. */ {
            let sentMessage = Message(id: UUID().uuidString, author: currentUser!, content: text, timeSent: Date())
            return (nil, sentMessage, true)
        }
        
        return (nil, nil, false)
    }
    
    func addRating(of user: User, withScore score: Int, comment: String) async -> (addedRating: Rating?, success: Bool) {
        guard let ratingInfo = await Networking.addRating(of: user, withScore: score, comment: comment) else { return (nil, false) }
        let rating = Rating(id: ratingInfo.ratingID, author: currentUser!, score: score, comment: comment, timeAdded: ratingInfo.timeAdded)
        return (rating, true)
    }
    
    @discardableResult func refresh() async -> Bool {
        if await refreshCurrentUser() {
            return await downloadCurrentUserData()
        } else {
            return false
        }
    }
    
    @discardableResult func refreshConversations() async -> Bool {
        if let fetchedConversations = await Networking.fetchConversations(usingLocalUsersExtension: users) {
            objectWillChange.send()
            conversations = fetchedConversations
            return true
        } else {
            return false
        }
    }
    
    @discardableResult func refreshMessages(in conversation: Conversation) async -> Bool {
        if let fetchedMessages = await Networking.fetchMessages(for: conversation) {
            objectWillChange.send()
            conversation.messages.append(contentsOf: fetchedMessages)
            return true
        } else {
            return false
        }
    }
    
    func logout() {
        userDataTimer.upstream.connect().cancel()
        users = []
        conversations = []
        searchTargetDistance = ViewModel.defaultTargetDistance
        searchPreferences = ViewModel.defaultPreferences
        UserDefaultsService.clearSearchSettings()
        KeychainService.deleteLoginInformation()
        isUserAuthenticated = false
        
        // Unsetting the current user must be delayed, otherwise the app will crash, because many views explicitly unwrap this optional and their bodies recompute prior to displaying the login view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.currentUser = nil
        }
    }
    
    private func downloadCurrentUserData() async -> Bool {
        var fetchedUsers: Set = [currentUser!]
        
        // Fetch all searchable users who are in range of nearbyUsersDownloadRange km from the current user's point of interest, if it is set.
        if currentUser!.pointOfInterest != nil {
            guard let nearbyUsers = await Networking.fetchNearbyUsers(inRange: ViewModel.nearbyUsersDownloadRange, usingLocalUsersExtension: Array(fetchedUsers)) else { return false }
            
            for user in nearbyUsers {
                fetchedUsers.insert(user)
            }
        }
        
        // Fetch users from the current user's saved list.
        guard let savedUsers = await Networking.fetchSavedUsers(usingLocalUsersExtension: Array(fetchedUsers)) else { return false }
        
        for user in savedUsers {
            fetchedUsers.insert(user)
        }
        
        // Fetch ratings of the current user and their authors.
        guard let ratings = await Networking.fetchRatings(of: currentUser!, usingLocalUsersExtension: Array(fetchedUsers)) else { return false }
        
        for rating in ratings {
            fetchedUsers.insert(rating.author)
        }
        
        // Fetch conversations, messages and their authors.
        guard let fetchedConversations = await Networking.fetchConversations(usingLocalUsersExtension: Array(fetchedUsers)) else { return false }
        
        for conversation in fetchedConversations {
            for message in conversation.messages {
                fetchedUsers.insert(message.author)
            }
        }
        
        if isUserAuthenticated {
            objectWillChange.send()
        }
        
        currentUser!.savedUsers = savedUsers
        currentUser!.ratings = ratings
        users = Array(fetchedUsers)
        conversations = fetchedConversations
        
        return true
    }
    
    private func refreshCurrentUser() async -> Bool {
        if let updatedUser = await Networking.fetchUser(withID: currentUser!.id, settingEmail: currentUser!.email) {
            updatedUser.savedUsers = currentUser!.savedUsers
            updatedUser.ratings = currentUser!.ratings
            objectWillChange.send()
            currentUser = updatedUser
            return true
        } else {
            return false
        }
    }
    
#if DEBUG
    static var sampleUsers: [User] {
        let john = User(
            id: "1",
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
            id: "2",
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
            id: "3",
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
            id: "4",
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
            id: "5",
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
        
        john.ratings = [
            Rating(
                id: "2",
                author: anna,
                score: 4,
                comment: "Maecenas vel nulla et enim.",
                timeAdded: Date(timeIntervalSince1970: 1639848593)
            ),
            Rating(
                id: "3",
                author: mark,
                score: 5,
                comment: "Sed a felis porttitor, bibendum velit sed! 💚",
                timeAdded: Date(timeIntervalSince1970: 1639848793)
            ),
            Rating(
                id: "5",
                author: carol,
                score: 2,
                comment: "Nullam pulvinar pellentesque erat vitae faucibus. Maecenas a risus non mi ultricies eleifend. 🤨",
                timeAdded: Date(timeIntervalSince1970: 1639849160)
            )
        ]
        anna.ratings = [
            Rating(
                id: "4",
                author: amy,
                score: 3,
                comment: "Rutrum odio.",
                timeAdded: Date(timeIntervalSince1970: 1639848838)
            )
        ]
        mark.ratings = [
            Rating(
                id: "1",
                author: john,
                score: 3,
                comment: "Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Fusce luctus facilisis felis vel volutpat.",
                timeAdded: Date(timeIntervalSince1970: 1639848215)
            )
        ]
        
        return [john, anna, mark, amy, carol]
    }
    
    static var sampleConversations: [Conversation] {
        let john = sampleUsers[0]
        let anna = sampleUsers[1]
        let mark = sampleUsers[2]
        let carol = sampleUsers[4]
        
        return [
            Conversation(
                id: "1",
                participants: [john, anna, mark],
                messages: [
                    Message(
                        id: "1",
                        author: john,
                        content: "Lorem ipsum dolor sit amet",
                        timeSent: Date(timeIntervalSince1970: 1636633543)
                    ),
                    Message(
                        id: "2",
                        author: anna,
                        content: "Donec et est magna 😜",
                        timeSent: Date(timeIntervalSince1970: 1636634665)
                    ),
                    Message(
                        id: "3",
                        author: john,
                        content: "Nam sollicitudin orci urna",
                        timeSent: Date(timeIntervalSince1970: 1636634987)
                    ),
                    Message(
                        id: "4",
                        author: mark,
                        content: "Vestibulum ante ipsum primis in faucibus orci luctus",
                        timeSent: Date(timeIntervalSince1970: 1636635106)
                    ),
                    Message(
                        id: "5",
                        author: anna,
                        content: "Nunc ac ex lobortis, tempor lorem eu, consequat tellus 🐶",
                        timeSent: Date(timeIntervalSince1970: 1636641097)
                    ),
                    Message(
                        id: "6",
                        author: john,
                        content: "Praesent",
                        timeSent: Date(timeIntervalSince1970: 1636656847)
                    )
                ]
            ),
            Conversation(
                id: "2",
                participants: [john, carol],
                messages: [
                    Message(
                        id: "7",
                        author: carol,
                        content: "Curabitur rhoncus at ex nec volutpat. Aenean eget purus et justo varius elementum.",
                        timeSent: Date(timeIntervalSince1970: 1636981561)
                    ),
                    Message(
                        id: "8",
                        author: john,
                        content: "Ut consectetur tellus nibh, vel luctus massa fermentum quis. Nam et iaculis mi. Nunc sem nisl, tempus sed interdum consequat, pulvinar at nulla. 🍪",
                        timeSent: Date(timeIntervalSince1970: 1637005586)
                    ),
                    Message(
                        id: "9",
                        author: carol,
                        content: "Cras feugiat urna et",
                        timeSent: Date(timeIntervalSince1970: 1637005622)
                    ),
                    Message(
                        id: "10",
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
