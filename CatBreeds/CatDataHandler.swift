//
//  CatDataHandler.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/10/25.
//

import Foundation

struct Fact: Decodable {
    let fact: String
    let length: Int
}

struct Link: Decodable {
    let url: String?
    let label: String?
    let active: Bool
}

struct BreedResponse: Decodable {
    let currentPage: Int
    let data: [CatBreed]
    let firstPageUrl: String
    let from: Int
    let lastPage: Int
    let lastPageUrl: String
    let links: [Link]
    let nextPageUrl: String?
    let path: String
    let perPage: Int
    let prevPageUrl: String?
    let to: Int
    let total: Int
}

struct FactResponse: Decodable {
    let currentPage: Int
    let data: [Fact]
    let firstPageUrl: String
    let from: Int
    let lastPage: Int
    let lastPageUrl: String
    let links: [Link]
    let nextPageUrl: String?
    let path: String
    let perPage: Int
    let prevPageUrl: String?
    let to: Int
    let total: Int
}
func fetchBreeds() async -> BreedResponse? {
    let url = URL(string: "https://catfact.ninja/breeds?limit=1000")!
    var received: BreedResponse? = nil
    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        received = try decoder.decode(BreedResponse.self, from: data)
    } catch {

    }
    return received
}
