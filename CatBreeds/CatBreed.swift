//
//  CatBreed.swift
//  catbreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct CatBreed: Identifiable, Equatable, Decodable {
    var id = UUID()
    var image : URL? = nil
    var breed : String
    var country : String
    var origin : String
    var coat : String
    var pattern : String
    
    private enum CodingKeys : String, CodingKey {
        case breed
        case country
        case origin
        case coat
        case pattern
    }
}
