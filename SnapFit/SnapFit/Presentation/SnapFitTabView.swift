//
//  TabView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/30/24.
//
import SwiftUI

struct SnapFitTabView: View {
    @State private var selectedTab = 0
    
    @StateObject var mainPromotionViewModel = MainPromotionViewModel()
    @StateObject var authorListViewModel = MainPromotionViewModel()
    
    var body: some View {
        TabView(selection: $selectedTab) {
            MainPromotionView(mainPromotionViewModel: mainPromotionViewModel)
                .configureView()
                .tabItem {
                    VStack {
                        Image(selectedTab == 0 ? "iconHome" : "iconHomeNoTab")
                        Text("홈")
                    }
                }
                .tag(0)

            AuthorListView(authorListViewModel: authorListViewModel).configureView()
                .tabItem {
                    VStack {
                        Image(selectedTab == 1 ? "iconList" : "iconListNoTab")
                        Text("사진리스트")
                    }
                }
                .tag(1)

            MyPageView()
                .configureView()
                .tabItem {
                    VStack {
                        Image(selectedTab == 2 ? "iconMypage" : "iconMypageNoTab")
                        Text("마이페이지")
                    }
                }
                .tag(2)
        }
        .accentColor(.black)
    }
}

#Preview {
    SnapFitTabView()
}
