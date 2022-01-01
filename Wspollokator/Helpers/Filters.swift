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
    
    static func mapFrom(serverValue value: String) -> FilterAttitude {
        switch value {
        case "A":
            return .positive
        case "N":
            return .negative
        default:
            return .neutral
        }
    }
    
    func mapToServerValue() -> String {
        switch self {
        case .negative:
            return "N"
        case .neutral:
            return "I"
        case .positive:
            return "A"
        }
    }
}
