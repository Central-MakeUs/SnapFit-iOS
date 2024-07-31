//
//  SectionHeaderView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//

import SwiftUI

// 섹션 헤더 뷰
struct SectionHeaderView: View {
    let title: String
    
    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Rectangle()
                .frame(width: 16, height: 2)
            Text(title)
                .font(.callout)
                .bold()
            Spacer()
        }
    }
}

#Preview {
    SectionHeaderView(title: "닉네임")
}
