//
//  AuthorReservationReceptionView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/5/24.
//

import SwiftUI

struct AuthorReservationReceptionView: View {
    
    @Binding var stack: NavigationPath
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    
    private var reservationRequest: ReservationRequest? {
        mainPromotionViewModel.reservationRequest
    }
    
    var body: some View {
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
                    .padding(.horizontal, 16) // 좌우 여백 추가
                    
                    CustomDividerView()
                        .padding(.bottom, 32)
                    
                    ProductSection(mainPromotionViewModel: mainPromotionViewModel)
                        .padding(.bottom, 40)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Group {
                            InfoRow(label: "옵션", value: "\(reservationRequest?.minutes ?? 0)분")
                            InfoRow(label: "위치", value: reservationRequest?.reservationLocation ?? "정보 없음")
                            InfoRow(label: "예약일시", value: formatDate(reservationRequest?.reservationTime))
                            InfoRow(label: "인원", value: "\(reservationRequest?.person ?? 0)명")
                            InfoRow(label: "이메일", value: reservationRequest?.email ?? "정보 없음")
                            InfoRow(label: "휴대폰 번호", value: reservationRequest?.phoneNumber ?? "정보 없음")
                        }
                        .padding(.horizontal, 16)
                        
                    }
                    .padding(.bottom, 50)
                    
                    Button(action: {
                        stack.append("ReservationView")
                    }) {
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
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 10)
                    
                    Button(action: {
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
                        .padding(.horizontal, 16)
                    }
                    .padding(.bottom, 10)
                }
                .padding(.bottom, UIApplication.shared.windows.first?.safeAreaInsets.bottom)
                //   .padding(.bottom, geometry.safeAreaInsets.bottom) // 해당 코드가 문제
                .padding(.horizontal, 16) // 여기에 좌우 여백 추가
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    // Helper function to format date string
    private func formatDate(_ isoDateString: String?) -> String {
        guard let isoDateString = isoDateString,
              let date = ISO8601DateFormatter().date(from: isoDateString) else {
            return "정보 없음"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy.MM.dd(EEE) a h:mm"
        return dateFormatter.string(from: date)
    }
}

