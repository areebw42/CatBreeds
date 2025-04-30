//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI


struct catCardView: View {
    let breed: CatBreed
    @State var image: URL? = nil
    var body: some View {
        VStack {

            if image != nil {
             if let imageURL = image {
                 AsyncImage(url: imageURL) { phase in
                       if let image = phase.image {
                           image.resizable().scaledToFit()
                       } else if phase.error != nil {
                           AsyncImage(url: imageURL) { phase in
                               if let image = phase.image {
                                   image.resizable().scaledToFit()
                               }
                           }
                       }
                     
                     else {
                           ProgressView()
                       }
                 }
                }
            } else {
                Text("Image Unavailable")
                    .foregroundColor(.red)
                    .frame(width: 100)
                    .font(.headline)
                    .scaledToFit()
            }

            Text(breed.breed)
                .frame(width: 100)
                .font(.headline)
                .scaledToFit()
        }.task {
            print("beginning image fetch")
            image = await fetchImage(breed: breed.breed)
            print("image fetched")
        }
    }
}

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
                catCardView(breed: breed)
                .scaledToFit()
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedBreed = breed
                        showDetail = true
                    }
                }
                .scaledToFit()
                .onScrollVisibilityChange { _ in

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
