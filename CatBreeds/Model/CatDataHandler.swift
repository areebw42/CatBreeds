//
//  CatDataHandler.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/10/25.
//

import Foundation

/* The following are decodable structs matching the JSON response from the API*/



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
    let data: [CatFact]
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

func fetchData(_urlString: String) async -> Data? {
    guard let url = URL(string: _urlString) else { return nil }
    //Get the response from the URL, we only need the data portion of the tuple
    //Fix cache bug by using ephemeral config with nil cache
    let config = URLSessionConfiguration.ephemeral
    config.urlCache = nil
    let session = URLSession(configuration: config)
    do {
        let data = try await session.data(from: url)
        return data.0
    } catch {
        print("Error fetching data \(error)")
        return nil
    }
}

func fetchBreeds() async -> BreedResponse? {
    var received: BreedResponse? = nil
    guard let data = await fetchData(_urlString: breedsUrl) else { return nil }
    let decoder = JSONDecoder()
    //Set the decoding strategy in order to convert from the JSON response's snake case to camel case
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
        received = try decoder.decode(BreedResponse.self, from: data)
    } catch {
        print("Error decoding data \(error)")
    }

    return received
}

func fetchFacts() async -> FactResponse? {
    var received: FactResponse? = nil
    guard let data = await fetchData(_urlString: factsUrl) else { return nil }
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    do {
        received = try decoder.decode(FactResponse.self, from: data)
    }
    catch {
        print("Error decoding data \(error)")
    }
    
    return received
}
