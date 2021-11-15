//
//  FilterRow.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import SwiftUI

struct FilterRow: View {
    var imageName: String
    var title: String
    //var size: CGFloat
    @Binding var isChangable: Bool
    @State private var selectedFilterType: SelectedFilterType = .neutral
    
    let screen = UIScreen.main.bounds
    
    var body: some View {
        HStack {
            Image(systemName: imageName)
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)
                .clipShape(Circle())
            
            Text(title)
                .font(.headline)
                .lineLimit(2)
                .frame(alignment: .leading)
            
            Spacer()
            
            Picker("Choose a type", selection: $selectedFilterType) {
                ForEach(SelectedFilterType.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .frame(width: screen.width / 3.8 )
            .pickerStyle(SegmentedPickerStyle())
            .disabled(isChangable)
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
        FilterRow(imageName: "hare.fill", title: "Zwierzęta domowe", isChangable: .constant(true))
    }
}
