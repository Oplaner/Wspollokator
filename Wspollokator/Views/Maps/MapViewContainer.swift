//
//  MapViewContainer.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 13/11/2021.
//

import SwiftUI
import MapKit
import CoreLocationUI

struct MapViewContainer: View {
    @StateObject var mapData = LocationManager()
    
    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @Binding var pointOfInterest: CLLocationCoordinate2D?
    @State var tempCoordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    
    var body: some View {
        ZStack {
            MapViewRepresentable(mapData: mapData, title: $title, tempCoordinate: $tempCoordinate)
                .ignoresSafeArea()
                .environmentObject(mapData)
            
            VStack {
                VStack {
                    Text("Przytrzymaj palec na mapie, aby ustawić swój punkt")
                        .font(.subheadline)
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(16)
                    
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            mapData.centerViewOnUserLocation()
                        }, label: {
                            Image(systemName: "location.fill")
                                .font(.title2)
                                .padding()
                                .background(.ultraThinMaterial)
                                .clipShape(Circle())
                                .foregroundColor(Color.gray)
                        })
                    }
                }
                
                Spacer()
                
                if !title.isEmpty {
                    VStack(spacing: 12) {
                        
                        HStack(spacing: 12) {
                            Image(systemName:"info.circle.fill").font(.caption).foregroundColor(.black)
                            
                            VStack(alignment: .leading, spacing: 15) {
                                Text(self.title)
                                    .font(.subheadline)
                            }
                            .foregroundColor(Appearance.textColor)
                            
                        }
                        
                        Button {
                            self.pointOfInterest = CLLocationCoordinate2D(latitude: tempCoordinate.latitude, longitude: tempCoordinate.longitude)
                            mapData.centerMapOnLocation(coordinate: self.pointOfInterest!, mapView: mapData.mapView)
                        } label: {
                            Text("Ustaw na bieżącą lokalizację")
                        }
                    }
                    .padding(12)
                    .font(.subheadline)
                    .background(.ultraThinMaterial)
                    .cornerRadius(15)
                }
            }
            .padding()
        }
        .onAppear(perform: {
            mapData.checkIfLocationServicesIsEnabled()
        })
    }
}

struct MapViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContainer(pointOfInterest: .constant(CLLocationCoordinate2D(latitude: 52.237, longitude: 21.017)), tempCoordinate: CLLocationCoordinate2D(latitude: 52.237, longitude: 21.017))
    }
}
