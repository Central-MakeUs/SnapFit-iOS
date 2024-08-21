//
//  AppInfoContent.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct AppInfoContent: View {
    // Properties
    var name: String
    var linkDestination: String? = nil
    var interactor: MyPageBusinessLogic?
    var canNavigate: Bool = true
    
    @State private var showModal: Bool = false
    @State private var showConfirmationAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var confirmAction: () -> Void = {}
    @State private var cancelAction: () -> Void = {}

    var body: some View {
        VStack {
            Spacer()
            HStack {
                  if name == "로그아웃" {
                    Button {
                        alertMessage = "로그아웃 하시겠습니까?"
                        confirmAction = {
                            interactor?.serviceLogout() // Kakao 로그아웃 처리
                        }
                        cancelAction = {
                            // 취소 액션 처리
                        }
                        showConfirmationAlert = true
                    } label: {
                        content
                    }
                } else if name == "탈퇴하기" {
                    Button {
                        alertMessage = "정말 탈퇴하시겠습니까?\n스냅핏과의 추억이 모두 사라집니다!"
                        confirmAction = {
                            interactor?.cancelmembership() // Kakao 탈퇴 처리
                        }
                        cancelAction = {
                            // 취소 액션 처리
                        }
                        showConfirmationAlert = true
                    } label: {
                        content
                    }
                } else if let linkDestination = linkDestination {
                    Button {
                        showModal.toggle()
                    } label: {
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
        .alert(isPresented: $showConfirmationAlert) {
            Alert(
                title: Text("알림"),
                message: Text(alertMessage),
                primaryButton: .destructive(Text("확인"), action: confirmAction),
                secondaryButton: .default(Text("취소"), action: cancelAction) // "취소" 버튼으로 변경
            )
        }
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
