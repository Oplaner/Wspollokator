//
//  FilterViewOption.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 03/11/2021.
//

import Foundation

enum FilterRowOptions: Int, CaseIterable {
    case animal
    case smoking
    
    var title: String {
        switch self {
        case .animal: return "Zwierzęta domowe"
        case .smoking: return "Osoby palące"
        }
    }
    
    var icon: String {
        switch self {
        case .animal: return "🐶"
        case .smoking: return "🚬"
        }
    }
}
