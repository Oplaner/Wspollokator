//
//  UserDefaultsService.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 05.01.22.
//

import Foundation

class UserDefaultsService {
    private static let targetDistanceKey = "searchTargetDistance"
    
    static func saveSearchSettings(targetDistance: Double, preferences: [FilterOption: FilterAttitude]) {
        UserDefaults.standard.set(targetDistance, forKey: targetDistanceKey)
        
        for (option, attitude) in preferences {
            UserDefaults.standard.set(attitude.mapToServerValue(), forKey: preferencesKey(for: option))
        }
    }
    
    static func readSearchSettings() -> (targetDistance: Double, preferences: [FilterOption: FilterAttitude]) {
        let targetDistance = UserDefaults.standard.object(forKey: targetDistanceKey) as? Double ?? ViewModel.defaultTargetDistance
        var preferences: [FilterOption: FilterAttitude] = [:]
        
        for option in FilterOption.allCases {
            if let attitude = UserDefaults.standard.string(forKey: preferencesKey(for: option)) {
                preferences[option] = FilterAttitude.mapFrom(serverValue: attitude)
            }
        }
        
        if preferences.count < FilterOption.allCases.count {
            preferences = ViewModel.defaultPreferences
            
            if preferences.count > 0 {
                clearSearchSettings()
            }
        }
        
        return (targetDistance, preferences)
    }
    
    static func clearSearchSettings() {
        UserDefaults.standard.removeObject(forKey: targetDistanceKey)
        
        for option in FilterOption.allCases {
            UserDefaults.standard.removeObject(forKey: preferencesKey(for: option))
        }
    }
    
    private static func preferencesKey(for option: FilterOption) -> String {
        "searchPreferences\(option.rawValue.capitalized)"
    }
}
