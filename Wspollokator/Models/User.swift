//
//  User.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import MapKit
import SwiftUI

struct User: Identifiable {
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
    
    /// Calculates distance, in kilometers, between the closest points in the receiver's area and the current user's area.
    var distanceFromSelectedArea: Double? {
        get {
            let currentUserPoint: CLLocationCoordinate2D? = CLLocationCoordinate2D(latitude: 52.1618325903034, longitude: 21.046584867271402) // WZIM, temporary. :)
            let currentUserTargetDistance: Double = 5 // Temporary.
            
            guard pointOfInterest != nil && currentUserPoint != nil else { return nil }
            
            let receiverPointLocation = CLLocation(latitude: pointOfInterest!.latitude, longitude: pointOfInterest!.longitude)
            let currentUserPointLocation = CLLocation(latitude: currentUserPoint!.latitude, longitude: currentUserPoint!.longitude)
            return (receiverPointLocation.distance(from: currentUserPointLocation) - targetDistance - currentUserTargetDistance) / 1000
        }
    }
    
    /// Decodes name, street or city describing location of the receiver's point of interest, or an empty string in case of failure.
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
}
