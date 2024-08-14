//
//  CustomTopTabbar.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI

struct CustomTopTabbar: View {
    @State private var selectedTab: Int = 0
    private let tabs = ["전체", "로맨틱", "시크", "공주", "키치", "차분함", "몽환적", "밝은"]
    
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                ForEach(tabs.indices, id: \.self) { index in
                    Button(action: {
                        withAnimation {
                            selectedTab = index
                        }
                    }) {
                        VStack(spacing: 0) {
                            Text(tabs[index])
                                .padding()
                                .font(.subheadline)
                                .frame(minWidth: 50)
                                .foregroundColor(selectedTab == index ? .black : .gray)
                                .background(Color.white)
                            
                            // 하단 바
                            Rectangle()
                                .frame(height: 8)
                                .foregroundColor(selectedTab == index ? .black : Color(.systemGray6))
                                .animation(.easeInOut(duration: 0.4), value: selectedTab)
                        }
                        .frame(width: 78, height: 49)
                    }
                }
            }
            .frame(height: 49)
        }
        .background(Color.white)
    }
}

#Preview {
    CustomTopTabbar()
}
