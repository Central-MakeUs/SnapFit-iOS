//
//  MainPromotionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//

import SwiftUI

struct MainPromotionView: View {
    
    @State private var isLiked = false // 좋아요 상태를 관리하는 변수
    
    
    let layout: [GridItem] = [
        GridItem(.flexible())
    ]
    
    let columns: [GridItem] = [
            //GridItem을 담을 수 있는 배열 생성
            // .flexible : 크기를 화면 프레임에 유연하게 늘렸다 줄었다 할 수 있게 설정
            // 열사이 간격 10
            GridItem(.flexible(), spacing: 10, alignment: nil),
            GridItem(.flexible(), spacing: 10, alignment: nil),
    ]
    
    var body: some View {
        ScrollView {
            
            VStack(spacing: 24) { // VStack의 spacing 값을 0으로 설정
                HStack {
                    Image("mainSnapFitLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 20)
                    Spacer()
                    
                    Image("alarm")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                }
             
                
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("안녕하세요, 한소희님")
                            .font(.title2)
                            .bold()
                            .padding(.bottom)
                         
                        
                        Text("스냅핏에서는 원하는\n분위기의 사진을 찾을 수 있어요.")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                            .padding(.bottom)
                    }
                    
                    Spacer()
                    
                    Image("SnapFitProfileLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                
            }
            .padding(.horizontal)

            
           
            HStack(alignment: .lastTextBaseline){
                Rectangle()
                    .frame(width: 16, height: 2)
                Text("이런 사진은 어때요?")
                    .font(.callout)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .frame(width: 24, height: 24)
                    .padding(.trailing)
            }
          
            ZStack{
                Image("demo5")
                    .resizable()
                    .scaledToFill()
                    .frame(width: .infinity, height: 200)
                    .clipped()
                    .padding(.horizontal)
                
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
                        .frame(width: .infinity, height: 82)
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
                        /*
                         분위기 버튼 자리
                         */
                    }
                    .padding(.horizontal, 30)
                
                }
                .offset(CGSize(width: 0, height: 60.0))
            }  //:ZSTACK
            .padding(.bottom)
            
            // LazyHGrid
            // ScrollView horizontal
            ScrollView(.horizontal, showsIndicators: false) {
                // 가로(행) 3줄 설정
                LazyHGrid(rows: layout, spacing: 3) {
                    ForEach(0..<10, id: \.self) { item in
                        MiniCardView()
                            .frame(width: 130, height: 222)
                            .padding(EdgeInsets(top: 2, leading: 15, bottom: 2, trailing: 2))
                    }
                }
            }
      
            .padding(.bottom)
            
            
            
            HStack(alignment: .lastTextBaseline){
                Rectangle()
                    .frame(width: 16, height: 2)
                Text("메이커와 소중한 추억을 만들어보세요")
                    .font(.callout)
                    .bold()
                Spacer()
                Image(systemName: "chevron.right")
                    .frame(width: 24, height: 24)
                    .padding(.trailing)
            }
            
            // LazyVGrid
            // ScrollView horizontal
            ScrollView(.vertical, showsIndicators: false) {
                // 가로(행) 2줄 설정
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(0..<10, id: \.self) { item in
                        BigCardView()
                            .frame(width: 175, height: 288)
                            //.padding(EdgeInsets(top: 2, leading: 15, bottom: 2, trailing: 15))
                    }
                }
                .padding(.horizontal)
                
            }
          
            .padding(.bottom)
            
            
          
        }
        
        
     
    }
}

#Preview {
    MainPromotionView()
}
