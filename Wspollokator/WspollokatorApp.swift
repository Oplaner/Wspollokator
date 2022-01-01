//
//  WspollokatorApp.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 25/10/2021.
//

import SwiftUI

@main struct WspollokatorApp: App {
    @StateObject private var viewModel = ViewModel.sample
    
    init() {
        UIView.appearance().tintColor = UIColor(named: "AccentColor")!
        Networking.makeSession()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
