//
//  CatBreedDetailView.swift
//  CatBreeds
//
//  Created by Areeb Durrani on 4/9/25.
//

import SwiftUI

/*
 View used to show more detailed information compared to the standard card view.
 It appears when the card view is tapped, and displays the Country, Origin, Coat and Pattern values returned by the API.
 */
struct CatBreedDetailView: View {
    let catBreed: CatBreed
    var animation: Namespace.ID
    //duration value used to wait for animation to complete before removing view
    private let animDuration = 0.3
    //value to position the view at an offset to the screen while scrolling
    @State private var offset = CGSize.zero
    //Binding for showDetail in order to set it to false to signal the ContentView to remove this view.
    @Binding var showDetail: Bool

    private let standardSpacing: CGFloat = 20

    //binding for selectedCat so we can also set that to nil
    @Binding var selectedCat: CatBreed?

    var drag: some Gesture {
        //Define gesture for dragging the view
        DragGesture()
            .onChanged { gesture in
                if gesture.translation.height > 0 {
                    //Change offset to match gesture position
                    offset = gesture.translation
                }
            }
            .onEnded { gesture in
                if gesture.translation.height > 150 {
                    //dismiss the view
                    withAnimation(
                        .spring(),
                        {
                            showDetail = false
                            //wait for animation to finish
                            DispatchQueue.main.asyncAfter(
                                deadline: .now() + animDuration
                            ) {
                                //nil the selectedCat to dismiss the view.
                                selectedCat = nil
                            }
                        }
                    )
                }
                //zero the offset as it is no longer needed
                offset = .zero
            }
    }

    var body: some View {
        //ZStack to layer info and button.
        ZStack(alignment: .topTrailing) {
            VStack(spacing: standardSpacing) {
                if catBreed.image != nil {
                    AsyncImage(url: catBreed.image) { image in
                        image
                            .image?.resizable().scaledToFit()
                    }
                }
                Text(catBreed.breed)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                    .padding(.top, standardSpacing)

                CatBreedInfoView(catBreed: catBreed)

            }

            Button(
                action: {
                    //dismiss the view
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
