//
//  MapViewContainer.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 13/11/2021.
//

import SwiftUI

struct MapViewContainer: View {
    @State private var title = ""
    @State private var subtitle = ""
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapViewRepresentable(title: $title, subtitle: $subtitle)
                .ignoresSafeArea()
            
            if !title.isEmpty {
                HStack(spacing: 12) {
                    Image(systemName: "info.circle.fill").font(.title).foregroundColor(.black)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text(self.title)
                            .font(.caption)
                        Text(self.subtitle)
                            .font(.caption)
                    }
                    .foregroundColor(Appearance.textColor)
                    
                }
                .padding(12)
                .background(Appearance.backgroundColor)
                .cornerRadius(15)
            }
            
        }
    }
}

struct MapViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        MapViewContainer()
    }
}
