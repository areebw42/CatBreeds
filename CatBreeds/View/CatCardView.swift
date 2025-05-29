<<<<<<< HEAD
//
//  CatCardView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 5/28/25.
//

import SwiftUI

=======
>>>>>>> 596dee0f400820b2a1b9bdb18c1b2e1809193985
struct CatCardView: View {
    let breed: CatBreed
    let standardWidth: CGFloat
    @State var image: URL? = nil

    var body: some View {
        LazyVStack {

            if image != nil {
                if let imageURL = image {
                    AsyncImage(url: imageURL) { phase in
                        if let image = phase.image {
                            image.resizable().scaledToFit()
                        } else if phase.error != nil {
                            AsyncImage(url: imageURL) { phase in
                                if let image = phase.image {
                                    image.resizable().scaledToFit()
                                }
                            }
                        } else {
                            ProgressView()
                        }
                    }
                }
            } else {
                Text("Image Unavailable")
                    .foregroundColor(.red)
                    .frame(width: standardWidth)
                    .font(.headline)
                    .scaledToFit()
            }

            Text(breed.breed)
                .frame(width: standardWidth)
                .font(.headline)
                .scaledToFit()
        }.task {
            image = await fetchImage(breed: breed.breed)
        }
    }
<<<<<<< HEAD
}
=======
}
>>>>>>> 596dee0f400820b2a1b9bdb18c1b2e1809193985
