//
//  MapViewRepresentable.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 13/11/2021.
//

import Foundation
import MapKit
import SwiftUI

struct MapViewRepresentable: UIViewRepresentable {
    @Binding var title: String
    @Binding var subtitle: String
    
    func makeCoordinator() -> Coordinator {
        return MapViewRepresentable.Coordinator(parentOne: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.showsUserLocation = true
        
        let coordinate = CLLocationCoordinate2D(latitude: 52.237, longitude: 21.017)
        map.region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        map.delegate = context.coordinator
        map.addAnnotation(annotation)

        return map
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        //
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapViewRepresentable
        
        init(parentOne: MapViewRepresentable) {
            parent = parentOne
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            pin.isDraggable = true
            pin.pinTintColor = .red
            pin.animatesDrop = true
            
            return pin
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
            print("User latitude: \(view.annotation?.coordinate.latitude ?? 0) and longitude: \(view.annotation?.coordinate.longitude ?? 0)")
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: (view.annotation?.coordinate.latitude)!, longitude: (view.annotation?.coordinate.longitude)!)) { placeInformation, error in
                
                if error != nil {
                    print(error?.localizedDescription as Any)
                    return
                }
                
                self.parent.title = placeInformation?.first?.name ?? placeInformation?.first?.postalCode ?? "None"
                self.parent.subtitle = placeInformation?.first?.subLocality ?? placeInformation?.first?.locality ?? "None"
            }
        }
    }
}
