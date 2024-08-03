//
//  AuthorListView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI

struct AuthorListView: View {
    @State private var selectedTab: Int = 0
    
    
    // columns 의 갯수를 2개로 설정
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    var body: some View {
        VStack{
            HStack {
                Image("mainSnapFitLogo")
                    .resizable()
                    .frame(width: 91.18, height: 20)
                Spacer()
            }
            .padding(.horizontal)
            
            CustomTopTabbar()
                .padding(.bottom)
            // 상품 탭의 내용
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(0..<10, id: \.self) { item in
                        MiddleCardView()
                            .frame(width: 175, height: 270)
                            .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
        }
    }
}

#Preview {
    AuthorListView()
}
