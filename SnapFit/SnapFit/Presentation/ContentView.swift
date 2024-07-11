//
//  ContentView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/9/24.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var kakaoAuthVM = KakaoAuthViewModel()
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Button {
                // Action
                kakaoAuthVM.handleKakaoLogin()
                
            } label: {
                Text("카카오 로그인")
            }
            
            Button {
                // Action
                kakaoAuthVM.handleKakaoLogout()
            } label: {
                Text("카카오 로그아웃")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
