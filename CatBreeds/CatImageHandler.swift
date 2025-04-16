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

func removePunctuation(from string: String, delimiter: Character) -> String {
    var s = string
    if s.contains(delimiter) {
        s.removeSubrange(s.firstIndex(of: delimiter)!..<s.endIndex)
    }
    return s
}

func sanitizeInput(breed: String, addSuffix: Bool) -> String {
    var toReturn = breed.replacingOccurrences(of: " ", with: "_")
    toReturn = removePunctuation(from: toReturn, delimiter: "(")
    toReturn = removePunctuation(from: toReturn, delimiter: ",")
    toReturn = removePunctuation(from: toReturn, delimiter: "[")
    if toReturn.contains("Cymric"){
        toReturn = "Cymric"
    }
    if addSuffix {
        if !toReturn.lowercased().hasSuffix("_cat"){
            toReturn += "_cat"
        }
    }
    return toReturn
}

func fetchImageResponse(breedName : String) async -> ImageResponse{
    let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&titles=\(breedName)&prop=pageimages|pageterms&pithumbsize=300&redirects=1")!
    var received: ImageResponse = ImageResponse(query: Query(pages: []))

    do{
        let (data, _) = try await URLSession.shared.data(from: url)
        received = try JSONDecoder().decode(ImageResponse.self, from: data)
    }
    catch{}
    return received
}

func fetchImage(breed: String) async -> URL? {
    var breedName = sanitizeInput(breed: breed, addSuffix: true)
    var received = await fetchImageResponse(breedName: breedName)
    if received.query.pages.isEmpty {
        breedName = sanitizeInput(breed: breed, addSuffix: false)
        received = await fetchImageResponse(breedName: breedName)
    }
   
    let address = received.query.pages.first?.thumbnail.source ?? ""
    guard !address.isEmpty else {
        return nil
    }
    return URL(string: address) ?? URL(string: "")!
}
