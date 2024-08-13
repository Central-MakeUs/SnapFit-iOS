//
//  SplashAndTabView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//

import SwiftUI

struct SplashAndTabView: View {
    @State private var isSplashActive: Bool = true
    
    var body: some View {
        Group {
//            if isSplashActive {
//                SplashView(isSplashActive: $isSplashActive)
//                    .transition(.opacity)
//            } else {
                SnapFitTabView()
                    //.transition(.opacity) // 전환 애니메이션 단순화
            //}
        }
    }
}


#Preview {
    SplashAndTabView()
}
