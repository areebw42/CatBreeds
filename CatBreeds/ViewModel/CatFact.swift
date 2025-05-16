//
//  CatFact.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 5/7/25.
//

import SwiftUI

struct CatFact: Identifiable, Equatable, Decodable, Hashable {
    var id = UUID()
    let fact: String
    let length: Int

    private enum CodingKeys: String, CodingKey {
        case fact
        case length
    }
}
