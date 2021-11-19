//
//  User.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import CoreLocation
import SwiftUI

class User: Identifiable, Equatable {
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
    
    /// Decodes name, street or city describing location of the receiver's point of interest, or an empty string in case of failure. Returns nil if the point of interest has not been set.
    var nearestLocationName: String? {
        get {
            guard pointOfInterest != nil else { return "" }
            
            let location = CLLocation(latitude: pointOfInterest!.latitude, longitude: pointOfInterest!.longitude)
            let geocoder = CLGeocoder()
            var name: String?
            
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if error == nil, let placemark = placemarks?.first {
                    name = placemark.name ?? placemark.thoroughfare ?? placemark.locality
                }
            }
            
            return name
        }
    }
    
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
    
    /// Calculates distance, in kilometers, between the receiver's and other user's points of interest.
    func getDistance(from user: User) -> Double? {
        guard pointOfInterest != nil && user.pointOfInterest != nil else { return nil }
        
        let receiverPointLocation = CLLocation(latitude: pointOfInterest!.latitude, longitude: pointOfInterest!.longitude)
        let otherUserPointLocation = CLLocation(latitude: user.pointOfInterest!.latitude, longitude: user.pointOfInterest!.longitude)
        
        return receiverPointLocation.distance(from: otherUserPointLocation) / 1000
    }
}
