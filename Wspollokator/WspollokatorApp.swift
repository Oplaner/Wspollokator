//
//  WspollokatorApp.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 25/10/2021.
//

import SwiftUI

@main
struct WspollokatorApp: App {
    @StateObject var viewModel = ViewModel.sample
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.colorScheme, .light) // TODO: 🤔
        }
    }
}
