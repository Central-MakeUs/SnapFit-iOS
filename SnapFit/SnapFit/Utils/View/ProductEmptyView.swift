//
//  ProductEmptyView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//

import SwiftUI

struct ProductEmptyView: View {
    var body: some View {
        HStack(content: {
            Spacer()
            
            VStack(spacing: 16){
                Image("emptyView")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 117.12, height:  117.57)
                Text("작가의 등록된 상품이 없습니다.")
                    .font(.subheadline)
                    .foregroundStyle(Color("LoginFontColor"))
            }
            
            Spacer()
        })
    }
}

#Preview {
    ProductEmptyView()
}
