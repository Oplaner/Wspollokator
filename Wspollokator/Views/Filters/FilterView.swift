//
//  FilterView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import SwiftUI

struct FilterView: View {
    @Binding var targetDistance: Double
    @Binding var isChangingTargetDistance: Bool
    @Binding var preferencesSource: [FilterOption: FilterAttitude]
    
    var body: some View {
        Group {
            VStack {
                HStack {
                    Text("Odl. od mojego punktu")
                    Spacer()
                    Text("do \(String.localizedStringWithFormat("%.1f km", targetDistance))")
                        .foregroundColor(.secondary)
                }
                Slider(value: $targetDistance, in: 0...10) {
                    isChangingTargetDistance = $0
                }
            }
            .padding(.vertical)
            
            ForEach(FilterOption.allCases, id: \.self) { filter in
                let binding = Binding<FilterAttitude>(
                    get: { preferencesSource[filter]! },
                    set: { preferencesSource[filter]! = $0 }
                )
                FilterRow(filter: filter, selection: binding)
            }
        }
    }
}

struct FilterView_Previews: PreviewProvider {
    static var previews: some View {
        List {
            FilterView(targetDistance: .constant(5), isChangingTargetDistance: .constant(false), preferencesSource: .constant([.animals: .positive, .smoking: .negative]))
        }
    }
}
