//
//  WspollokatorApp.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 25/10/2021.
//

import SwiftUI

@main struct WspollokatorApp: App {
    @StateObject var viewModel = ViewModel.sample
    
    init() {
        UIView.appearance().tintColor = UIColor(named: "AccentColor")!
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
