//
//  FilterViewOption.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import Foundation

enum FilterOption: Int, CaseIterable {
    case animals
    case smoking
    
    var title: String {
        switch self {
        case .animals: return "Zwierzęta domowe"
        case .smoking: return "Osoby palące"
        }
    }
    
    var icon: String {
        switch self {
        case .animals: return "🐶"
        case .smoking: return "🚬"
        }
    }
}

enum FilterAttitude: String, CaseIterable {
    case negative = "🚫"
    case neutral = "⚪️"
    case positive = "✅"
}
