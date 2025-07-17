//
//  ImageSliderView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI
import Kingfisher

struct ImageSliderView: View {
    let images: [String] // Array of image URLs
    @State private var currentIndex: Int = 0
    @State private var isFullScreen: Bool = false // State to manage full screen mode
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    if let url = URL(string: images[index]) {
                        KFImage(url)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .tag(index)
                            .onTapGesture {
                                isFullScreen.toggle() // Toggle full screen mode
                            }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 248)
            
            // Mini bar indicator
            HStack(spacing: 4) {
                ForEach(images.indices, id: \.self) { index in
                    Capsule()
                        .frame(width: currentIndex == index ? 20 : 8, height: 8)
                        .foregroundColor(currentIndex == index ? .black : .gray)
                        .animation(.easeInOut, value: currentIndex)
                }
            }
            .padding(.top, 8)
        }
        .fullScreenCover(isPresented: $isFullScreen) {
            FullScreenImageSliderView(images: images, currentIndex: $currentIndex, isFullScreen: $isFullScreen)
        }
    }
}



struct FullScreenImageSliderView: View {
    let images: [String]
    @Binding var currentIndex: Int
    @Binding var isFullScreen: Bool
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    if let url = URL(string: images[index]) {
                        KFImage(url)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .clipped()
                            .tag(index)
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .edgesIgnoringSafeArea(.all)
            
            Button(action: {
                isFullScreen = false
            }) {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding()
            }
            .background(Color.black.opacity(0.6), in: Circle())
            .padding(.leading, 16) // Adjust the padding to position the button
            .padding(.top, 16) // Adjust the padding to position the button
        }
    }
}




struct TestView: View {
    var body: some View {
        ImageSliderView(images: [
            "https://cdn.pixabay.com/photo/2021/08/03/11/48/canal-6519196_640.jpg",
            "https://cdn.pixabay.com/photo/2021/10/28/09/59/city-6749295_640.jpg",
            "https://cdn.pixabay.com/photo/2018/07/18/20/25/channel-3547224_640.jpg"
        ])
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
