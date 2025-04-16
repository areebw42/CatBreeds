//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct catCardView: View {
    let breed : CatBreed
    @State var image : URL? = nil
  var body: some View {
      VStack{
          
          if image != nil {
              AsyncImage(url: image){ phase in
                  if let image = phase.image {
                      image.resizable().scaledToFit()
                  }
                  else if phase.error != nil {
                      let description = phase.error?.localizedDescription ?? "Unknown Error"
                      Text(description)
                  }
                  else{
                      ProgressView()
                  }
              }
          }
          
          else{
              Text("Image Unavailable")
                  .foregroundColor(.red).scaledToFit()
          }
              
          
          Text(breed.breed)
          .font(.headline)
          .padding(.top, 8)
      }.task {
          print ("beginning image fetch")
          image = await fetchImage(breed: breed.breed)
          print ("image fetched")
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
                .scaledToFit()
                .onScrollVisibilityChange(){_ in 
                    if breed == displayedBreeds.last{
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
            breeds = await fetchBreeds()
            loadNextPage()
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
    private func loadNextPage()  {
       let currentCount = displayedBreeds.count
        guard currentCount < breeds.count else { return }
        let nextCount = min(currentCount + pageSize, breeds.count)
        displayedBreeds.append(contentsOf: breeds[currentCount..<nextCount])
      
        
    }
    
  
 
    
}
  
