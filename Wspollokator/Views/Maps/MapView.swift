//
//  MapView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import MapKit
import SwiftUI

struct MapView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var searchResults: [User]?
    @State private var region = MKCoordinateRegion(center: MapDetails.defaultLocation, span: MapDetails.defaultSpan)
    
    private var usersForAnnotations: [User]? {
        var annotations = searchResults
        
        if annotations != nil {
            annotations!.append(viewModel.currentUser!)
        }
        
        return annotations
    }
    
    private func centerOnCurrentUser() {
        if let center = viewModel.currentUser!.pointOfInterest {
            withAnimation {
                region = MKCoordinateRegion(center: center, span: MapDetails.defaultSpan)
            }
        }
    }
    
    var body: some View {
        if searchResults == nil {
            List {
                Text("Aby móc wyszukiwać współlokatorów, ustaw swój punkt.")
                    .foregroundColor(.secondary)
            }
        } else if searchResults!.isEmpty {
            List {
                Text("Nie znaleziono osób spełniających zadane kryteria.")
                    .foregroundColor(.secondary)
            }
        } else {
            Map(coordinateRegion: $region, interactionModes: .all, showsUserLocation: false, annotationItems: usersForAnnotations!) { user in
                MapAnnotation(coordinate: user.pointOfInterest!) {
                    UserAnnotation(user: user, isCurrentUser: user == viewModel.currentUser!, size: 50)
                }
            }
            .onAppear {
                centerOnCurrentUser()
            }
            .onChange(of: viewModel.searchTargetDistance) { _ in
                centerOnCurrentUser()
            }
            .onChange(of: viewModel.searchPreferences) { _ in
                centerOnCurrentUser()
            }
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
            .environmentObject(ViewModel.sample)
    }
}
