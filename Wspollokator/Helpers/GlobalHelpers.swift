//
//  GlobalHelpers.swift
//  Wspollokator
//
//  Created by Szymon Tamborski on 13/11/2021.
//

import Foundation
import SwiftUI

// Custom corner rounding by custom rendered path by UIBezierPath: .topLeft, .bottomRight etc
extension View {
    func customCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
