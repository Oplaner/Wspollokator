//
//  NewRating.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 20.12.21.
//

import SwiftUI

struct NewRating: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState var focusedFieldNumber: Int?
    
    @State private var score = 0
    @State private var comment = ""
    @State private var isAdding = false
    @State private var isShowingAlert = false
    
    private var commentTrimmed: String {
        comment.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func addRating() async {
        
    }
    
    var body: some View {
        ScrollViewReader { reader in
            Form {
                RatingStars(score: $score, isInteractive: true)
                    .disabled(isAdding)
                
                TextEditor(text: $comment)
                    .frame(minHeight: 0.3 * UIScreen.main.bounds.height)
                    .lineLimit(nil)
                    .focused($focusedFieldNumber, equals: 1)
                    .id(1)
                    .disabled(isAdding)
                    .onChange(of: comment) { _ in
                        reader.scrollTo(1, anchor: .bottom)
                    }
            }
            .navigationTitle("Nowa opinia")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.focusedFieldNumber = 1
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Anuluj") {
                        dismiss()
                    }
                    .disabled(isAdding)
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    if isAdding {
                        ProgressView()
                    } else {
                        Button {
                            Task {
                                await addRating()
                            }
                        } label: {
                            Text("Dodaj")
                                .bold()
                        }
                        .disabled(score == 0 || commentTrimmed.isEmpty)
                    }
                }
            }
            .alert("Błąd", isPresented: $isShowingAlert, actions: {}) {
                Text("Wystąpił błąd podczas dodawania opinii. Spróbuj ponownie.")
            }
        }
    }
}

struct NewRating_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NewRating()
                .environmentObject(ViewModel.sample)
        }
    }
}
