//
//  CatBreed.swift
//  catbreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct CatBreed: Identifiable, Equatable {
    let id = UUID()
    let name : String
    let imageName : String
    let description : String
}
