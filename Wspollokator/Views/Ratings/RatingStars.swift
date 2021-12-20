//
//  RatingStars.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 18.12.21.
//

import SwiftUI

struct RatingStars: View {
    let totalStars = 5
    
    @Binding var score: Int
    var isInteractive: Bool
    
    private var size: CGFloat {
        if isInteractive {
            return 44
        } else {
            return 32
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1 ..< totalStars + 1) { i in
                Image(systemName: "star.fill")
                    .foregroundColor(i <= score ? .yellow : Color(uiColor: .tertiaryLabel))
                    .frame(width: size, height: size, alignment: .center)
                    .font(.system(size: size / 2))
                    .onTapGesture {
                        if isInteractive {
                            score = i
                        }
                    }
            }
        }
    }
}

struct RatingStars_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RatingStars(score: .constant(3), isInteractive: true)
            RatingStars(score: .constant(4), isInteractive: false)
        }
        .previewLayout(.fixed(width: 300, height: 100))
    }
}
