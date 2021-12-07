//
//  LocationManager.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 01/12/2021.
//
import Foundation
import MapKit

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var mapView = MKMapView()
    @Published var permissionDenied = false
    @Published var mapType: MKMapType = .standard
    
    @Published var region: MKCoordinateRegion!
    
    var shouldUpdateView: Bool = true
    
    // nil => user can turn off location services for whole phone
    var locationManager: CLLocationManager?
    
    func updateMapType() {
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    func checkIfLocationServicesIsEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
        } else {
            print("Show an alert letting user now location services for whole phone are off")
        }
    }
    
    //// The system calls this method when the app creates the related object’s CLLocationManager instance, and when the app’s authorization status changes.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            case .restricted:
                print("Location is restricted")
            case .denied:
                print("You have denied this app location permission. Change it in settings")
                permissionDenied.toggle()
            case .authorizedAlways, .authorizedWhenInUse:
                //manager.requestLocation()
                centerViewOnUserLocation()
            @unknown default:
                break
        }
    }
    
    func centerMapOnLocation(coordinate: CLLocationCoordinate2D, mapView: MKMapView) {
        let coordinateRegion = MKCoordinateRegion(center: coordinate, span: MapDetails.zoomSpan)
        
        DispatchQueue.main.async {
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func centerViewOnUserLocation() {
        if let location = locationManager?.location?.coordinate {
            region = MKCoordinateRegion.init(center: location, latitudinalMeters: MapDetails.regionInMeters, longitudinalMeters: MapDetails.regionInMeters)
            DispatchQueue.main.async {
                self.mapView.setRegion(self.region, animated: true)
                self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }

        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: MapDetails.regionInMeters, longitudinalMeters: MapDetails.regionInMeters)

        DispatchQueue.main.async {
            self.mapView.setRegion(self.region, animated: true)
            self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        }
    }
    
}
