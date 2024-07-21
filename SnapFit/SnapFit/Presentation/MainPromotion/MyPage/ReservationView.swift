//
//  ReservationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct ReservationView: View {
    
    // columns 의 갯수를 2개로 설정
    let columns: [GridItem] = [
        //GridItem을 담을 수 있는 배열 생성
        // .flexible : 크기를 화면 프레임에 유연하게 늘렸다 줄었다 할 수 있게 설정
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ReservationView()
}
