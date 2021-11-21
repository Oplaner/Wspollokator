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
    
    static func configureAppearance() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(backgroundColor)
        navigationBarAppearance.titleTextAttributes = [.foregroundColor: UIColor(textColor)]
        navigationBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor(textColor)]
        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
        UINavigationBar.appearance().tintColor = UIColor(fillColor)
        
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(backgroundColor)
        let tabBarItemAppearance = UITabBarItemAppearance()
        tabBarItemAppearance.normal.iconColor = UIColor(alternateColor)
        tabBarItemAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor(alternateColor)]
        tabBarItemAppearance.selected.iconColor = UIColor(textColor)
        tabBarItemAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor(textColor)]
        tabBarAppearance.inlineLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.stackedLayoutAppearance = tabBarItemAppearance
        tabBarAppearance.compactInlineLayoutAppearance = tabBarItemAppearance
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
    }
}
