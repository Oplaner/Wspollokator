//
//  User.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 30/10/2021.
//

import SwiftUI

struct User: Identifiable {
    let id = UUID()
    
    var avatarImage: Image?
    var name: String
    var surname: String
    var distance: Float // Temporary!
    
    // TODO: Complete the model with user's preferences and description. Add distance calculation.
}
