//
//  Networking.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30.11.21.
//

import CoreLocation
import UIKit

/*
 
 NOTE: This class, in the version of "offline-demo" branch, has been modified to serve for demo purposes. Each server call is simulated by a half-second-long delay.
 
 */

class Networking {
    /// Tries to create a new user in the database and returns their ID, or nil if the operation failed.
    static func createUserAccount(name: String, surname: String, email: String, password: String) async throws -> String? {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return String(Int.random(in: 6...1000))
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
        try? await Task.sleep(nanoseconds: 500_000_000)
        return await ViewModel.sampleUsers.first { $0.id == userID }
    }
    
    /// Updates current user's `avatarImage` and returns the operation status.
    static func update(avatarImage image: UIImage?) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `name` and returns the operation status.
    static func update(name: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `surname` and returns the operation status.
    static func update(surname: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Checks if `password` is correct for the current user.
    static func checkPassword(_ password: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's password and returns the operation status.
    static func setNewPassword(_ password: String) async throws -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `description` and returns the operation status.
    static func update(description: String) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `pointOfInterest` and `targetDistance` and returns the operation status.
    static func update(pointOfInterest: CLLocationCoordinate2D, targetDistance: Double) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `isSearchable` and returns the operation status.
    static func update(searchableState: Bool) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `preferences` and returns the operation status.
    static func update(preferences: [FilterOption: FilterAttitude]) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `savedList` by adding `user` and returns the operation status.
    static func updateSavedList(byAdding user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Updates current user's `savedList` by removing `user` and returns the operation status.
    static func updateSavedList(byRemoving user: User) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Creates a new conversation and returns its ID, or nil if the operation failed.
    ///
    /// Parameter `participants` should not contain the current user.
    static func createConversation(withParticipants participants: [User]) async -> String? {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return String(Int.random(in: 3...1000))
    }
    
    /// Sends a new message in `conversation` and returns the operation status.
    static func sendMessage(_ text: String, in conversation: Conversation) async -> Bool {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    /// Adds a new rating written by current user and returns a tuple with its ID and time of creation, or nil if the operation failed.
    static func addRating(of user: User, withScore score: Int, comment: String) async -> (ratingID: String, timeAdded: Date)? {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return (String(Int.random(in: 6...1000)), Date())
    }
    
    /// Tries to login with given credentials and returns user's ID, or nil if the operation failed.
    private static func authorizeUser(withEmail email: String, password: String) async -> String? {
        try? await Task.sleep(nanoseconds: 500_000_000)
        return await ViewModel.sampleUsers.first(where: { $0.email == email })?.id
    }
}
