//
//  SplashAndTabView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//

import SwiftUI

struct SplashAndTabView: View {
    @State private var isSplashActive: Bool = true
    @State private var isTabViewVisible: Bool = false // 탭 뷰의 가시성 상태를 추가
    
    var body: some View {
        Group {
            if isSplashActive {
                SplashView(isSplashActive: $isSplashActive) // 스플래시 화면
                    .transition(.opacity) // 스플래시 화면과 탭 뷰 간의 전환에 애니메이션 적용
            } else {
                SnapFitTabView()
                    .opacity(isTabViewVisible ? 1 : 0) // 탭 뷰의 초기 가시성을 0으로 설정
                    .animation(.easeIn(duration: 1.5), value: isTabViewVisible) // 서서히 나타나는 애니메이션
            }
        }
        .onChange(of: isSplashActive) { newValue in
            if !newValue {
                // 스플래시 화면이 사라진 후 탭 뷰의 가시성을 변경하여 애니메이션을 시작
                withAnimation {
                    isTabViewVisible = true
                }
            }
        }
    }
}

#Preview {
    SplashAndTabView()
}
