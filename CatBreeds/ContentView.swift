//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

func loadCatBreeds() -> [CatBreed] {
    guard let url = Bundle.main.url(forResource: "breeds", withExtension: "json") else {
        fatalError("Failed to fetch data")
    }
    do{
        let data = try Data(contentsOf: url)
        let breeds = try JSONDecoder().decode([CatBreed].self, from: data)
        return breeds
    }

catch {
    fatalError("Failed to decode data: \(error)")
}
}

struct ContentView: View {
    @Namespace private var animation
    
    @State private var breeds: [CatBreed] = []
    @State private var displayedBreeds: [CatBreed] = []
    @State private var selectedBreed: CatBreed?
    @State private var showDetail: Bool = true
    
    private let pageSize = 20
    
    var body: some View {
        ZStack {
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16){
                    ForEach(displayedBreeds) { breed in
                        VStack{
                            Image(systemName: "pawprint.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipped()
                                .matchedGeometryEffect(id: breed.id, in: animation)
                                .cornerRadius(12)
                            
                            Text(breed.breed)
                            .font(.headline)
                            .padding(.top, 8)
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedBreed = breed
                                showDetail.toggle()
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
            .padding()
        }
        .onAppear() {
            breeds = loadCatBreeds()
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
    #Preview {
    ContentView()
}
