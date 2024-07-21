//
//  CardView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/18/24.
//

import SwiftUI

struct CardView: View {
    enum SizeType {
        case mini
        case middle
        case big
    }
    
    let sizeType: SizeType
    @State private var isLiked = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Image("demo6")
                .resizable()
                .scaledToFill()
                .clipped()
                .overlay {
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                    }
                    .offset(x: sizeType == .mini ? 40 : (sizeType == .middle ? 65 : 70), y: sizeType == .mini ? -50 : (sizeType == .middle ? -70 : -90))
                }
                .frame(width: sizeType == .mini ? 118 : (sizeType == .middle ? 174 : 188), height: sizeType == .mini ? 145 : (sizeType == .middle ? 200 : 234))
                .padding(.bottom, 5)
            
            Group {
                Text("고급퀄리티 | 15년 경력, 홍대출신 전문 포토스냅작가 영상프로필...")
                    .font(.callout)
                    .lineLimit(2) // 최대 2줄까지만 표시되도록 설정
                    .frame(width: sizeType == .mini ? 100 : (sizeType == .middle ? 140 : 160)) // 너비를 적절히 조절하여 프레임에 맞춤

                if sizeType == .big {
                    HStack(spacing: 13.5) {
                        Image("staricon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 16)
                        
                        Text("5.0 (30)")
                            .font(.caption)
                            .foregroundColor(.black)
                    }
                }

                Text("서울 중구")
                    .font(.caption)
                    .foregroundColor(.black)
                
                Text("36,500원")
                    .font(.caption)
                    .foregroundColor(.black)
                
                if sizeType == .middle {
                    
                    Text("시크")
                        .font(.caption)
                        .bold()
                        .foregroundColor(Color("profileLabelColor"))
                        .padding(.vertical, 5) // 세로 패딩을 줄임
                        .padding(.horizontal, 10) // 가로 패딩을 줄임
                        .background(Color("DibsLabelColor").opacity(0.2))
                        .cornerRadius(5)
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 10, bottom: 5, trailing: 10))
            
        }
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


#Preview {
    CardView(sizeType: .mini)
        .frame(width: 118, height: 244)
}

#Preview {
    CardView(sizeType: .middle)
        .frame(width: 174, height: 322)
}

#Preview {
    CardView(sizeType: .big)
        .frame(width: 188, height: 360)
}
