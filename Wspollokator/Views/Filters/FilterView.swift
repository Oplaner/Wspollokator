//
//  FilterView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import SwiftUI

struct FilterView: View {
    @State var isChangable: Bool = true // could be a computed property in future
    @State var distance: Double = 5.0
    
    @Binding var showFilterView: Bool

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
                FilterRow(icon: filter.icon, title: filter.title, isChangable: $isChangable)
            }
            Button {
                // TODO: Reset filters according to user's preferences
            } label: {
                Text("Ustaw zgodnie z moimi preferencjami")
                    .foregroundColor(Appearance.textColor)
            }
        }
    }
}


struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        FilterView(showFilterView: .constant(true))
    }
}
