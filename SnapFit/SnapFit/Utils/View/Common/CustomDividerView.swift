//
//  CustomDividerView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI

struct CustomDividerView: View {
    var body: some View {
        Rectangle()
            .fill(Color(UIColor.systemGray6))
            .frame(height: 5)
            .edgesIgnoringSafeArea(.horizontal)
    }
}


#Preview {
    CustomDividerView()
}
