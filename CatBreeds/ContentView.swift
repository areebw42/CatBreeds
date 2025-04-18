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
    
    @State private var alertMessage : String?
    
    private let pageSize = 20
    
    struct BreedsResponse : Decodable {
        let data : [CatBreed]
    }
    
    private var catGridView: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16){
            ForEach(displayedBreeds) { breed in
                VStack{
                    Image(systemName: "pawprint.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipped()
                        .matchedGeometryEffect(id: breed.id, in: animation)
                        .cornerRadius(12)
                    
                    Text(breed.breed)
                    .frame(width: 100, height: .infinity)
                    .font(.headline)
                    .scaledToFill()
                }
                .scaledToFit()
                .onTapGesture {
                    withAnimation(.spring()) {
                        selectedBreed = breed
                        showDetail=true
                    }
                }
                .onAppear(){
                    if breed == displayedBreeds.last {
                        loadNextPage()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
            .shadow(radius: 3)
        }
    }
    
    var body: some View {
        ZStack {
            ScrollView{
                catGridView
            }
            .padding()
        }
        .task {
            breeds = await fetchBreeds().data
            displayedBreeds = Array(breeds.prefix(pageSize))
        }
        
        if showDetail, let selectedBreed = selectedBreed {
            CatBreedDetailView(
                catBreed: selectedBreed,
                animation: animation,
                showDetail: $showDetail,
                selectedCat: $selectedBreed
            )
            .transition(.asymmetric(insertion: .scale.animation(.spring()), removal: .opacity.animation(.easeOut)))
        }
    }
    private func loadNextPage() {
        let currentCount = displayedBreeds.count
        guard currentCount < breeds.count else { return }
        let nextCount = min(currentCount + pageSize, breeds.count)
        displayedBreeds.append(contentsOf: breeds[currentCount..<nextCount])
    }
    
}
  
