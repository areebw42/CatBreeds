//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct catCardView: View {
    let breed: CatBreed
    @State var img: String = ""
  var body: some View {
      VStack{
          
          AsyncImage(url: URL(string: img)){image in
              image
                  .image?.resizable().scaledToFill()
          }
              .task {img = await fetchImage(breed: breed.breed).query.pages.first?.thumbnail.source ?? "pawprint.fill"}
          
          Text(breed.breed)
          .font(.headline)
          .padding(.top, 8)
      }
    }
 }

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
        Grid(){
            ForEach(displayedBreeds) { breed in
                catCardView(breed: breed).onTapGesture {
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
  
