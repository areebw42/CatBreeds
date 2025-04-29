//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct ContentView: View {
    @Namespace private var animation

    @State private var breeds: [CatBreed] = []
    @State private var displayedBreeds: [CatBreed] = []
    @State private var selectedBreed: CatBreed?
    @State private var showDetail: Bool = false

    @State private var alertMessage: String?

    private var loadedOnce = false

    private let pageSize = 20
    private let standardWidth: CGFloat = 120
    private let standardCornerRadius: CGFloat = 12
    private let standardSpacing: CGFloat = 16

    struct BreedsResponse: Decodable {
        let data: [CatBreed]
    }

    //The view that displays the cards in the grid
    private var catGridView: some View {
        LazyVGrid(
            columns: [
                GridItem(.adaptive(minimum: 150), spacing: standardSpacing)
            ],
            spacing: standardSpacing
        ) {
            ForEach(displayedBreeds) { breed in
                //The individual cards are displayed by this VStack.
                VStack {
                    Image(systemName: "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: standardWidth, height: standardWidth)
                        .clipped()
                        .matchedGeometryEffect(id: breed.id, in: animation)
                        .cornerRadius(standardCornerRadius)

                    Text(breed.breed)
                        .frame(width: standardWidth)
                        .font(.headline)
                        .scaledToFill()
                }
                .scaledToFit()
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedBreed = breed
                        showDetail = true
                    }
                }
                //We handle pagination here
                .onAppear {
                    if breed == displayedBreeds.last {
                        loadNextPage()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(standardCornerRadius)
            .shadow(radius: 3)
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                catGridView
            }
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
        //Initial fetch of breeds
        .task {
            breeds = await fetchBreeds()?.data ?? []
            displayedBreeds = Array(breeds.prefix(pageSize))
        }

    }
    //Function to actually dislay next page.
    private func loadNextPage() {
        let currentCount = displayedBreeds.count
        guard currentCount < breeds.count else { return }
        let nextCount = min(currentCount + pageSize, breeds.count)
        displayedBreeds.append(contentsOf: breeds[currentCount..<nextCount])
    }

}
