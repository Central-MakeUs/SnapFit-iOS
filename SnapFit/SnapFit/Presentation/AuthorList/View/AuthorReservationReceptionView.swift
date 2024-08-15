//
//  AuthorReservationReceptionView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/5/24.
//

import SwiftUI
import SwiftUI

struct AuthorReservationReceptionView: View {
    
    @Binding var stack : NavigationPath
    @State private var selectedTab: Int = 0

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading, spacing: 0) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            Text("예약이 접수되었습니다.")
                                .font(.title)
                                .bold()
                                .padding(.top, 24)
                                .padding(.bottom, 24)
                            Text("적어주신 연락처로\n작가가 연락드릴 예정입니다.")
                                .font(.callout)
                                .foregroundColor(Color(.systemGray))
                                .padding(.bottom, 48)
                        }
                        .padding(.horizontal)
                        
                        CustomDividerView()
                            .padding(.bottom, 32)
                        
                        ProductSection()
                            .padding(.bottom, 40)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            Group {
                                InfoRow(label: "옵션", value: "30분 스냅")
                                InfoRow(label: "위치", value: "홍대")
                                InfoRow(label: "예약일시", value: "24.02.22(목) 오후 5:00")
                                InfoRow(label: "인원", value: "성인 1명")
                                InfoRow(label: "이메일", value: "snap@naver.com")
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 50)
                        
                        NavigationLink(destination: ReservationView().navigationBarBackButtonHidden(true)) {
                            HStack(spacing: 20) {
                                Spacer()
                                Text("예약내역 보러가기")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .frame(height: 48)
                            .background(Color.black)
                            .cornerRadius(5)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
                        }
                        
                        
                        Button(action: {
                            // 모든 항목을 제거하고 스택을 새로 초기화하여 홈으로 돌아가기
                            print("stack.count \(stack.count)")
                            //stack.append("SnapFitTabView")
                            stack = NavigationPath()
                           
                        }) {
                      
                            HStack(spacing: 20) {
                                Spacer()
                                Text("홈으로 돌아가기")
                                    .font(.headline)
                                    .bold()
                                    .foregroundColor(.white)
                                Spacer()
                            }
                            .padding()
                            .frame(height: 48)
                            .background(Color.black)
                            .cornerRadius(5)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
                        }
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom) // 안전 영역을 고려하여 여백 추가
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


#Preview {
    // Preview를 위한 NavigationPath 초기화
    let path = NavigationPath()
    
    return AuthorReservationReceptionView(stack: .constant(path))
}
