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
        HStack() {
            VStack() {
                
                if catBreed.image != nil {
                    AsyncImage(url: catBreed.image){image in
                        image
                            .image?.resizable().scaledToFit()
                    }
                }
                    
                
                Text(catBreed.breed)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .scaledToFit()
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Country: \(catBreed.country)").scaledToFit()
                    Text("Origin: \(catBreed.origin)").scaledToFit()
                    Text("Coat: \(catBreed.coat)").scaledToFit()
                    Text("Pattern: \(catBreed.pattern)").scaledToFit()
                }
                .font(.body)
                .padding(.horizontal)
                
              
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
                    .frame(width: 30, height: 30)
                    
                
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Color(.systemBackground)
                .ignoresSafeArea()
            )
        
    }
}
