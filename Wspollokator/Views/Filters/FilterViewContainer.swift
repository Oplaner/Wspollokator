//
//  FilterContainerView.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 12/11/2021.
//

import SwiftUI

struct FilterViewContainer: View {
    @Binding var showFilterView: Bool
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    
                    Spacer()
                    HStack {
                        Button {
                            showFilterView.toggle()
                        } label: {
                            Text("Hide")
                        }
                        .padding()
                    }
                    .foregroundColor(Appearance.textColor)
                    
                }
                FilterView(showFilterView: $showFilterView)
            }
        }
        .background(.white)
    }
}

struct FilterContainerView_Previews: PreviewProvider {
    static var previews: some View {
        FilterViewContainer(showFilterView: .constant(true))
    }
}
