//
//  MapViewContainer.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 13/11/2021.
//

import MapKit
import SwiftUI

struct MapViewContainer: View {
    @EnvironmentObject var viewModel: ViewModel
    @StateObject var mapData = LocationManager()
    
    let panelMaterial = Material.regularMaterial
    let panelCornerRadius: CGFloat = 14
    let panelSpacing: CGFloat = 14
    
    @Binding var alertType: MyProfile.SettingsAlertType
    @Binding var alertMessage: String
    @Binding var isShowingAlert: Bool
    @Binding var isUpdatingPointOfInterest: Bool
    @State private var inputCoordinate: CLLocationCoordinate2D?
    @State private var inputDescription: String?
    
    private var alternativeInstruction: String {
        if mapData.isAuthorized {
            return " lub użyj przycisku na dole ekranu"
        } else {
            return ""
        }
    }
    
    private var currentPointString: String {
        if let point = inputDescription {
            return "📍Aktualny punkt: \(point)"
        } else if let coordinate = inputCoordinate {
            return "📍Aktualny punkt: \(defaultDescription(for: coordinate))"
        } else {
            return ""
        }
    }
    
    private func defaultDescription(for coordinate: CLLocationCoordinate2D) -> String {
        String.localizedStringWithFormat("%.5f, %.5f", coordinate.latitude, coordinate.longitude)
    }
    
    private func fetchInputDescription() async {
        guard let coordinate = inputCoordinate else { return }
        
        let defaultString = defaultDescription(for: coordinate)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        if let placemark = try? await geocoder.reverseGeocodeLocation(location).first {
            inputDescription = placemark.name ?? placemark.locality ?? defaultString
        } else {
            inputDescription = defaultString
        }
    }
    
    private func updatePointOfInterest() async {
        guard inputCoordinate != viewModel.currentUser!.pointOfInterest else { return }
        isUpdatingPointOfInterest = true
        
        if await viewModel.changeCurrentUser(pointOfInterest: inputCoordinate) {
            viewModel.objectWillChange.send()
            viewModel.currentUser!.pointOfInterest = inputCoordinate
        } else {
            inputCoordinate = viewModel.currentUser!.pointOfInterest
            alertType = .error
            alertMessage = "Wystąpił błąd podczas aktualizacji punktu. Spróbuj ponownie."
            isShowingAlert = true
        }
        
        isUpdatingPointOfInterest = false
    }
    
    var body: some View {
        ZStack {
            MapViewRepresentable(mapData: mapData, inputCoordinate: $inputCoordinate)
            
            VStack {
                VStack(alignment: .leading, spacing: panelSpacing) {
                    Text("Aby ustawić swój punkt, przytrzymaj palec na mapie\(alternativeInstruction).")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    if !currentPointString.isEmpty {
                        Text(currentPointString)
                    }
                }
                .padding()
                .background(panelMaterial)
                .cornerRadius(panelCornerRadius)
                
                Spacer()
                
                if mapData.isAuthorized {
                    VStack {
                        Button("Ustaw tu, gdzie jestem") {
                            if let userLocation = mapData.manager?.location?.coordinate {
                                inputCoordinate = userLocation
                            }
                        }
                    }
                    .padding()
                    .background(panelMaterial)
                    .cornerRadius(panelCornerRadius)
                }
            }
            .padding()
        }
        .navigationTitle("Mój punkt")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            mapData.enableLocationServices()
            inputCoordinate = viewModel.currentUser!.pointOfInterest
        }
        .onChange(of: inputCoordinate) { _ in
            Task {
                await fetchInputDescription()
            }
        }
        .onDisappear {
            Task {
                await updatePointOfInterest()
            }
        }
    }
}

struct MapViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContainer(alertType: .constant(.error), alertMessage: .constant(""), isShowingAlert: .constant(false), isUpdatingPointOfInterest: .constant(false))
            .environmentObject(ViewModel.sample)
    }
}
