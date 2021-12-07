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
    
    @State var searchedUsers: [User]?
    
    private var usersForAnnotations: [User]? {
        var allUsers = searchedUsers
        if allUsers != nil {
            allUsers!.append(viewModel.currentUser!)
            
            return allUsers
        }
        
        return nil
    }
    
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
                    annotationItems: usersForAnnotations!) { user in
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
                        .strokeBorder(.black, lineWidth: 3)
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
                    if user.avatarImage != nil {
                        user.avatarImage!
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 48, height: 48)
                            .overlay(Circle().stroke(Color.black, lineWidth: 3))
                            .shadow(color: .gray, radius: 1, x: 0, y: 1)
                    } else {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 48, height: 48)
                            .overlay(Circle().stroke(Color.black, lineWidth: 3))
                            .shadow(color: .gray, radius: 1, x: 0, y: 1)
                    }
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
