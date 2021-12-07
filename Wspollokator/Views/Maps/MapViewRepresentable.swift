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
    @ObservedObject var mapData: LocationManager
    @Binding var title: String
    @Binding var tempCoordinate: CLLocationCoordinate2D
    
    func makeCoordinator() -> Coordinator {
        return MapViewRepresentable.Coordinator(parentOne: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = mapData.mapView
        map.showsUserLocation = true
        map.delegate = context.coordinator
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.longPress(gesture:)))
        gestureRecognizer.minimumPressDuration = 1.0
        map.addGestureRecognizer(gestureRecognizer)
        
        return map
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        //view.removeAnnotations(view.annotations)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        
        var parent: MapViewRepresentable
        
        init(parentOne: MapViewRepresentable) {
            parent = parentOne
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            } else {
                let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                pin.isDraggable = false
                pin.pinTintColor = .red
                pin.animatesDrop = true
                
                return pin
            }
        }
        
        @objc func longPress(gesture: UIGestureRecognizer) {
            if gesture.state == .began {
                if let mapView = gesture.view as? MKMapView {
                    mapView.removeAnnotations(mapView.annotations)
                    let point = gesture.location(in: mapView)
                    let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    mapView.addAnnotation(annotation)

                    CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)) { placeInformation, error in
                        
                        if error != nil {
                            print(error?.localizedDescription as Any)
                            return
                        }
                        
                        self.parent.title = placeInformation?.first?.name ?? placeInformation?.first?.postalCode ?? "None"
                    }
                    
                    self.parent.tempCoordinate = CLLocationCoordinate2D(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude)
                }
            }
        }
    }
}
