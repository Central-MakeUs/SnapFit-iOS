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
    var showRequired: Bool = false // 기본값을 false로 설정

    var body: some View {
        HStack(alignment: .lastTextBaseline) {
            Rectangle().hidden()
                .frame(width: 10, height: 2)
            Text(title)
                .font(.callout)
                .bold()
            if showRequired {
                Text("[필수]")
                    .font(.footnote)
                    .foregroundColor(Color(.systemGray2))
            }
            Spacer()
        }
    }
}

#Preview {
    VStack {
        SectionHeaderView(title: "닉네임")
        SectionHeaderView(title: "이메일", showRequired: true)
    }
}
