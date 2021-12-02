//
//  NewConversation.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 01.12.21.
//

import SwiftUI

struct NewConversation: View {
    @EnvironmentObject var viewModel: ViewModel
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShowingConversationView: Bool
    @Binding var newConversationParticipants: [User]
    @State private var selectedUsers = Set<User>()
    @State private var conversationExists = false
    
    private var title: String {
        if conversationExists {
            return "Błąd"
        } else if selectedUsers.count > 1 {
            return "Nowa konwersacja grupowa"
        } else {
            return "Nowa konwersacja"
        }
    }
    
    private var header: String {
        if selectedUsers.isEmpty {
            return "Zaznacz przynajmniej 1 osobę"
        } else if conversationExists {
            return "Taka konwersacja już istnieje"
        } else {
            return "Zaznaczono: \(selectedUsers.count)"
        }
    }
    
    private var sortedUsers: [User] {
        viewModel.currentUser!.savedUsers.sorted(by: User.sortingPredicate)
    }
    
    private func checkSelection() {
        if viewModel.conversations.contains(where: { Set($0.participants) == selectedUsers.union([viewModel.currentUser!]) }) {
            conversationExists = true
        } else {
            conversationExists = false
        }
    }
    
    var body: some View {
        NavigationView {
            List(selection: $selectedUsers) {
                if viewModel.currentUser!.savedUsers.isEmpty {
                    Text("Aby móc tworzyć konwersacje, dodaj przynajmniej 1 osobę do listy zapisanych. Możesz też skorzystać z odpowiedniego przycisku w profilu użytkownika.")
                } else {
                    Section {
                        ForEach(sortedUsers, id: \.self) { user in
                            ListRow(images: [user.avatarImage], headline: "\(user.name) \(user.surname)", includesStarButton: false)
                        }
                    } header: {
                        Text(header)
                            .foregroundColor(conversationExists ? .red : Appearance.textColor)
                    } footer: {
                        Text("Na tej liście znajdują się wyłącznie osoby z Twojej listy zapisanych.")
                    }
                }
            }
            .environment(\.editMode, .constant(.active))
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.inline)
            .foregroundColor(Appearance.textColor)
            .onChange(of: selectedUsers.count) { _ in
                checkSelection()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Anuluj")
                            .foregroundColor(Appearance.textColor)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        newConversationParticipants = ([viewModel.currentUser!] + selectedUsers).sorted(by: User.sortingPredicate)
                        isShowingConversationView = true
                        dismiss()
                    } label: {
                        Text("Utwórz")
                            .foregroundColor(Appearance.textColor)
                            .bold()
                    }
                    .disabled(selectedUsers.isEmpty || conversationExists)
                }
            }
        }
    }
}

struct NewConversation_Previews: PreviewProvider {
    static var previews: some View {
        NewConversation(isShowingConversationView: .constant(false), newConversationParticipants: .constant([]))
            .environmentObject(ViewModel.sample)
    }
}
