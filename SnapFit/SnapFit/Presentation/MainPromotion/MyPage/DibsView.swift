//
//  DibsView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct DibsView: View {
    
    @State private var selectedTab: Int = 0
    
    
    // columns 의 갯수를 2개로 설정
    let columns: [GridItem] = [
        //GridItem을 담을 수 있는 배열 생성
        // .flexible : 크기를 화면 프레임에 유연하게 늘렸다 줄었다 할 수 있게 설정
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    var body: some View {
        VStack{
            HStack {
                TabButton(title: "상품", isSelected: selectedTab == 0) {
                    withAnimation {
                        selectedTab = 0
                    }
                }
                TabButton(title: "작가", isSelected: selectedTab == 1) {
                    withAnimation {
                        selectedTab = 1
                    }
                }
            }
            .frame(height: 57)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 0)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            
            
            // Indicator
            GeometryReader { geometry in
                Rectangle()
                    .frame(width: geometry.size.width / 2, height: 2)
                    .foregroundColor(.black)
                    .offset(x: selectedTab == 0 ? 0 : geometry.size.width / 2)
            }
            .frame(height: 2)
            
            
            
            // Content based on selected tab
            if selectedTab == 0 {
                // 상품 탭의 내용
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<10, id: \.self) { item in
                            CardView(sizeType: .middle)
                                .frame(width: 174, height: 322)
                                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            } else if selectedTab == 1 {
                // 작가 탭의 내용
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(0..<10, id: \.self) { item in
                            CardView(sizeType: .middle)
                                .frame(width: 174, height: 322)
                                .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("찜한내역")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}


struct TabButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Text(title)
                    .foregroundColor(isSelected ? .black : .gray)
                    .font(.headline)
                
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    DibsView()
}
