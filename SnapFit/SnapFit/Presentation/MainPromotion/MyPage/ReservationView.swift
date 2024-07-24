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
        HStack(spacing: 24){
            Image("demo1")
                .resizable()
                .scaledToFill()
                .frame(width: 130, height: 130)
                .clipShape(RoundedRectangle(cornerRadius: 10)) // Apply corner radius
            
            VStack(alignment: .leading, spacing: 4) {
                Text("고급퀄리티 | 15년 경력, 홍대")
                    .font(.system(size: 14))
                
                Text("예약일시 24.02.22(목) 오후 5:00")
                    .font(.system(size: 14))
                
                Text("32,400원")
                    .font(.title3) // Equivalent to font size 16
                    .bold()
            }
            
        }
    }
}


#Preview {
    ReservationView()
}
