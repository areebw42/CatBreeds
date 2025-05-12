//
//  CatBreedsTests.swift
//  CatBreedsTests
//
//  Created by Areeb Durrani on 4/25/25.
//

import CatBreeds
import Testing

struct CatBreedsTests {

    @Test func fetchBreedsTest() async throws {
        let breeds = await fetchBreeds()
        #expect(breeds != nil && breeds?.data != [])
    }
}
