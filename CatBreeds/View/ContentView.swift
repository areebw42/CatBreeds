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
                       }
                     
                     else {
                           ProgressView()
                       }
                 }
                 .clipShape(RoundedRectangle(cornerRadius: 15))
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
    private let standardColumns = [GridItem(.flexible()), GridItem(.flexible())]
    
    struct BreedsResponse: Decodable {
        let data: [CatBreed]
    }

    //The view that displays the cards in the grid
    private var catGridView: some View {
        ScrollView{
            //This structure paginates the data in both directions, in practice it loads everything almost instantly, if there were thousands of elements returned then it would diplay as many as possible while loading others.
            LazyVStack{
                ForEach(chunkedBreeds, id: \.self){ page in
                    LazyVGrid(columns: standardColumns, spacing: standardSpacing) {
                        ForEach(page) { item in
                            catCardView(breed: item)
                                .onTapGesture {selectedBreed = item; showDetail = true}
                        }
                    }
                }
            }
        }
        .task {
            breeds = await fetchBreeds()?.data ?? []
            if breeds == [] {
                exit(1)
            }
            chunkedBreeds = chunkBreeds(breeds)
            if chunkedBreeds == [] {
                exit(1)
            }
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
       

    }
    
    private func chunkBreeds(_ breeds: [CatBreed]) -> [[CatBreed]] {
        return stride(from: 0, to: breeds.count, by: pageSize).map {
            Array(breeds[$0..<min($0 + pageSize, breeds.count)])
        }
    }

}
