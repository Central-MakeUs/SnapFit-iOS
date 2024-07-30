//
//  TabView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/30/24.
//

import SwiftUI

struct SnapFitTabView: View {
    @State var initPageNumber: Int = 0
    
    var body: some View {
        // selection: TabView 가 어디 페이지를 가리키는지 설정하는것
        TabView(selection: $initPageNumber) {
            Text("둘러보기 화면")
                .tabItem {
                    Image("icoHome")
                    Text("Home")
                }
                .tag(0) // 0번 화면
            
            Text("둘러보기 화면")
                .tabItem {
                    Image("iconList")
                    Text("Browse")
                }
                .tag(1)// 1번 화면
            
            Text("프로필 화면")
                .tabItem {
                    Image("iconMypage")
                    Text("Profile")
                }
                .tag(2)// 2번 화면
        }
    }
}

#Preview {
    SnapFitTabView()
}
