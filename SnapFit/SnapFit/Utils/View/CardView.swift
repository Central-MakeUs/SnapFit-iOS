//
//  CardView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/18/24.
//

import SwiftUI

struct MiniCardView: View {
    @State private var isLiked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Image("demo3")
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
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
                    .offset(x: 40, y: -40)
                }
                .padding(.bottom, 5)

            Group {
                Text("감성을 담은 스냅사진")
                    .font(.footnote)
                    .bold()
                    .lineLimit(1)
                    .frame(width: .infinity)

                Text("서울 중구")
                    .font(.caption)
                    .foregroundColor(.black)

                Text("36,500원")
                    .font(.footnote)
                    .bold()
                    .foregroundColor(.black)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
        }
        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 4)
    }
}

struct MiddleCardView: View {
    @State private var isLiked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Image("demo3")
                .resizable()
                .scaledToFill()
                .frame(width: 175, height: 170)
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
                    .offset(x: 62, y: -62)
                }
                .padding(.bottom, 5)

            Group {
                Text("고급퀄리티 | 15년 경력, 홍대출신 전문 포토스냅작가 영상프로필...")
                    .font(.footnote)
                    .lineLimit(2)

                Text("서울 중구")
                    .font(.caption)
                    .foregroundColor(.black)

                Text("36,500원")
                    .font(.caption)
                    .bold()
                    .foregroundColor(.black)

                HStack{
                    MoodsLabel(text: "시크")
                    InOutLabel(text: "야외스냅")
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
        }
        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 2)
    }
}

struct BigCardView: View {
    @State private var isLiked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Image("demo1")
                .resizable()
                .scaledToFill()
                .frame(width: 175, height: 200)
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
                    .offset(x: 70, y: -70)
                }
                .padding(.bottom, 5)

            VStack(alignment:.leading){
                Text("추카랜드")
                    .font(.callout)
                    .lineLimit(2)
        

                HStack(spacing: 9) {
                    MoodsLabel(text: "시크", bigCardViewType: true)
                    MoodsLabel(text: "러블리", bigCardViewType: true)
                }
               
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
        }
        .background(Color.white)
//        .cornerRadius(10)
//        .shadow(radius: 4)
    }
}

struct MainPromotionRandomCardView: View {
    @State private var isLiked = false

    var body: some View {
        ZStack{
            Image("demo5")
                .resizable()
                .scaledToFill()
                .frame(width: .infinity, height: 202)
                .clipped()
                .padding(16)
            
            HStack(spacing: 230) {
                Text("New")
                    .font(.caption)
                    .foregroundColor(.white)
                    .hidden()
                
                Button(action: {
                    isLiked.toggle()
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundColor(.white)
                }
            }
            .offset(CGSize(width: 30, height: -70.0))
            
            Group{
                Rectangle()
                    .frame(width: .infinity, height: 96)
                    .foregroundColor(Color.black.opacity(0.7))
                    .padding(.horizontal)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("대체불가! 성수 컨셉스냅 전문 인기 포토그래퍼, 데이트 스냅...")
                        .font(.subheadline)
                        .lineLimit(1)
                        .foregroundColor(.white)
                    Text("32,400원")
                        .font(.subheadline)
                        .foregroundColor(.white)
                    
                    HStack(spacing: 8){
                        MoodsLabel(text: "시크")
                        InOutLabel(text: "야외스냅")
                    }
                }
                .padding(.horizontal, 30)
            
            }
            .offset(CGSize(width: 0, height: 53.0))
        }  //:ZSTACK
    }
}

// Previews
#Preview {
    MiniCardView()
        .frame(width: 118, height: 244)
}

#Preview {
    MiddleCardView()
        .frame(width: 174, height: 322)
}

#Preview {
    BigCardView()
        .frame(width: 175, height: 258)
}

#Preview {
    MainPromotionRandomCardView()
        .frame(width: .infinity, height: 202)
}
