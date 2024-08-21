//
//  AppInfoContent.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct AppInfoContent: View {
    var name: String
    var linkDestination: String? = nil
    var interactor: MyPageBusinessLogic? = nil
    var canNavigate: Bool = true
    var onButtonPress: () -> Void = {}
    
    @State private var showModal: Bool = false
    @State private var showConfirmationAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var confirmAction: () -> Void = {}
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if name == "로그아웃" || name == "탈퇴하기" {
                    Button(action: {
                        onButtonPress()
                    }) {
                        content
                    }
                } else if let linkDestination = linkDestination {
                    Button(action: {
                        showModal.toggle()
                    }) {
                        content
                    }
                    .fullScreenCover(isPresented: $showModal) {
                        WebViewWithCustomBackButton(url: URL(string: linkDestination)!, title: name)
                    }
                } else {
                    content
                }
            }
            Spacer()
            Divider()
        }
        .frame(height: 68)
    }
    
    private var content: some View {
        HStack {
            Text(name)
                .foregroundColor(.black)
                .font(.system(size: 14))
            Spacer()
            Image(systemName: "chevron.right")
        }
    }
}



struct WebViewWithCustomBackButton: View {
    @Environment(\.presentationMode) var presentationMode
    let url: URL
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                        .padding()
                }
                
                Spacer()
                
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.clear)
                        .padding()
                }
            }
            .background(Color.white)
            
            WebView(url: url)
                .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct AppInfoLabel: View {
    let labelText: String
    
    var body: some View {
        HStack(alignment: .lastTextBaseline){
            Rectangle()
                .frame(width: 16, height: 2)
            Text(labelText)
                .font(.system(size: 16))
                .fontWeight(.bold)
        }
    }
}





#Preview {
    Group {
        AppInfoContent(name: "Sample2")
        AppInfoContent(name: "Sample2", canNavigate: false)
        AppInfoContent(name: "로그아웃")
        AppInfoContent(name: "탈퇴하기")
    }
}
