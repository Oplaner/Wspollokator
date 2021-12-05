//
//  Networking.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30.11.21.
//

import Foundation

class Networking {
    /// Checks if the database contains a user with given `email` and `encryptedPassword` and returns an object representing the user, or nil if they were not found.
    static func fetchUser(withEmail email: String, encryptedPassword password: String) async -> User? {
        await Task.sleep(1_000_000_000)
        return ViewModel.sampleUsers.first(where: { $0.email == email })
    }
    
    /// Updates `user`'s `name` and returns the operation status.
    static func update(name: String, forUser user: User) async -> Bool {
        await Task.sleep(1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `surname` and returns the operation status.
    static func update(surname: String, forUser user: User) async -> Bool {
        await Task.sleep(1_000_000_000)
        return true
    }
    
    /// Checks if `email` is already taken by any user.
    static func checkEmailAvailability(_ email: String) async -> Bool {
        await Task.sleep(1_000_000_000)
        return !ViewModel.sampleUsers.contains(where: { $0.email == email })
    }
    
    /// Updates `user`'s `email` and returns the operation status.
    static func update(email: String, forUser user: User) async -> Bool {
        await Task.sleep(1_000_000_000)
        return true
    }
    
    /// Checks if an already encrypted `password` is correct for `user`.
    static func checkEncryptedPassword(_ password: String, forUser user: User) async -> Bool {
        await Task.sleep(1_000_000_000)
        return true
    }
    
    /// Sets a new, already encrypted `password` for `user` and returns the operation status.
    static func setNewPassword(_ password: String, forUser user: User) async -> Bool {
        await Task.sleep(1_000_000_000)
        return true
    }
    
    /// Updates `user`'s `description` and returns the operation status.
    static func update(description: String, forUser user: User) async -> Bool {
        await Task.sleep(1_000_000_000)
        return true
    }
    
    /// Creates a new conversation and returns its ID, or nil if the operation failed.
    static func createConversation(withParticipants participants: [User]) async -> Int? {
        await Task.sleep(1_000_000_000)
        return Int.random(in: 3...1000)
    }
    
    /// Removes `conversation`, without unlinking its messages, from the database.
    static func deleteConversation(_ conversation: Conversation) async {
        await Task.sleep(1_000_000_000)
    }
    
    /// Sends a new message and returns a tuple with its ID and time of creation, or two nil values if the operation failed. The newly created message _is not_ attached to any conversation.
    static func sendMessage(_ text: String, writtenBy author: User) async -> (Int?, Date?) {
        await Task.sleep(1_000_000_000)
        return (Int.random(in: 11...1000), Date())
    }
    
    /// Links `message` to `conversation` and returns the operation status.
    static func addMessage(_ message: Message, to conversation: Conversation) async -> Bool {
        await Task.sleep(1_000_000_000)
        return true
    }
    
    /// Removes `message`, without unlinking it from a conversation, from the database.
    static func deleteMessage(_ message: Message) async {
        await Task.sleep(1_000_000_000)
    }
}
