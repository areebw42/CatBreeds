//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct ContentView: View {
    private let catBreeds = [
        CatBreed(name: "Persian",
                 imageName: "persian",
                 description: "The Persian is a long-haired variety of the domestic cat. They are known for their calm and gentle temperament, as well as their large, expressive eyes."
                ),
        CatBreed(name: "Maine Coon",
                 imageName: "maine-coon",
                 description: "The Maine Coon is one of the largest domestic cat breeds. They are known for their gentle and friendly nature, as well as their long, silky coat."
                ),
        CatBreed(name: "British Shorthair",
                 imageName: "british-shorthair",
                 description: "The British Shorthair is a medium-sized domestic cat breed. They are known for their calm and affectionate temperament, as well as their short, dense coat."
                ),
        CatBreed(name: "Ragdoll",
                 imageName: "ragdoll",
                 description: "The Ragdoll is a domestic cat breed known for its docile and laid-back personality. They often go limp when picked up, hence the name 'Ragdoll'."
                ),
        CatBreed(name: "Siamese",
                 imageName: "siamese",
                 description: "The Siamese is a slender and elegant domestic cat breed. They are known for their vocal and intelligent nature, as well as their striking blue eyes."
                )
    ]
    @Namespace private var animation
    @State private var selectedBreed: CatBreed? = nil
    @State private var showDescription: Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150), spacing: 16)], spacing: 16)
                {
                    ForEach(catBreeds) { breed in
                        VStack{
                            Image(breed.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipped()
                                .matchedGeometryEffect(id: breed.id, in: animation)
                                .cornerRadius(12)
                            Text(breed.name)
                                .font(.headline)
                                .padding(.top, 8)
                        }
                        .onTapGesture {
                            withAnimation(.spring()) {
                                selectedBreed = breed
                                showDescription.toggle()
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
            if showDescription, let selectedBreed = selectedBreed {
                CatBreedDetailView(
                    catBreed: selectedBreed,
                    animation: animation,
                    showDescription: $showDescription,
                    selectedBreed: $selectedBreed
                )
                //.transition(.asymmetric(insertion: .scale.animation(.spring()),
                                       // removal: .opacity.animation(.easeOut)))
            }
        }
    }
}

#Preview {
    ContentView()
}
