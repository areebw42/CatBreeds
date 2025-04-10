//
//  CatImageHandler.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/10/25.
//

import Foundation

struct Thumbnail: Decodable {
    let source: String
}

struct Page: Decodable {
    let thumbnail: Thumbnail
}

struct Query: Decodable {
    let pages: [Page]
}

struct ImageResponse: Decodable {
    let query: Query
}

func sanitizeInput(breed: String, addSuffix: Bool) -> String {
    var toReturn = breed.replacingOccurrences(of: " ", with: "_")
    if addSuffix {
        if !toReturn.lowercased().hasSuffix("_cat"){
            toReturn += "_cat"
        }
    }
    return toReturn
}

func fetchImage(breed: String) async -> ImageResponse {
    var breedName = sanitizeInput(breed: breed, addSuffix: true)
    var url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&titles=\(breedName)&prop=pageimages|pageterms&pithumbsize=300&redirects=1")!
    var received: ImageResponse = ImageResponse(query: Query(pages: []))
    print ("Fetching image for \(breed) as \(breedName)")
    do{
        let (data, _) = try await URLSession.shared.data(from: url)
        received = try JSONDecoder().decode(ImageResponse.self, from: data)
    }
    catch{}
    if received.query.pages.isEmpty {
        breedName = sanitizeInput(breed: breed, addSuffix: false)
        print("Using fallback for \(breed) as \(breedName)")
        url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&titles=\(breedName)&prop=pageimages|pageterms&pithumbsize=300&redirects=1")!
        do{ let (data, _) = try await URLSession.shared.data(from: url)
            received = try JSONDecoder().decode(ImageResponse.self, from: data)}
        catch{}
    }
    return received
}
