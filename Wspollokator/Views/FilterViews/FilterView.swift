//
//  FilterView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import SwiftUI

struct FilterView: View {
    @State private var isChangable: Bool = false
    @State private var distance: Double = 5.0

    var body: some View {
        VStack {
                VStack {
                    HStack {
                        Text("Odl. od mojego punktu")
                        Spacer()
                        Text("do \(String.localizedStringWithFormat("%.1f km", distance))")
                    }
                    Slider(value: $distance, in: 0...10)
                }
                ForEach(FilterRowOptions.allCases, id: \.self) { filter in
                    FilterRow(imageName: filter.imageName, title: filter.title, isChangable: $isChangable)
                }
                Text("Ustaw zgodnie z moimi preferencjami")
                    .font(.headline)
                    .foregroundColor(Appearance.textColor)
            }
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView()
    }
}
