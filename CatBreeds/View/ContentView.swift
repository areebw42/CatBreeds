//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct catCardView: View {
    let breed: CatBreed
    let standardWidth: CGFloat
    @State var image: URL? = nil

    var body: some View {
        LazyVStack {

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
                        } else {
                            ProgressView()
                        }
                    }
                }
            } else {
                Text("Image Unavailable")
                    .foregroundColor(.red)
                    .frame(width: standardWidth)
                    .font(.headline)
                    .scaledToFit()
            }

            Text(breed.breed)
                .frame(width: standardWidth)
                .font(.headline)
                .scaledToFit()
        }.task {
            image = await fetchImage(breed: breed.breed)
        }
    }
}

struct CatFactsView: View {

    @State private var facts: [CatFact] = []
    @State private var chunkedFacts: [[CatFact]] = []

    private let pageSize = 20
    private let standardWidth: CGFloat = 120
    private let standardCornerRadius: CGFloat = 12
    private let standardSpacing: CGFloat = 16
    private let standardColumns = [
        GridItem(.flexible()), GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(chunkedFacts, id: \.self) { chunk in
                    LazyVStack {
                        ForEach(chunk, id: \.self) { fact in
                            Text(fact.fact)
                                .font(.caption)
                                .padding(.vertical)

                        }
                    }

                }
            }
        }
        .task {
            facts = await fetchFacts()?.data ?? []
            chunkedFacts = chunkFacts(facts)
        }
    }

    private func chunkFacts(_ facts: [CatFact]) -> [[CatFact]] {
        return stride(from: 0, to: facts.count, by: pageSize).map {
            Array(facts[$0..<min($0 + pageSize, facts.count)])
        }

    }

}

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
                            catCardView(
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
}
    

    struct ContentView: View {
        
        struct BreedsResponse: Decodable {
            let data: [CatBreed]
        }
        
        
        
        var body: some View {
            
            NavigationStack {
                Text("Select Breeds or facts: ")
                    .font(.title)
                    .padding(.vertical)
                NavigationLink("Breeds") {
                    CatBreedsView()
                        .navigationBarTitle("Cat Breeds")
                }
                .font(.largeTitle)
                .padding(.vertical)
                NavigationLink("Facts") {
                    CatFactsView()
                        .navigationBarTitle("Cat Facts")
                }
                .font(.largeTitle)
                .padding(.vertical)
            }
        }
        //Initial fetch of breeds
    }


