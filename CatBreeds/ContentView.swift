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
    @State private var selectedBreed: CatBreed?
    @State private var showDetail: Bool = true
    
    var body: some View {
        ZStack {
            ScrollView{
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16){
                    ForEach(breeds) { breed in
                        VStack{
                            Image(systemName: "chevron.right")
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
}
    #Preview {
    ContentView()
}
