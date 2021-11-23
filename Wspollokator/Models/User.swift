//
//  User.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import CoreLocation
import SwiftUI

class User: Identifiable, Equatable {
    enum PasswordChangeError: Error {
        case invalidOldPassword
        case unmatchingNewPasswords
        case oldAndNewPasswordsEqual
    }
    
    let id: Int
    
    var avatarImage: Image?
    var name: String
    var surname: String
    var email: String
    var pointOfInterest: CLLocationCoordinate2D?
    var targetDistance: Double
    var preferences: [FilterOption: FilterAttitude]
    var description: String
    var savedUsers: [User]
    var isSearchable: Bool
    
    init(id: Int, avatarImage: Image? = nil, name: String, surname: String, email: String, pointOfInterest: CLLocationCoordinate2D? = nil, targetDistance: Double = ViewModel.defaultTargetDistance, preferences: [FilterOption: FilterAttitude] = ViewModel.defaultPreferences, description: String = "", savedUsers: [User] = [User](), isSearchable: Bool = false) {
        self.id = id
        self.avatarImage = avatarImage
        self.name = name
        self.surname = surname
        self.email = email
        self.pointOfInterest = pointOfInterest
        self.targetDistance = targetDistance
        self.preferences = preferences
        self.description = description
        self.savedUsers = savedUsers
        self.isSearchable = isSearchable
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
    
    func changePassword(oldPassword old: String, newPassword new1: String, confirmation new2: String) throws -> Bool {
        // TODO: Check if encrypted old password matches value stored on the server.
        guard old == "qwerty" else { throw PasswordChangeError.invalidOldPassword }
        guard new1 == new2 else { throw PasswordChangeError.unmatchingNewPasswords }
        guard new1 != old else { throw PasswordChangeError.oldAndNewPasswordsEqual }
        
        // TODO: Try to set new password and return the operation status.
        // TODO: Make this asynchronous!
        
        return true
    }
    
    /// Calculates distance, in kilometers, between the receiver's and other user's `pointOfInterest`.
    func distance(from user: User) -> Double? {
        guard pointOfInterest != nil && user.pointOfInterest != nil else { return nil }
        
        let receiverPointLocation = CLLocation(latitude: pointOfInterest!.latitude, longitude: pointOfInterest!.longitude)
        let otherUserPointLocation = CLLocation(latitude: user.pointOfInterest!.latitude, longitude: user.pointOfInterest!.longitude)
        
        return receiverPointLocation.distance(from: otherUserPointLocation) / 1000
    }
    
    /// Decodes street or city describing location of the receiver's `pointOfInterest` and uses `storeHandler` to store the result when it arrives.
    func fetchNearestLocationName(storingWith storeHandler: @escaping ((String?) -> Void)) {
        guard pointOfInterest != nil else { return }
        
        let location = CLLocation(latitude: pointOfInterest!.latitude, longitude: pointOfInterest!.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if error == nil, let placemark = placemarks?.first {
                storeHandler(placemark.name ?? placemark.locality)
            }
        }
    }
}
