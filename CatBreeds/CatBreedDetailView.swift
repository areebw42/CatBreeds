//
//  CatBreedDetailView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

struct CatBreedDetailView: View {
    let catBreed: CatBreed
    var animation: Namespace.ID
    private let animDuration = 0.3
    @State private var offset = CGSize.zero
    @Binding var showDetail: Bool

    private let standardSpacing: CGFloat = 20
    @Binding var selectedCat: CatBreed?

    var drag: some Gesture {
        DragGesture()
            .onChanged { gesture in
                if gesture.translation.height > 0 {
                    offset = gesture.translation
                }
            }
            .onEnded { gesture in
                if gesture.translation.height > 150 {
                    withAnimation(
                        .spring(),
                        {
                            showDetail = false
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + animDuration
                            ) {
                                selectedCat = nil
                            }
                        }
                    )
                }
                offset = .zero
            }
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: standardSpacing) {
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .clipped()
                    .matchedGeometryEffect(id: catBreed.id, in: animation)
                    .cornerRadius(16)
                    .padding(.top, 40)

                Text(catBreed.breed)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, standardSpacing)

                CatBreedInfoView(catBreed: catBreed)

            }

            Button(
                action: {
                    withAnimation(
                        .spring(),
                        {
                            showDetail = false
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + animDuration
                            ) {
                                selectedCat = nil
                            }
                        }
                    )
                },
                label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 32, height: 32)
                        .padding()

                }
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemBackground))
        .offset(y: offset.height)
        .gesture(drag)
    }
}
