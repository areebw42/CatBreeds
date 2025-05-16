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
    if toReturn.contains("Persian") && toReturn.contains("Traditional") {
        toReturn = "Traditional_Persian"
    }
    toReturn = toReturn.removeChar(delimiters: "(,[")
    if toReturn.contains("Cymric") {
        toReturn = "Cymric"
    } else if toReturn.contains("Cheetoh") {
        toReturn = "Bengal"
    } else if toReturn.contains("Sam_Sawet") {
        toReturn = "Thai"
    } else if addSuffix {
        if !toReturn.lowercased().hasSuffix("_cat") {
            toReturn += "_cat"
        }
    }
    return toReturn
}

func fetchImageResponse(breedName: String) async -> ImageResponse? {
    guard
        let url = URL(
            string:
                "https://en.wikipedia.org/w/api.php?action=query&format=json&formatversion=2&titles=\(breedName)&prop=pageimages|pageterms&pithumbsize=300&redirects=1"
        )
    else { return nil }
    var received: ImageResponse = ImageResponse(query: Query(pages: []))

    do {
        let (data, _) = try await URLSession.shared.data(from: url)
        received = try JSONDecoder().decode(ImageResponse.self, from: data)
    } catch {
        print("Error fetching image: \(error)")
    }
    return received
}

func fetchImage(breed: String) async -> URL? {
    //convert name format and add _cat
    var breedName = sanitizeInput(breed: breed, addSuffix: true)
    var received = await fetchImageResponse(breedName: breedName)
    //if the name didn't work, try it without _cat
    if (received?.query.pages.isEmpty) != nil {
        breedName = sanitizeInput(breed: breed, addSuffix: false)
        received = await fetchImageResponse(breedName: breedName)
    }

    //extract image URL and returns
    let address = received?.query.pages.first?.thumbnail.source ?? ""
    guard !address.isEmpty else {
        return nil
    }
    return URL(string: address)
}
