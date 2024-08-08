//
//  ImageSliderView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI

struct ImageSliderView: View {
    let images: [String] // Array of image names
    @State private var currentIndex: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $currentIndex) {
                ForEach(images.indices, id: \.self) { index in
                    Image(images[index])
                        .resizable()
                        .scaledToFill()
                        .tag(index)
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
                        .animation(.easeInOut, value: currentIndex) // currentIndex 값이 변경될 때마다 애니메이션이 적용되어 캡슐의 모양과 색상이 부드럽게 변경
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

struct testView: View {
    var body: some View {
        ImageSliderView(images: ["demo1", "demo2", "demo3"]) // Replace with your image names
    }
}

struct testView_Previews: PreviewProvider {
    static var previews: some View {
        testView()
    }
}
