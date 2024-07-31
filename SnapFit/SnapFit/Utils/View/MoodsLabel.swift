//
//  MoodsLabel.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//

import SwiftUI

struct MoodsLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .bold()
            .foregroundColor(Color("labelFontColor")) // 폰트 색상
            .padding(.vertical, 5) // 세로 패딩을 줄임
            .padding(.horizontal, 15) // 가로 패딩을 줄임
            .background(Color("labelBackColor").opacity(0.3)) // 배경색
            .cornerRadius(5)
    }
}

struct MoodsLabel_Previews: PreviewProvider {
    static var previews: some View {
        MoodsLabel(text: "시크")
            .previewLayout(.sizeThatFits) // 프리뷰에서 크기 맞춤
    }
}
