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
        .onChange(of: currentIndex) { _ in
            withAnimation {
                // Update view if necessary
            }
        }
    }
}

struct TestView: View {
    var body: some View {
        ImageSliderView(images: [
            "https://cdn.pixabay.com/photo/2021/08/03/11/48/canal-6519196_640.jpg",
            "https://cdn.pixabay.com/photo/2021/10/28/09/59/city-6749295_640.jpg",
            "https://cdn.pixabay.com/photo/2018/07/18/20/25/channel-3547224_640.jpg"
        ]) // Replace with your image URLs
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}
