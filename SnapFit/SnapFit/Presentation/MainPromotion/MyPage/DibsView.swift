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

struct DibsEmptyView: View {
    var body: some View {
        VStack(alignment: .center ,spacing: 15){
            
            Image("EmptyLogo")
                .resizable()
                .frame(width: 30, height: 47)
            
            Text("상품을 찜해보세요!")
                .bold()
        
            Text("찜한 상품이 없습니다.")
                .foregroundStyle(Color(.systemGray))
        }
    }
}

#Preview {
    DibsView()
}

#Preview {
    DibsEmptyView()
}
