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
    case third
    case fourth
    
    var title: String {
        switch self {
        case .animal: return "Zwierzęta domowe"
        case .smoking: return "Osoby palące"
        case .third: return "third"
        case .fourth: return "fourth"
        }
    }
    
    var imageName: String {
        switch self {
        case .animal: return "hare.fill"
        case .smoking: return "2.square.fill"
        case .third: return "3.square.fill"
        case .fourth: return "4.square.fill"
        }
    }
}
