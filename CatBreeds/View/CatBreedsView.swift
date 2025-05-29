<<<<<<< HEAD
//
//  CatBreedsView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 5/28/25.
//

import SwiftUI

=======
>>>>>>> 596dee0f400820b2a1b9bdb18c1b2e1809193985
struct CatBreedsView: View {

    @Namespace private var animation

    @State private var breeds: [CatBreed] = []
    @State private var chunkedBreeds: [[CatBreed]] = []
    @State private var displayedBreeds: [CatBreed] = []
    @State private var selectedBreed: CatBreed?
    @State private var showDetail: Bool = false

    @State private var alertMessage: String?

    private var loadedOnce = false

    private let pageSize = 20
    private let standardWidth: CGFloat = 120
    private let standardCornerRadius: CGFloat = 12
    private let standardSpacing: CGFloat = 16
    private let standardColumns = [
        GridItem(.flexible()), GridItem(.flexible()),
    ]

    //The view that displays the cards in the grid
    private var catGridView: some View {
        
        ScrollView {
            //This structure paginates the data in both directions, in practice it loads everything almost instantly, if there were thousands of elements returned then it would diplay as many as possible while loading others.
            LazyVStack {
                ForEach(chunkedBreeds, id: \.self) { page in
                    LazyVGrid(
                        columns: standardColumns,
                        spacing: standardSpacing
                    ) {
                        ForEach(page) { item in
<<<<<<< HEAD
                            CatCardView(
=======
                            catCardView(
>>>>>>> 596dee0f400820b2a1b9bdb18c1b2e1809193985
                                breed: item,
                                standardWidth: standardWidth
                            )
                            .onTapGesture {
                                selectedBreed = item
                                showDetail = true
                            }
                            
                        }
                    }
                }
            }
            .task {
                breeds = await fetchBreeds()?.data ?? []
                chunkedBreeds = chunkBreeds(breeds)
            }
            
        }
    }
    var body: some View {
        ZStack {
      
                catGridView
          
            .padding()

            if showDetail, let selectedBreed = selectedBreed {
                CatBreedDetailView(
                    catBreed: selectedBreed,
                    animation: animation,
                    showDetail: $showDetail,
                    selectedCat: $selectedBreed
                )
                .transition(
                    .asymmetric(
                        insertion: .scale.animation(.spring()),
                        removal: .move(edge: .bottom)
                    )
                )
            }

        }
    }

    private func chunkBreeds(_ breeds: [CatBreed]) -> [[CatBreed]] {
        return stride(from: 0, to: breeds.count, by: pageSize).map {
            Array(breeds[$0..<min($0 + pageSize, breeds.count)])
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 596dee0f400820b2a1b9bdb18c1b2e1809193985
