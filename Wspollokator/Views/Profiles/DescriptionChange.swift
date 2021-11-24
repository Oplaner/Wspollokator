//
//  DescriptionChange.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 24.11.21.
//

import SwiftUI

struct DescriptionChange: View {
    @EnvironmentObject var viewModel: ViewModel
    @FocusState var focusedFieldNumber: Int?
    
    @State private var description = ""
    
    var body: some View {
        ScrollViewReader { reader in
            Form {
                TextEditor(text: $description)
                    .frame(minHeight: 0.3 * UIScreen.main.bounds.height)
                    .lineLimit(nil)
                    .foregroundColor(Appearance.textColor)
                    .focused($focusedFieldNumber, equals: 1)
                    .id(1)
                    .onChange(of: description) { _ in
                        reader.scrollTo(1, anchor: .bottom)
                    }
            }
            .navigationTitle("Mój opis")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                description = viewModel.currentUser!.description
                reader.scrollTo(1, anchor: .bottom)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.focusedFieldNumber = 1
                }
            }
            .onDisappear {
                viewModel.currentUser!.description = description
            }
        }
    }
}

struct DescriptionChange_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DescriptionChange()
                .environmentObject(ViewModel.sample)
        }
    }
}
