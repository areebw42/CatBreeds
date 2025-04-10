//
//  CatBreedDetailView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct CatBreedDetailView: View {
    let catBreed: CatBreed
    var animation: Namespace.ID
    @State var img: String = ""
    @Binding var showDetail: Bool
    @Binding var selectedCat: CatBreed?
    
    var body: some View {
        ZStack(alignment :.topTrailing) {
            VStack(spacing: 20) {
                AsyncImage(url: URL(string: img)){image in
                    image
                        .image?.resizable().scaledToFill()
                }
                    .task {img = await fetchImage(breed: catBreed.breed).query.pages.first?.thumbnail.source ?? "pawprint.fill"}
                
                Text(catBreed.breed)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Country: \(catBreed.country)")
                    Text("Origin: \(catBreed.origin)")
                    Text("Coat: \(catBreed.coat)")
                    Text("Pattern: \(catBreed.pattern)")
                }
                .font(.body)
                .padding(.horizontal)
                
                Spacer()
            }
            
            Button(action: {
                withAnimation(.spring()) {
                    showDetail = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        selectedCat = nil
                    }
                }
            }, label: {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .padding()
                
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
            )
        
    }
}
