//
//  CatDataHandler.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/10/25.
//

import Foundation

struct Fact: Decodable {
    let fact : String
    let length : Int
}

struct Link : Decodable {
    let url : String?
    let label : String?
    let active : Bool
}

struct BreedResponse: Decodable {
    let current_page : Int
    let data : [CatBreed]
    let first_page_url : String
    let from : Int
    let last_page : Int
    let last_page_url : String
    let links : [Link]
    let next_page_url : String?
    let path : String
    let per_page : Int
    let prev_page_url : String?
    let to : Int
    let total : Int
}

struct FactResponse: Decodable {
    let current_page : Int
    let data : [Fact]
    let first_page_url : String
    let from : Int
    let last_page : Int
    let last_page_url : String
    let links : [Link]
    let next_page_url : String?
    let path : String
    let per_page : Int
    let prev_page_url : String?
    let to : Int
    let total : Int
}
func fetchBreeds() async -> [CatBreed] {
    let url = URL(string: "https://catfact.ninja/breeds?limit=1000")!
    var received: BreedResponse? = nil
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        received = try JSONDecoder().decode(BreedResponse.self, from: data)
    }
    catch {
    
    }
    
    let breeds = received?.data
    
    return breeds ?? []
}


