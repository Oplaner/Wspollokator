//
//  RatingList.swift
//  Wspollokator
//
//  Created by Kamil Chmielewski on 19.12.21.
//

import SwiftUI

struct RatingList: View {
    @EnvironmentObject var viewModel: ViewModel
    
    var relevantUser: User
    @State private var isShowingNewRatingView = false
    
    private var sortedRatings: [Rating] {
        relevantUser.ratings!.sorted { $0.timeAdded > $1.timeAdded }
    }
    
    var body: some View {
        List(sortedRatings) { rating in
            RatingView(rating: rating)
                .padding(.vertical, 10)
        }
        .navigationTitle(relevantUser == viewModel.currentUser! ? "Opinie o mnie" : "Opinie")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                if relevantUser != viewModel.currentUser! {
                    Button {
                        isShowingNewRatingView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingNewRatingView) {
            NewRating(relevantUser: relevantUser)
        }
    }
}

struct RatingList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            RatingList(relevantUser: ViewModel.sampleUsers[0])
                .environmentObject(ViewModel.sample)
        }
    }
}
