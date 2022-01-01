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
                        
                        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                        data.append("Content-Disposition: form-data; name=\(key)\r\n".data(using: .utf8)!)
                        data.append("Content-Type: image/\(format)\r\n\r\n".data(using: .utf8)!)
                        data.append(imageData)
                    default:
                        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                        data.append("Content-Disposition: form-data; name=\(key)\r\n".data(using: .utf8)!)
                        data.append("Content-Type: text/plain\r\n\r\n".data(using: .utf8)!)
                        data.append(String(describing: value).data(using: .utf8)!)
                    }
                }
                
                data.append("\r\n--\(boundary)--".data(using: .utf8)!)
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
                        throw ViewModel.SignUpError.invalidEmail
                    } else if emailErrors.contains(where: { $0.contains("exists") }) {
                        throw ViewModel.SignUpError.emailAlreadyTaken
                    }
                }
                
                if json["password"] != nil {
                    throw ViewModel.SignUpError.invalidPassword
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
                  let avatarURLString = profileDetails["avatar"] as? String,
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
            
            if avatarURLString != defaultAvatarURLString {
                let avatarURL = URL(string: avatarURLString)!
                let (imageURL, _) = try await session.download(from: avatarURL)
                
                if let image = UIImage(contentsOfFile: imageURL.absoluteString) {
                    avatar = Image(uiImage: image)
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
    
    /// Updates `user`'s `avatarImage` and returns the operation status.
    static func update(avatarImage image: UIImage?, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
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
    
    /// Checks if `password` is correct for `user`.
    static func checkPassword(_ password: String, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Sets a new `password` for `user` and returns the operation status.
    static func setNewPassword(_ password: String, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `description` and returns the operation status.
    static func update(description: String, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `pointOfInterest` and returns the operation status.
    static func update(pointOfInterest: CLLocationCoordinate2D?, forUser user: User) async -> Bool {
        //        EXAMPLE BODY FOR CREATING A POINT:
        //        body = [
        //            "location": "POINT(52.22322350545386 21.01232058780615)",
        //            "radius": 3.1
        //        ]
        //        RESPONSE CODE ON SUCCESS: 201
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `isSearchable` and returns the operation status.
    static func update(searchableState: Bool, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `targetDistance` and returns the operation status.
    static func update(targetDistance: Double, forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `preferences` and returns the operation status.
    static func update(preferences: [FilterOption: FilterAttitude], forUser user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `listOwner`s `savedList` by adding `otherUser` and returns the operation status.
    static func updateSavedList(ofUser listOwner: User, adding otherUser: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Updates `listOwner`s `savedList` by removing `otherUser` and returns the operation status.
    static func updateSavedList(ofUser listOwner: User, removing otherUser: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Creates a new conversation and returns its ID, or nil if the operation failed.
    static func createConversation(withParticipants participants: [User]) async -> String? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return String(Int.random(in: 3...1000))
    }
    
    /// Removes `conversation`, without unlinking its messages, from the database.
    static func deleteConversation(_ conversation: Conversation) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    /// Sends a new message and returns a tuple with its ID and time of creation, or nil if the operation failed. The newly created message _is not_ attached to any conversation.
    static func sendMessage(_ text: String, writtenBy author: User) async -> (messageID: String, timeSent: Date)? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return (String(Int.random(in: 11...1000)), Date())
    }
    
    /// Links `message` to `conversation` and returns the operation status.
    static func addMessage(_ message: Message, to conversation: Conversation) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return true
    }
    
    /// Removes `message`, without unlinking it from a conversation, from the database.
    static func deleteMessage(_ message: Message) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
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
