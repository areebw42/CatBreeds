//
//  Strings.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/22/25.
//
import SwiftUI

struct CatBreedInfoView: View {
    let catBreed: CatBreed

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            //Compute strings based on static labels and breed info
            Text("\(country)\(catBreed.breed)")
            Text("\(origin)\(catBreed.origin)")
            Text("\(coat)\(catBreed.coat)")
            Text("\(pattern)\(catBreed.pattern)")
        }
        .font(.body)
        .padding(.horizontal)

    }

}
