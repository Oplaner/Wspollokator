//
//  Networking.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30.11.21.
//

import CoreLocation
import UIKit

class Networking {
    /// Tries to create a new user in the database and returns their ID, or nil if the operation failed.
    static func createUserAccount(name: String, surname: String, email: String, password: String) async -> Int? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return Int.random(in: 6...1000)
    }
    
    /// Checks if the database contains a user with given `email` and `password` and returns an object representing the user, or nil if they were not found.
    static func fetchUser(withEmail email: String, password: String) async -> User? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return await ViewModel.sampleUsers.first(where: { $0.email == email })
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
    
    /// Checks if `email` is already taken by any user.
    static func checkEmailAvailability(_ email: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return await !ViewModel.sampleUsers.contains(where: { $0.email == email })
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
    static func createConversation(withParticipants participants: [User]) async -> Int? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return Int.random(in: 3...1000)
    }
    
    /// Removes `conversation`, without unlinking its messages, from the database.
    static func deleteConversation(_ conversation: Conversation) async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }
    
    /// Sends a new message and returns a tuple with its ID and time of creation, or nil if the operation failed. The newly created message _is not_ attached to any conversation.
    static func sendMessage(_ text: String, writtenBy author: User) async -> (messageID: Int, timeSent: Date)? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return (Int.random(in: 11...1000), Date())
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
    static func addRating(of rated: User, writtenBy rating: User, withScore score: Int, comment: String) async -> (ratingID: Int, timeAdded: Date)? {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        return (Int.random(in: 6...1000), Date())
    }
}
