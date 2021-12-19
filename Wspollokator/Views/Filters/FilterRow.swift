//
//  FilterRow.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import SwiftUI

struct FilterRow: View {
    var filter: FilterOption
    @Binding var sourceSelection: FilterAttitude
    @State private var selection = FilterAttitude.neutral
    
    var body: some View {
        HStack {
            Text(filter.icon)
                .font(.title)
            Text(filter.title)
            Spacer()
            Picker("Dostosuj filtr", selection: $selection) {
                ForEach(FilterAttitude.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .frame(width: 0.3 * UIScreen.main.bounds.width)
            .pickerStyle(.segmented)
            .onAppear {
                selection = sourceSelection
            }
            .onChange(of: selection) { _ in
                sourceSelection = selection
            }
            .onChange(of: sourceSelection) { _ in
                selection = sourceSelection
            }
        }
    }
}

struct FilterRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            FilterRow(filter: .animals, sourceSelection: .constant(.positive))
            FilterRow(filter: .smoking, sourceSelection: .constant(.negative))
        }
        .previewLayout(.fixed(width: 400, height: 50))
    }
}
