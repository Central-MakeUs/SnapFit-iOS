//
//  AuthorReservationReceptionView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/5/24.
//

import SwiftUI

struct AuthorReservationReceptionView: View {
    @EnvironmentObject var navigationModel: NavigationModel // EnvironmentObject로 NavigationModel을 사용
    @State private var selectedTab: Int = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    
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
                    .frame(width: .infinity, height: 196)
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
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 10, trailing: 20))
                    }
                    
                    Button(action: {
                        // 네비게이션 스택을 초기화하여 홈으로 돌아가기
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            navigationModel.resetNavigation()
                        }
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
                        .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                    }
                }
            }
            .padding(.bottom)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    AuthorReservationReceptionView()
        .environmentObject(NavigationModel()) // Preview에서 환경 객체를 설정
}
