//
//  FilterRow.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import SwiftUI

struct FilterRow: View {
    var icon: String
    var title: String
    //var size: CGFloat
    @Binding var isChangable: Bool
    @State private var selectedFilterType: SelectedFilterType = .neutral
    
    let screen = UIScreen.main.bounds
    
    var body: some View {
        HStack {
            Text(icon)
                .font(.title)
            
            Text(title)
            
            Spacer()
            
            Picker("Choose a type ", selection: $selectedFilterType) {
                ForEach(SelectedFilterType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .frame(width: screen.width / 3.6)
            .pickerStyle(SegmentedPickerStyle())
            .disabled(!isChangable)
            // ctrl cmd space for emotes
        }
    }
}

enum SelectedFilterType: String, CaseIterable {
    case negative = "🚫"
    case neutral = "⚪️"
    case positive = "✅"
}

struct FilterRow_Previews: PreviewProvider {
    static var previews: some View {
        FilterRow(icon: "🐶", title: "Zwierzęta domowe", isChangable: .constant(true))
    }
}
