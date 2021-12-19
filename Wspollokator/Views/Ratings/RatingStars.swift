//
//  RatingStars.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 18.12.21.
//

import SwiftUI

struct RatingStars: View {
    let totalStars = 5
    
    @Binding var rating: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(1 ..< totalStars + 1) { i in
                Image(systemName: "star.fill")
                    .foregroundColor(i <= rating ? .yellow : .gray)
                    .frame(width: 44, height: 44, alignment: .center)
                    .font(.system(size: 22))
                    .onTapGesture {
                        rating = i
                    }
            }
        }
    }
}

struct RatingStars_Previews: PreviewProvider {
    static var previews: some View {
        RatingStars(rating: .constant(3))
            .previewLayout(.fixed(width: 300, height: 100))
    }
}
