//
//  ContentView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

    struct ContentView: View {
        
        struct BreedsResponse: Decodable {
            let data: [CatBreed]
        }
        
        
        
        var body: some View {
            
            NavigationStack {
                Text(selectDialogue)
                    .font(.title)
                    .padding(.vertical)
                NavigationLink(breedsTitle) {
                    CatBreedsView()
                        .navigationBarTitle(breedsTitle)
                }
                .font(.largeTitle)
                .padding(.vertical)
                NavigationLink(factsTitle) {
                    CatFactsView()
                        .navigationBarTitle(factsTitle)
                }
                .font(.largeTitle)
                .padding(.vertical)
            }
        }
        //Initial fetch of breeds
    }


