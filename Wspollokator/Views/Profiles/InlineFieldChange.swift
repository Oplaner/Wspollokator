//
//  InlineFieldChange.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 09.01.22.
//

import SwiftUI

struct InlineFieldChange: View {
    @FocusState var focusedFieldNumber: Int?
    
    var fieldName: String
    @Binding var fieldValue: String
    @Binding var isPresented: Bool
    @State private var prompt = ""
    
    var body: some View {
        Form {
            Section {
                HStack {
                    TextField(fieldName, text: $fieldValue, prompt: Text(prompt))
                        .focused($focusedFieldNumber, equals: 1)
                        .submitLabel(.done)
                        .onSubmit {
                            isPresented = false
                        }
                    
                    if !fieldValue.isEmpty {
                        Button {
                            fieldValue = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Color(uiColor: .tertiaryLabel))
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
        }
        .navigationTitle(fieldName)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            prompt = fieldValue
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.focusedFieldNumber = 1
            }
        }
    }
}

struct InlineFieldChange_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            InlineFieldChange(fieldName: "Imię", fieldValue: .constant("John"), isPresented: .constant(true))
        }
    }
}
