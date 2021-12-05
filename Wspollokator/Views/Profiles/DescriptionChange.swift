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
    
    @Binding var alertType: MyProfile.SettingsAlertType
    @Binding var alertMessage: String
    @Binding var isShowingAlert: Bool
    @Binding var isUpdatingDescription: Bool
    @State private var description = ""
    
    private func updateDescription() async {
        isUpdatingDescription = true
        description = description.trimmingCharacters(in: .whitespaces)
        
        if description == viewModel.currentUser!.description {
            description = viewModel.currentUser!.description
        } else {
            if await viewModel.changeCurrentUser(description: description) {
                viewModel.currentUser!.description = description
            } else {
                description = viewModel.currentUser!.description
                alertType = .error
                alertMessage = "Wystąpił błąd podczas aktualizacji opisu. Spróbuj ponownie."
                isShowingAlert = true
            }
        }
        
        isUpdatingDescription = false
    }
    
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
                Task {
                    await updateDescription()
                }
            }
        }
    }
}

struct DescriptionChange_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DescriptionChange(alertType: .constant(.error), alertMessage: .constant(""), isShowingAlert: .constant(false), isUpdatingDescription: .constant(false))
                .environmentObject(ViewModel.sample)
        }
    }
}
