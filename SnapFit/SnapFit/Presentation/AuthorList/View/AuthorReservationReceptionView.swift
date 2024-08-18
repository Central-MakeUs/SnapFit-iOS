//
//  AuthorReservationReceptionView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/5/24.
//

import SwiftUI


struct AuthorReservationReceptionView: View {
    
    @Binding var stack: NavigationPath
    @EnvironmentObject var mainPromotionViewModel: MainPromotionViewModel
    
    private var reservationRequest: ReservationRequest? {
        mainPromotionViewModel.reservationRequest
    }
    
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
                                InfoRow(label: "옵션", value: "\(reservationRequest?.minutes ?? 0)분")
                                InfoRow(label: "위치", value: reservationRequest?.reservationLocation ?? "정보 없음")
                                InfoRow(label: "예약일시", value: formatDate(reservationRequest?.reservationTime))
                                InfoRow(label: "인원", value: "\(reservationRequest?.person ?? 0)명")
                                InfoRow(label: "이메일", value: reservationRequest?.email ?? "정보 없음")
                            }
                            .padding(.horizontal)
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
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 10, trailing: 16))
                        }
                        
                        Button(action: {
                            // 모든 항목을 제거하고 스택을 새로 초기화하여 홈으로 돌아가기
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


struct AuthorReservationReceptionView_Previews: PreviewProvider {
    static var previews: some View {
        AuthorReservationReceptionView(stack: .constant(NavigationPath()))
            .environmentObject(MainPromotionViewModel()) // Preview에서 뷰 모델을 주입합니다.
    }
}
