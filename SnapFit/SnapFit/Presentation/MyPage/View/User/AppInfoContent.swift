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
    var canNavigate: Bool = true  // New property to control navigation
    
    @State private var showModal: Bool = false
    @State private var showAlert: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                if name == "상품관리" || name == "예약관리" {
                    if canNavigate {
                        NavigationLink(
                            destination: destinationView(),
                            isActive: .constant(true)
                        ) {
                            content
                        }
                    } else {
                        Button(action: {
                            showAlert = true
                        }) {
                            content
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("알림"),
                                  message: Text("작가의 권한이 없습니다."),
                                  dismissButton: .default(Text("확인")))
                        }
                    }
                } else if name == "로그아웃" {
                    Button {
                        interactor?.serviceLogout() // Kakao 로그아웃 처리
                    } label: {
                        content
                    }
                } else if name == "탈퇴하기" {
                    Button {
                        interactor?.cancelmembership() // Kakao 탈퇴 처리
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
    
    private func destinationView() -> some View {
        switch name {
        case "상품관리":
            return AnyView(ProductManagementView().navigationBarBackButtonHidden(true))
        case "예약관리":
            return AnyView(ReservationManagementView().navigationBarBackButtonHidden(true))
        default:
            return AnyView(EmptyView())
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
