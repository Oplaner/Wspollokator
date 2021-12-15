//
//  MapViewRepresentable.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 13/11/2021.
//

import MapKit
import SwiftUI

struct MapViewRepresentable: UIViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate {
        let parent: MapViewRepresentable
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        func centerView(onCoordinate coordinate: CLLocationCoordinate2D, withZoom zoom: Bool = false) {
            let region = MKCoordinateRegion(center: coordinate, span: zoom ? MapDetails.zoomSpan : MapDetails.defaultSpan)
            
            DispatchQueue.main.async {
                self.parent.mapData.mapView.setRegion(region, animated: true)
            }
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            } else {
                let pin = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                pin.animatesDrop = true
                pin.pinTintColor = .red
                return pin
            }
        }
        
        func makeAnnotation(onMapView mapView: MKMapView, atCoordinate coordinate: CLLocationCoordinate2D) {
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
        }
        
        @objc func longPress(gesture: UIGestureRecognizer) {
            if gesture.state == .began, let mapView = gesture.view as? MKMapView {
                let point = gesture.location(in: mapView)
                let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
                parent.inputCoordinate = coordinate
            }
        }
    }
    
    @ObservedObject var mapData: LocationManager
    
    @Binding var inputCoordinate: CLLocationCoordinate2D?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = mapData.mapView
        map.delegate = context.coordinator
        map.showsCompass = false
        map.showsUserLocation = true
        
        let gestureRecognizer = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.longPress(gesture:)))
        map.addGestureRecognizer(gestureRecognizer)
        
        return map
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        let coordinator = context.coordinator
        
        if let coordinate = inputCoordinate {
            let mapView = mapData.mapView
            mapView.removeAnnotations(mapView.annotations)
            coordinator.centerView(onCoordinate: coordinate, withZoom: true)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                coordinator.makeAnnotation(onMapView: mapView, atCoordinate: coordinate)
            }
        } else if let userLocation = mapData.manager?.location?.coordinate {
            coordinator.centerView(onCoordinate: userLocation)
        }
    }
}
