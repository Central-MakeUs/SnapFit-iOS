//
//  TabView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/30/24.
//
import SwiftUI

struct SnapFitTabView: View {
    @State private var selectedTab = 0 // 선택된 탭을 저장할 상태 변수

    var body: some View {
        TabView(selection: $selectedTab) {
            MainPromotionView()
            .tabItem {
                VStack {
                    // 선택된 탭에 따라 이미지 변경
                    if selectedTab == 0 {
                        Image("iconHome")
                    } else {
                        Image("iconHomeNoTab")
                    }
                    Text("홈")
                }
            }
            .tag(0)

            VStack {
                Text("둘러보기 화면")
            }
            .tabItem {
                VStack {
                    // 선택된 탭에 따라 이미지 변경
                    if selectedTab == 1 {
                        Image("iconList")
                    } else {
                        Image("iconListNoTab")
                    }
                    Text("사진리스트")
                }
            }
            .tag(1)

            MyPageView()
            .tabItem {
                VStack {
                    // 선택된 탭에 따라 이미지 변경
                    if selectedTab == 2 {
                        Image("iconMypage")
                    } else {
                        Image("iconMypageNoTab")
                    }
                    Text("마이페이지")
                }
            }
            .tag(2)
        }
        .accentColor(.black) // 선택된 탭 아이콘 색상
    }
}

#Preview {
    SnapFitTabView()
}
