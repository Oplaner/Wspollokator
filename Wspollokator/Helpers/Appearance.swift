//
//  Appearance.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 29/10/2021.
//

import SwiftUI

/*
 
 Appearance values are stored as computed values in order to allow
 for multiple trait collection conformance, for example dark mode.
 
 */

struct Appearance {
    static var fillColor: Color {
        return Color(red: 32 / 255, green: 104 / 255, blue: 22 / 255)
    }
    
    static var backgroundColor: Color {
        return Color(red: 93 / 255, green: 231 / 255, blue: 81 / 255)
    }
    
    static var buttonColor: Color {
        return Color(red: 66 / 255, green: 217 / 255, blue: 47 / 255)
    }
    
    static var textColor: Color {
        return Color(red: 66 / 255, green: 108 / 255, blue: 58 / 255)
    }
    
    static var alternateColor: Color {
        return Color(red: 51 / 255, green: 171 / 255, blue: 38 / 255)
    }
    
    static func setNavigationAppearance() {
        let navigationAppearance = UINavigationBarAppearance()
        navigationAppearance.configureWithOpaqueBackground()
        navigationAppearance.backgroundColor = UIColor(backgroundColor)
        navigationAppearance.titleTextAttributes = [.foregroundColor: UIColor(textColor)]
        navigationAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(textColor)]
        
        UINavigationBar.appearance().standardAppearance = navigationAppearance
        UINavigationBar.appearance().compactAppearance = navigationAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationAppearance
        UINavigationBar.appearance().tintColor = UIColor(fillColor)
    }
}
