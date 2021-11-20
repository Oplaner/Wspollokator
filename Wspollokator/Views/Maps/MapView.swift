//
//  MapView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @State private var region = MKCoordinateRegion(
            center: MapDetails.startingLocation,
            span: MapDetails.defaultSpan)
    
    let screen = UIScreen.main.bounds
    
    // Temporary annotations placeholders
    let annotations = ViewModel.sampleUsers[0...2]
    
    var body: some View {
        ZStack {
            Map(coordinateRegion: $region,
                interactionModes: .all,
                showsUserLocation: true,
                annotationItems: annotations) { user in
                MapAnnotation(coordinate: user.pointOfInterest!) {
                    ZStack {
                        Circle()
                            .strokeBorder(Color.black, lineWidth: 4)
                            .background(Circle().foregroundColor(Appearance.buttonColor))
                            .frame(width: 52, height: 52)
                        Text("\(user.name)")
                            .bold()
                    }
                    .foregroundColor(.white)
                }
            }
        }
    }
}

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.01753)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
    static let regionInMeters = CLLocationDistance(2000)
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
