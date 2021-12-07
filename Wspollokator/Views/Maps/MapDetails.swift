//
//  MapDetails.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 07.12.21.
//

import MapKit

class MapDetails {
    static let defaultLocation = CLLocationCoordinate2D(latitude: 52.246195752336284, longitude: 21.017237471670718) // Warszawa
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    static let regionInMeters = CLLocationDistance(2000)
    static let zoomSpan = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
}
