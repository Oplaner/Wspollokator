//
//  WspollokatorApp.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 25/10/2021.
//

import SwiftUI

@main
struct WspollokatorApp: App {
    let viewModel = ViewModel.sample
    
    init() {
        Appearance.setNavigationAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
