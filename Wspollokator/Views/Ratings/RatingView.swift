//
//  RatingView.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 19.12.21.
//

import SwiftUI

struct RatingView: View {
    var rating: Rating
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Avatar(image: rating.author.avatarImage, size: 40)
                Text("\(rating.author.name) \(rating.author.surname)")
                    .font(.headline)
            }
            
            RatingStars(score: .constant(rating.score), isInteractive: false)
            Text(rating.comment)
            Text(rating.formattedTimeAdded)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct RatingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RatingView(rating: ViewModel.sampleUsers[0].ratings![1])
            RatingView(rating: ViewModel.sampleUsers[0].ratings![2])
        }
        .previewLayout(.sizeThatFits)
    }
}
