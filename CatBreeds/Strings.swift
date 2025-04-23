//
//  Strings.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/22/25.
//

struct Strings {
    let catBreed: CatBreed
    let country: String
    let origin: String
    let coat: String
    let pattern: String

    init(catBreed: CatBreed) {
        self.catBreed = catBreed
        country = "Country: \(catBreed.country)"
        origin = "Origin: \(catBreed.origin)"
        coat = "Coat: \(catBreed.coat)"
        pattern = "Pattern: \(catBreed.pattern)"
    }

}
