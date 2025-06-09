
//
//  CatFactsView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 5/28/25.
//

import SwiftUI


struct CatFactsView: View {

    @State private var facts: [CatFact] = []
    @State private var chunkedFacts: [[CatFact]] = []

    private let pageSize = 20
    private let standardWidth: CGFloat = 120
    private let standardCornerRadius: CGFloat = 12
    private let standardSpacing: CGFloat = 16
    private let standardColumns = [
        GridItem(.flexible()), GridItem(.flexible()),
    ]

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(chunkedFacts, id: \.self) { chunk in
                    LazyVStack {
                        ForEach(chunk, id: \.self) { fact in
                            Text(fact.fact)
                                .font(.caption)
                                .padding(.vertical)

                        }
                    }
                }
            }
        }
        .task {
            facts = await fetchFacts()?.data ?? []
            chunkedFacts = chunkFacts(facts)
        }
    }

    private func chunkFacts(_ facts: [CatFact]) -> [[CatFact]] {
        return stride(from: 0, to: facts.count, by: pageSize).map {
            Array(facts[$0..<min($0 + pageSize, facts.count)])
        }

    }


}
