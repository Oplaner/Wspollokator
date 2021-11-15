//
//  DescriptionAlert.swift
//  Wspollokator
//
//  Created by Piotr Czajkowski on 13/11/2021.
//

import SwiftUI

struct DescriptionAlert: View {
    private let screenSize = UIScreen.main.bounds
    
    @Binding var isShown: Bool
    @Binding var desc: String
    var onDone: () -> Void = {}
    var onCancel: () -> Void = {}
    
    var body: some View {
        VStack {
            Text("Mój opis")
            TextEditor(text: $desc)
            Spacer()
            HStack(spacing: 40) {
                Button {
                    self.onDone()
                } label : {
                    Text("Zmień opis")
                }
                Button {
                    self.isShown = false
                    self.onCancel()
                } label : {
                    Text("Anuluj")
                }
            }
        }
        .padding()
        .frame(width: screenSize.width * 0.85, height: screenSize.height * 0.2)
        .background(Color(#colorLiteral(red: 0.9268686175, green: 0.9416290522, blue: 0.9456014037, alpha: 1)))
                .clipShape(RoundedRectangle(cornerRadius: 20.0, style: .continuous))
                .offset(y: isShown ? 0 : screenSize.height)
//                .animation(.spring())
                .shadow(color: Color(#colorLiteral(red: 0.8596749902, green: 0.854565084, blue: 0.8636032343, alpha: 1)), radius: 6, x: -9, y: -9)
    }
}

struct DescriptionAlert_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionAlert(isShown: .constant(true), desc: .constant("ZARAZ PÓJDĘ"))
    }
}
