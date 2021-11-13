//
//  User.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import SwiftUI
import MapKit

class User: Identifiable {
    let id: UUID
    
    var avatarImage: Image?
    var name: String
    var surname: String
    var distance: Float // Temporary!
    var nearestLocationName: String // Temporary!
    var description: String
    var coordinate: CLLocationCoordinate2D
    var isSaved: Bool // Temporary!
    
    // TODO: Complete the model with user's preferences. Add distance calculation and nearest location name retrieval.
    
    init(avatarImage: Image?, name: String, surname: String, distance: Float, nearestLocationName: String, description: String, coordinate: CLLocationCoordinate2D, isSaved: Bool) {
        id = UUID()
        self.avatarImage = avatarImage
        self.name = name
        self.surname = surname
        self.distance = distance
        self.nearestLocationName = nearestLocationName
        self.description = description
        self.coordinate = coordinate
        self.isSaved = isSaved
    }
}
