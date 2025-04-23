//
//  Strings.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/22/25.
//
import SwiftUI

struct CatBreedInfoView: View {
    let catBreed: CatBreed
    @State private var strings: Strings?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(strings?.country ?? "Loading...")
            Text(strings?.origin ?? "Loading...")
            Text(strings?.coat ?? "Loading...")
            Text(strings?.pattern ?? "Loading...")
        }
        .font(.body)
        .padding(.horizontal)
        .onAppear(perform: {
            strings = Strings(catBreed: catBreed)
        })

    }

}
