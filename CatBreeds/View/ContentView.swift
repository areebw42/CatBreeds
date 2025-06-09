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
            NavigationView {
                List {
                    NavigationLink(destination: CatBreedsView()) {
                        Text("Breeds")
                    }
                    NavigationLink(destination: CatFactsView()) {
                        Text("Facts")
                    }
                    
                }
                .navigationTitle(Text("Main Menu"))
            }
            }
        }
        //Initial fetch of breeds

