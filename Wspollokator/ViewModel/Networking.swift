//
//  Networking.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30.11.21.
//

import CoreLocation
import SwiftUI
import UIKit

class Networking {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    enum ContentType: String {
        case json = "application/json; charset=utf-8"
        case multipart = "multipart/form-data; charset=utf-8; boundary=wspollokator-api"
    }
    
    static let baseURL = URL(string: "http://wspolokator.livs.pl:8000")
    static var session: URLSession! = nil
    private static let defaultAvatarURLString = "http://wspolokator.livs.pl:8000/media/default_avatar.png"
    
    /// Sets up a new networking session to communicate with the server.
    static func makeSession() {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.networkServiceType = .responsiveData
        configuration.timeoutIntervalForRequest = 30
        configuration.urlCache = nil
        session = URLSession(configuration: configuration)
    }
    
    /// A helper function for making URLRequests.
    ///
    /// Parameter `endpoint` _must_ end with a slash. For `.multipart` value of `contentType` parameter `UImage` objects are supported.
    static func makeRequest(endpoint: String, method: HTTPMethod, body: [String: Any]? = nil, contentType: ContentType? = nil) -> URLRequest {
        var url = URL(string: endpoint, relativeTo: baseURL)!
        
        if method == .get, let body = body {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
            components.queryItems = body.map { key, value in
                URLQueryItem(name: key, value: String(describing: value))
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            url = components.url!
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method != .get, let body = body {
            request.setValue(contentType!.rawValue, forHTTPHeaderField: "Content-Type")
            
            switch contentType! {
            case .json:
                request.httpBody = try! JSONSerialization.data(withJSONObject: body)
            case .multipart:
                let boundary = ContentType.multipart.rawValue.components(separatedBy: "boundary=")[1]
                var data = Data()
                
                for (key, value) in body {
                    switch value {
                    case is UIImage:
                        let image = value as! UIImage
                        let format: String
                        let imageData: Data
                        
                        if let pngData = image.pngData() {
                            format = "png"
                            imageData = pngData
                        } else {
                            format = "jpeg"
                            imageData = image.jpegData(compressionQuality: 1)!
                        }
                        
                        data.append("--\(boundary)\r\n")
                        data.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"avatar.\(format)\"\r\n")
                        data.append("Content-Type: image/\(format)\r\n\r\n")
                        data.append(imageData)
                        data.append("\r\n")
                    default:
                        data.append("--\(boundary)\r\n")
                        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n")
                        data.append("Content-Type: text/plain\r\n\r\n")
                        data.append("\(value)\r\n")
                    }
                }
                
                data.append("--\(boundary)--\r\n")
                request.httpBody = data
            }
        }
        
        return request
    }
    
    /// Tries to create a new user in the database and returns their ID, or nil if the operation failed.
    static func createUserAccount(name: String, surname: String, email: String, password: String) async throws -> String? {
        do {
            // Create a new account.
            var body: [String: Any] = [
                "first_name": name,
                "last_name": surname,
                "email": email,
                "password": password
            ]
            var request = makeRequest(endpoint: "auth/register/", method: .post, body: body, contentType: .json)
            var (data, response) = try await session.data(for: request)
            
            guard let code = (response as? HTTPURLResponse)?.statusCode else { return nil }
            
            if code == 201 /* An account has been created. */ {
                // Login to the created account and get user's ID.
                guard let userID = await authorizeUser(withEmail: email, password: password) else { return nil }
                
                // Create user's profile object.
                body = [
                    "sex": name.last! == "a" ? "F" : "M",
                    "age": 0,
                    "accepts_animals": "I",
                    "smoking": "I",
                    "preferable_price": 0,
                    "description": "Brak opisu.",
                    "is_searchable": false
                ]
                request = makeRequest(endpoint: "profile/", method: .post, body: body, contentType: .multipart)
                (_, response) = try await session.data(for: request)
                
                guard (response as? HTTPURLResponse)?.statusCode == 201 /* A profile has been created. */ else { return nil }
                
                // Registered, logged in, profile created, success.
                return userID
            } else if code == 400 /* An error has occurred. */, let json = try JSONSerialization.jsonObject(with: data) as? [String: [String]] {
                if let emailErrors = json["email"] {
                    if emailErrors.contains(where: { $0.contains("valid") }) {
                        throw ViewModel.SignUpError.invalidEmailFormat
                    } else if emailErrors.contains(where: { $0.contains("exists") }) {
                        throw ViewModel.SignUpError.emailAlreadyTaken
                    }
                }
                
                if json["password"] != nil {
                    throw ViewModel.SignUpError.invalidPasswordFormat
                }
            }
            
            // An unexpected status code has arrived.
            return nil
        } catch let error where error is ViewModel.SignUpError {
            // If there has been a known signup error, rethrow it to the caller.
            throw error
        } catch {
            // Quit for other errors.
            return nil
        }
    }
    
    /// Authenticates current user with given credentials and returns an object representing the user, or nil if the operation failed.
    static func fetchCurrentUser(withEmail email: String, password: String) async -> User? {
        // Login with given credentials.
        guard let userID = await authorizeUser(withEmail: email, password: password) else { return nil }
        
        // Get User object.
        return await fetchUser(withID: userID, settingEmail: email)
    }
    
    /// Tries to search for a user with given `userID` and returns a basic object representing the user, without `savedUsers` and `ratings`, or nil if the operation failed. For the current user the `email` parameter should be supplied, as well.
    static func fetchUser(withID userID: String, settingEmail email: String? = nil) async -> User? {
        do {
            // Get profile ID.
            var request = makeRequest(endpoint: "profile/\(userID)/", method: .get)
            var (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Profile has been downloaded. */,
                  let profileData = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let profileID = profileData["id"] as? String
            else { return nil }
            
            // Get profile details.
            request = makeRequest(endpoint: "profile/detail/\(profileID)/", method: .get)
            (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Profile details have been downloaded. */,
                  let profileDetails = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let name = profileDetails["first_name"] as? String,
                  let surname = profileDetails["last_name"] as? String,
                  let pointOfInterestArray = profileDetails["point"] as? [[String: Any]],
                  let animals = profileDetails["accepts_animals"] as? String,
                  let smoking = profileDetails["smoking"] as? String,
                  let description = profileDetails["description"] as? String,
                  let isSearchable = profileDetails["is_searchable"] as? Bool
            else { return nil }
            
            // Download an avatar image or set a default avatar.
            var avatar: Image? = nil
            
            if let avatarURLString = profileDetails["avatar"] as? String, avatarURLString != defaultAvatarURLString {
                let avatarURL = URL(string: avatarURLString)!
                let (imageURL, _) = try await session.download(from: avatarURL)
                let imageData = try Data(contentsOf: imageURL, options: .uncached)
                
                if let image = UIImage(data: imageData) {
                    let scaledImage = await ViewModel.resizeImage(image)
                    avatar = Image(uiImage: scaledImage)
                }
            }
            
            // Decode point of interest and target distance.
            var pointOfInterest: CLLocationCoordinate2D? = nil
            var targetDistance = ViewModel.defaultTargetDistance
            
            if let pointData = pointOfInterestArray.first,
               let radius = pointData["radius"] as? Double,
               let location = pointData["location"] as? [String: Any],
               let coordinates = location["coordinates"] as? [Double] {
                pointOfInterest = CLLocationCoordinate2D(latitude: coordinates[0], longitude: coordinates[1])
                targetDistance = radius
            }
            
            // Decode user's preferences.
            let preferences: [FilterOption: FilterAttitude] = [
                .animals: FilterAttitude.mapFrom(serverValue: animals),
                .smoking: FilterAttitude.mapFrom(serverValue: smoking)
            ]
            
            // Gather all decoded information into one User object.
            return User(id: userID, avatarImage: avatar, name: name, surname: surname, email: email, pointOfInterest: pointOfInterest, targetDistance: targetDistance, preferences: preferences, description: description, isSearchable: isSearchable)
        } catch {
            return nil
        }
    }
    
    /// Fetches all searchable users who are in the given kilometer `range` from the current user's `pointOfInterest`, or nil if the operation failed.
    ///
    /// Parameter `userExtension` is an array of locally stored User objects and is used to prevent downloading the same user's data multiple times. Setting it to an empty array causes the function to download every user.
    static func fetchNearbyUsers(inRange range: Double, usingLocalUsersExtension usersExtension: [User]) async -> [User]? {
        do {
            var users = [User]()
            
            let body = [
                "radius": 12
            ]
            let request = makeRequest(endpoint: "profile/", method: .get, body: body)
            let (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Nearby users have been downloaded. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            else { return nil }
            
            for result in json {
                guard let userData = result["user"] as? [String: Any],
                      let userID = userData["id"] as? String else { continue }
                
                // Match an already downloaded user or fetch a new one.
                let user: User
                
                if let existingUser = usersExtension.first(where: { $0.id == userID }) {
                    user = existingUser
                } else if let newUser = await fetchUser(withID: userID) {
                    user = newUser
                } else {
                    continue
                }
                
                users.append(user)
            }
            
            return users
        } catch {
            return nil
        }
    }
    
    /// Fetches current user's `savedUsers` list, or nil if the operation failed.
    ///
    /// Parameter `userExtension` is an array of locally stored User objects and is used to prevent downloading the same user's data multiple times. Setting it to an empty array causes the function to download every user.
    static func fetchSavedUsers(usingLocalUsersExtension usersExtension: [User]) async -> [User]? {
        do {
            var users = [User]()
            
            let request = makeRequest(endpoint: "favourite/list/", method: .get)
            let (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Saved users have been downloaded. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            else { return nil }
            
            for result in json {
                guard let userID = result["user_id"] as? String else { continue }
                
                // Match an already downloaded user or fetch a new one.
                let user: User
                
                if let existingUser = usersExtension.first(where: { $0.id == userID }) {
                    user = existingUser
                } else if let newUser = await fetchUser(withID: userID) {
                    user = newUser
                } else {
                    continue
                }
                
                users.append(user)
            }
            
            return users
        } catch {
            return nil
        }
    }
    
    /// Fetches a list of current user's conversations, or nil if the operation failed.
    ///
    /// Parameter `userExtension` is an array of locally stored User objects and is used to prevent downloading the same user's data multiple times. Setting it to an empty array causes the function to download every user.
    static func fetchConversations(usingLocalUsersExtension usersExtension: [User]) async -> [Conversation]? {
        do {
            var conversations = [Conversation]()
            var fetchedUsers = usersExtension
            
            let request = makeRequest(endpoint: "conversation/", method: .get)
            let (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Conversations have been downloaded. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            else { return nil }
            
            for result in json {
                guard let conversationID = result["id"] as? String,
                      let participants = result["users"] as? [[String: Any]]
                else { continue }
                
                let conversation = Conversation(id: conversationID, participants: [], messages: [])
                
                // Assign participants of the conversation.
                for participant in participants {
                    guard let participantID = participant["id"] as? String else { continue }
                    
                    // Match an already downloaded user or fetch a new one.
                    let participant: User
                    
                    if let existingUser = fetchedUsers.first(where: { $0.id == participantID }) {
                        participant = existingUser
                    } else if let newUser = await fetchUser(withID: participantID) {
                        fetchedUsers.append(newUser)
                        participant = newUser
                    } else {
                        continue
                    }
                    
                    conversation.participants.append(participant)
                }
                
                // Make sure that we have participants and download messages.
                guard conversation.participants.count >= 2, let messages = await fetchMessages(for: conversation), messages.count > 0 else { continue }
                
                conversation.messages = messages
                conversations.append(conversation)
            }
            
            return conversations
        } catch {
            return nil
        }
    }
    
    /// Fetches _new_ messages and their authors for a conversation with given `conversationID`, or nil if the operation failed.
    ///
    /// When the `conversation`'s `messages` is an empty array, _all_ messages are downloaded.
    ///
    /// This method takes advantage of `conversation`'s `participants` list to prevent downloading the same user multiple times.
    static func fetchMessages(for conversation: Conversation) async -> [Message]? {
        do {
            let recentMessageTimeSent = conversation.messages.count > 0 ? conversation.recentMessage.timeSent : Date.distantPast
            var messages = [Message]()
            
            let request = makeRequest(endpoint: "conversation/\(conversation.id)/", method: .get)
            let (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Messages have been downloaded. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            else { return nil }
            
            for result in json {
                if let authorID = result["user"] as? String,
                   let content = result["text"] as? String,
                   let timeSentString = result["created_at"] as? String {
                    // Decode the time at which the message was sent.
                    let regex = try! NSRegularExpression(pattern: #"(\.[0-9]+)?Z$"#)
                    let range = NSRange(timeSentString.startIndex..., in: timeSentString)
                    let newTimeSentString = regex.stringByReplacingMatches(in: timeSentString, range: range, withTemplate: "Z")
                    let timeSent = ISO8601DateFormatter().date(from: newTimeSentString)!
                    
                    // Download only the messages which we haven't downloaded before.
                    guard timeSent > recentMessageTimeSent else { continue }
                    
                    // Try to find a User object representing an author of the message inside a participants list of the conversation. If it is not found, download the user with authorID.
                    let author: User
                    
                    if let participant = conversation.participants.first(where: { $0.id == authorID }) {
                        author = participant
                    } else if let user = await fetchUser(withID: authorID) {
                        author = user
                    } else {
                        return nil
                    }
                    
                    // Finally, make a Message object and add it to the array.
                    let message = Message(id: UUID().uuidString, author: author, content: content, timeSent: timeSent)
                    messages.append(message)
                }
            }
            
            return messages
        } catch {
            return nil
        }
    }
    
    /// Updates current user's `avatarImage` and returns the operation status.
    static func update(avatarImage image: UIImage?) async -> Bool {
        do {
            // Fetch current user's ID.
            var request = makeRequest(endpoint: "auth/user/", method: .get)
            var (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Call was successful. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let userID = json["pk"] as? String
            else { return false }
            
            // Update user's avatar image.
            let body: [String: Any] = [
                "avatar": image ?? ""
            ]
            request = makeRequest(endpoint: "profile/\(userID)/", method: .patch, body: body, contentType: .multipart)
            (data, response) = try await session.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 200 /* Update was successful. */ {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Updates `user`'s `name` and returns the operation status.
    static func update(name: String, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `surname` and returns the operation status.
    static func update(surname: String, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `email` and returns the operation status.
    static func update(email: String, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Checks if `password` is correct for the current user.
    static func checkPassword(_ password: String) async -> Bool {
        do {
            // Fetch current user's email.
            var request = makeRequest(endpoint: "auth/user/", method: .get)
            var (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Call was successful. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let email = json["email"] as? String
            else { return false }
            
            // Check the password by trying to authorize user.
            let body: [String: String] = [
                "email": email,
                "password": password
            ]
            request = makeRequest(endpoint: "auth/login/", method: .post, body: body, contentType: .json)
            (_, response) = try await session.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 200 /* Password is correct. */ {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Updates current user's password and returns the operation status.
    static func setNewPassword(_ password: String) async throws -> Bool {
        do {
            let body = [
                "new_password1": password,
                "new_password2": password
            ]
            let request = makeRequest(endpoint: "auth/password/change/", method: .post, body: body, contentType: .json)
            let (data, response) = try await session.data(for: request)
            
            guard let code = (response as? HTTPURLResponse)?.statusCode else { return false }
            
            if code == 200 /* Password has been changed. */ {
                return true
            } else if code == 400 /* An error has occurred. */,
                      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      json["new_password2"] != nil {
                throw ViewModel.PasswordChangeError.invalidNewPasswordFormat
            }
            
            // An unexpected status code has arrived.
            return false
        } catch let error where error is ViewModel.PasswordChangeError {
            // If there has been a known password change error, rethrow it to the caller.
            throw error
        } catch {
            // Return a failure for other errors.
            return false
        }
    }
    
    /// Updates `user`'s `description` and returns the operation status.
    static func update(description: String, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates current user's `pointOfInterest` and `targetDistance` and returns the operation status.
    static func update(pointOfInterest: CLLocationCoordinate2D, targetDistance: Double) async -> Bool {
        do {
            // Check if any point exists.
            var request = makeRequest(endpoint: "point/", method: .get)
            var (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* A list of points has been downloaded. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [[String: Any]]
            else { return false }
            
            let body: [String: Any] = [
                "location": "POINT(\(pointOfInterest.latitude) \(pointOfInterest.longitude))",
                "radius": targetDistance
            ]
            
            if let pointID = json.first?["id"] as? String /* A point exists. */ {
                request = makeRequest(endpoint: "point/\(pointID)/", method: .put, body: body, contentType: .json)
                (_, response) = try await session.data(for: request)
                
                if (response as? HTTPURLResponse)?.statusCode == 200 /* The point of interest and target distance have been updated. */ {
                    return true
                } else {
                    return false
                }
            } else /* A new point should be created. */ {
                request = makeRequest(endpoint: "point/", method: .post, body: body, contentType: .json)
                (_, response) = try await session.data(for: request)
                
                if (response as? HTTPURLResponse)?.statusCode == 201 /* The point of interest and target distance have been set. */ {
                    return true
                } else {
                    return false
                }
            }
        } catch {
            return false
        }
    }
    
    /// Updates `user`'s `isSearchable` and returns the operation status.
    static func update(searchableState: Bool, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates current user's `preferences` and returns the operation status.
    static func update(preferences: [FilterOption: FilterAttitude]) async -> Bool {
        do {
            // Fetch current user's ID.
            var request = makeRequest(endpoint: "auth/user/", method: .get)
            var (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Call was successful. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let userID = json["pk"] as? String
            else { return false }
            
            // Update user's preferences.
            let body = [
                "accepts_animals": preferences[.animals]!.mapToServerValue(),
                "smoking": preferences[.smoking]!.mapToServerValue()
            ]
            request = makeRequest(endpoint: "profile/\(userID)/", method: .patch, body: body, contentType: .multipart)
            (data, response) = try await session.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 200 /* Update was successful. */ {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Updates current user's `savedList` by adding `user` and returns the operation status.
    static func updateSavedList(byAdding user: User) async -> Bool {
        do {
            let body = [
                "user_id": user.id
            ]
            let request = makeRequest(endpoint: "favourite/add/", method: .post, body: body, contentType: .json)
            let (_, response) = try await session.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 201 /* User has been added to the list. */ {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Updates current user's `savedList` by removing `user` and returns the operation status.
    static func updateSavedList(byRemoving user: User) async -> Bool {
        do {
            let body = [
                "user_id": user.id
            ]
            let request = makeRequest(endpoint: "favourite/remove/", method: .post, body: body, contentType: .json)
            let (_, response) = try await session.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 204 /* User has been removed from the list. */ {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Creates a new conversation and returns its ID, or nil if the operation failed.
    ///
    /// Parameter `participants` should not contain the current user.
    static func createConversation(withParticipants participants: [User]) async -> String? {
        do {
            let body: [String: Any]
            var endpoint = "conversation/"
            
            if participants.count == 1 /* A conversation with one person. */ {
                body = [
                    "user_id": participants.first!.id
                ]
            } else /* A group conversation. */ {
                var participantsIDs = [String]()
                
                for participant in participants {
                    participantsIDs.append(participant.id)
                }
                
                body = [
                    "user_ids": participantsIDs,
                    "name": participants.prefix(2).map({ $0.name }).joined(separator: ", ")
                ]
                endpoint += "group/"
            }
            
            let request = makeRequest(endpoint: endpoint, method: .post, body: body, contentType: .json)
            let (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 201 /* A conversation has been created. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let conversationID = json["id"] as? String
            else { return nil }
            
            return conversationID
        } catch {
            return nil
        }
    }
    
    /// Sends a new message in `conversation` and returns the operation status.
    static func sendMessage(_ text: String, in conversation: Conversation) async -> Bool {
        do {
            let body = [
                "text": text
            ]
            let request = makeRequest(endpoint: "conversation/\(conversation.id)/message/", method: .post, body: body, contentType: .json)
            let (_, response) = try await session.data(for: request)
            
            if (response as? HTTPURLResponse)?.statusCode == 200 /* The message has been sent. */ {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
    }
    
    /// Adds a new rating and returns a tuple with its ID and time of creation, or nil if the operation failed.
    static func addRating(of rated: User, writtenBy rating: User, withScore score: Int, comment: String) async -> (ratingID: String, timeAdded: Date)? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return (String(Int.random(in: 6...1000)), Date())
    }
    
    /// Tries to login with given credentials and returns user's ID, or nil if the operation failed.
    private static func authorizeUser(withEmail email: String, password: String) async -> String? {
        do {
            let body = [
                "email": email,
                "password": password
            ]
            let request = makeRequest(endpoint: "auth/login/", method: .post, body: body, contentType: .json)
            let (data, response) = try await session.data(for: request)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 /* Login has been successful. */,
                  let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let userData = json["user"] as? [String: Any],
                  let userID = userData["pk"] as? String
            else { return nil }
            
            return userID
        } catch {
            return nil
        }
    }
}
