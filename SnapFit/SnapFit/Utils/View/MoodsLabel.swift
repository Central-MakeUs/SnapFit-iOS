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


struct InOutLabel: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.caption)
            .bold()
            .foregroundColor(Color("InOutLableFontColor")) // 폰트 색상
            .padding(.vertical, 5) // 세로 패딩을 줄임
            .padding(.horizontal, 10) // 가로 패딩을 줄임
            .background(Color("InOutLableBackColor").opacity(0.3)) // 배경색
            .cornerRadius(5)
    }
}

struct StarImageLabel: View {
    var text: String
    
    var body: some View {
        
        HStack(spacing: 8) {
            Image("starLabel")
                .resizable()
                .scaledToFit()
                .frame(width: 14, height: 14)
            
            Text(text)
                .font(.caption)
                .bold()
                .foregroundColor(.white)
        }
        .padding(.vertical, 6) // 세로 패딩을 줄임
        .padding(.horizontal, 10) // 가로 패딩을 줄임
        //.background(Color("profileLabelColor"))
        .background(Color(.black))
        .cornerRadius(5)
    
    }
}

struct MoodsLabel_Previews: PreviewProvider {
    static var previews: some View {
        MoodsLabel(text: "시크")
            .previewLayout(.sizeThatFits) // 프리뷰에서 크기 맞춤
    }
}

struct InOutLabel_Previews: PreviewProvider {
    static var previews: some View {
        InOutLabel(text: "야외스냅")
            .previewLayout(.sizeThatFits) // 프리뷰에서 크기 맞춤
    }
}

struct StarImageLabel_Previews: PreviewProvider {
    static var previews: some View {
        StarImageLabel(text: "서울 용산구")
            .previewLayout(.sizeThatFits) // 프리뷰에서 크기 맞춤
    }
}
