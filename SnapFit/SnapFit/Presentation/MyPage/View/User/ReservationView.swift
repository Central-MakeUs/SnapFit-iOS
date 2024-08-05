//
//  ReservationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct ReservationView: View {
    
    // columns 의 갯수를 1개로 설정
    let columns: [GridItem] = [
        //GridItem을 담을 수 있는 배열 생성
        // .flexible : 크기를 화면 프레임에 유연하게 늘렸다 줄었다 할 수 있게 설정
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns, // 3열
                alignment: .center,
                spacing: 6){
                    ForEach(0..<20) { index in
                        NavigationLink(destination: ReservationInfoView().navigationBarBackButtonHidden(true)) {
                            ReservationCardView()
                                .frame(width: 390, height: 163)
                            
                        }
                    }
                }
        } // :1번
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
                Text("예약내역")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        
    }
}


struct ReservationCardView: View {
    var body: some View {
        VStack {
            HStack(spacing: 34) {
                Image("demo1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipShape(RoundedRectangle(cornerRadius: 10)) // Apply corner radius
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("고급퀄리티 | 15년 경력, 홍대")
                        .font(.footnote)
                        .foregroundColor(.black) // 텍스트 색상을 검정색으로 설정
                    
                    Text("예약일시 24.02.22(목) 오후 5:00")
                        .font(.caption)
                        .foregroundColor(.black) // 텍스트 색상을 검정색으로 설정
                    
                    Text("32,400원")
                        .font(.callout) // Equivalent to font size 16
                        .bold()
                        .foregroundColor(.black) // 텍스트 색상을 검정색으로 설정
                    HStack(spacing: 8){
                        MoodsLabel(text: "시크")
                        InOutLabel(text: "야외스냅")
                    }
                }
                
            }
        }
    }
}

struct ReservationInfoCardView: View {
    var body: some View {
        HStack(spacing: 34) {
            Image("demo1")
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Apply corner radius
            
            VStack(alignment: .leading, spacing: 4) {
                Text("고급퀄리티 | 15년 경력, 홍대")
                    .font(.footnote)
                    .foregroundColor(.black) // 텍스트 색상을 검정색으로 설정
                
                Text("유저 닉네임")
                    .font(.caption)
                    .foregroundStyle(Color(.systemGray5))
                
                // 이메일 텍스트의 스타일을 명시적으로 설정
                Text(verbatim: "snap@naver.com") // 이메일 자동 링크인식 해제
                    .font(.caption)
                    .foregroundColor(.black) // 텍스트 색상을 검정색으로 설정
                
                Text("예약일시 24.02.22(목) 오후 5:00")
                    .font(.caption)
                    .foregroundColor(.black) // 텍스트 색상을 검정색으로 설정
            }
        }
    }
}



#Preview {
    ReservationView()
}
