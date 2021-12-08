//
//  LocationManager.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 01/12/2021.
//

import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let mapView = MKMapView()
    
    @Published var isAuthorized = false
    var manager: CLLocationManager?
    
    func enableLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager!.delegate = self
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            isAuthorized = false
        case .authorizedAlways, .authorizedWhenInUse:
            isAuthorized = true
        default:
            break
        }
    }
}
