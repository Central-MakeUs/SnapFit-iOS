//
//  Mockup.swift
//  SnapFit
//
//  Created by 정정욱 on 7/17/24.
//

import SwiftUI

struct Mockup: View {
    
    @State private var isLiked = false // 좋아요 상태를 관리하는 변수
    
    
    let layout: [GridItem] = [
        GridItem(.flexible())
    ]
    
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Group {
                    Text("oo 님의\n맞춤 인생사진을 찍어보세요!")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                        .padding(.top, 50)
                    
                    Text("스냅핏에서는 원하는 분위기의 사진을 찾을 수 있어요.")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom)
                }
                .padding(.horizontal)
            }
            
            // 우리지역 추천 스냅 작가
            ZStack{
                Image("demo5")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 330, height: 200)
                    .clipped()
                
                HStack(spacing: 230) {
                    Text("New")
                        .font(.caption)
                        .foregroundColor(.white)
                    
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
                .offset(CGSize(width: 0, height: -70.0))
                
                Group{
                    Rectangle()
                        .frame(width: 330, height: 82)
                        .foregroundColor(Color.black.opacity(0.7))
                    
                    VStack(alignment: .leading, spacing: 7) {
                        Text("이정섭")
                            .font(.callout)
                            .foregroundColor(.white)
                        HStack(spacing: 13.5)  {
                            
                            Image("staricon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 15, height: 16)
                            
                            Text("5.0 (30)")
                                .font(.caption)
                                .foregroundColor(.white)
                            Rectangle()
                                .frame(width: 1.5, height: 14)
                                .foregroundColor(.white)
                            
                            Text("서울 중구")
                                .font(.caption)
                                .foregroundColor(.white)
                            Rectangle()
                                .frame(width: 1.5, height: 14)
                                .foregroundColor(.white)
                            
                            Text("경력 1년")
                                .font(.caption)
                                .foregroundColor(.white)
                            
                        }
                        
                        Text("대체불가! 성수 컨셉스냅 전문 인기 포토그래퍼, 데이트 스냅...")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }
                .offset(CGSize(width: 0, height: 60.0))
            }  //:ZSTACK
            .padding(.bottom)
            
            // LazyHGrid
            // ScrollView horizontal
            Text("우리 지역 추천 스냅작가")
            ScrollView(.horizontal, showsIndicators: false) {
                // 가로(행) 3줄 설정
                LazyHGrid(rows: layout, spacing: 20) {
                    ForEach(0..<10, id: \.self) { item in
                        CardView(sizeType: .mini)
                            .frame(width: 118, height: 244)
                            .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            
            // LazyHGrid
            // ScrollView horizontal
            Text("추천 스냅 패키지")
            ScrollView(.horizontal, showsIndicators: false) {
                // 가로(행) 3줄 설정
                LazyHGrid(rows: layout, spacing: 20) {
                    ForEach(0..<10, id: \.self) { item in
                        CardView(sizeType: .big)
                            .frame(width: 188, height: 355)
                            .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            
            
            
            // 포토스팟 추천
            Text("포토스팟 추천")
            HStack(content: {
                Image("demo6")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 90, height: 90)
                    .clipped()
                
                VStack(alignment: .leading){
                    Text("경복궁의 멋진 야경을 느껴볼 수 있는 포토스팟")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    Text("서울 중구")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                 
            })
        }
        
        
     
    }
}

#Preview {
    Mockup()
}
