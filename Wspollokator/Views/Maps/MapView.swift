//
//  MapView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 02/11/2021.
//

import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var viewModel: ViewModel
    
    @State private var region: MKCoordinateRegion = MKCoordinateRegion(center: MapDetails.startingLocation, span: MapDetails.defaultSpan)
    
    @State private var allUsers: [User] = []
    
    // Temporary annotations placeholders
    let annotations = ViewModel.sampleUsers[0...2]
    
    var searchedUsers: [User]?
    
    var body: some View {
        ZStack {
            if searchedUsers == nil {
                List {
                    Text("Aby móc wyszukiwać współlokatorów, ustaw swój punkt")
                        .foregroundColor(Appearance.textColor)
                }
            } else if searchedUsers!.isEmpty {
                List {
                    Text("Nie znaleziono osób spełniających zadane kryteria")
                        .foregroundColor(Appearance.textColor)
                }
            } else {
                Map(coordinateRegion: $region,
                    interactionModes: .all,
                    showsUserLocation: false,
                    annotationItems: searchedUsers!) { user in
                    mark(for: user)
                }
            }
        }
    }
    
    private func mark(for user: User) -> some MapAnnotationProtocol {
        if user == viewModel.currentUser {
            return AnyMapAnnotationProtocol(MapAnnotation(coordinate: user.pointOfInterest!) {
                ZStack {
                    Circle()
                        .strokeBorder(Color.black, lineWidth: 3)
                        .background(Circle().foregroundColor(.white))
                        .frame(width: 52, height: 52)
                    Text("\("TY")")
                        .foregroundColor(Appearance.textColor)
                        .font(.caption)
                        .bold()
                }
                .foregroundColor(.white)
            })
        } else {
            return AnyMapAnnotationProtocol(MapAnnotation(coordinate: user.pointOfInterest!) {
                NavigationLink {
                    UserProfile(user: user)
                } label: {
                    Text("\(user.name)")
                        .font(.caption)
                        .bold()
                        .padding(6)
                        .foregroundColor(Color.white)
                        .font(.body)
                        .background(
                            Circle()
                                .strokeBorder(Color.black, lineWidth: 3)
                                .background(Circle().foregroundColor(Appearance.buttonColor))
                                .scaledToFill()
                        )
                }
            })
        }
     }
}

private struct AnyMapAnnotationProtocol: MapAnnotationProtocol {
  let _annotationData: _MapAnnotationData
  let value: Any

  init<WrappedType: MapAnnotationProtocol>(_ value: WrappedType) {
    self.value = value
    _annotationData = value._annotationData
  }
}

enum MapDetails {
    static let startingLocation = CLLocationCoordinate2D(latitude: 52.237049, longitude: 21.01753)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.12, longitudeDelta: 0.12)
    static let regionInMeters = CLLocationDistance(2000)
    static let zoomSpan = MKCoordinateSpan(latitudeDelta: 0.04, longitudeDelta: 0.04)
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
