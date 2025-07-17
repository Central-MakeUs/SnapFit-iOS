//
//  CustomAlertView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    let message: String
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("알림")
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
            Button(action: {
                action()
            }) {
                Text("확인")
                    .bold()
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}


struct MyPageCustomAlertView: View {
    @Binding var isPresented: Bool
    let message: String
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        ZStack {
            // Dark background for the entire screen
    
            // Alert box
            VStack(spacing: 20) {
                Text("알림")
                    .font(.headline)
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(Color(.systemGray))
                    .multilineTextAlignment(.center)
                
                HStack {
                    Button(action: {
                        cancelAction()
                        isPresented = false
                    }) {
                        Text("취소")
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(10)
                    }
                    
                    Button(action: {
                        confirmAction()
                        isPresented = false
                    }) {
                        Text("확인")
                            .bold()
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(radius: 10)
            .frame(maxWidth: 300)
        }
    }
}




struct CustomAlertTwoOptionView: View {
    @Binding var isPresented: Bool
    let message: String
    let confirmAction: () -> Void
    let cancelAction: () -> Void
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.4) // 배경 어두운색
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 20) {
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    HStack {
                        Button(action: {
                            cancelAction()
                            isPresented = false
                        }) {
                            Text("취소")
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.gray)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            confirmAction()
                            isPresented = false
                        }) {
                            Text("확인")
                                .bold()
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                    }
                }
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 10)
                .frame(width: 280) // 원하는 너비로 설정
                .padding(20) // 주변 여백을 위한 padding
            }
        }
    }
}
