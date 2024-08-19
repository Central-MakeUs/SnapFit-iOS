//
//  MyPageReservationInfoView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/18/24.
//

import SwiftUI

struct MyPageReservationInfoView: View {
    
    var mypageInteractor: MyPageBusinessLogic?
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @Binding var stack: NavigationPath
    
    @Environment(\.dismiss) var dismiss  // dismiss 환경 변수를 사용
    
    @State private var showSheet: Bool = false
    @State private var showAlert: Bool = false
    
//    enum Reason {
//        case contactIssue, wrongSelection
//    }
    
//    @State private var selectedReason: Reason? = nil
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
//                Group {
//                    
//                    InfoRow(label: "연락처", value: "snap@naver.com")
//                        .padding(.horizontal)
//                    
//                    
//                    InfoRow(label: "이메일", value: "snap@naver.com")
//                        .padding(.horizontal)
//                    
//                    CustomDividerView()
//                        .padding(.bottom)
//                }
                
                
                Group {
                    SectionHeaderView(title: "주문상품")
                        .padding(.bottom, 20)
                    
                    if let reservationDetails = myPageViewModel.reservationproductDetail {
                        ReservationDetailCardView(reservationDetails: reservationDetails)
                            .padding(.horizontal)
                            .padding(.bottom, 32)
                            .frame(height: 130) // Height fixed
                    }
                    
                    CustomDividerView()
                        .padding(.bottom)
                }
                
                Group {
                    SectionHeaderView(title: "예약내역")
                        .padding(.bottom, 20)
                    
                    if let details = myPageViewModel.reservationproductDetail {
                        VStack(alignment: .leading, spacing: 15) {
                            Group {
                                InfoRow(label: "옵션", value: "30분 스냅") // Update as necessary
                                InfoRow(label: "위치", value: details.reservationLocation)
                                InfoRow(label: "예약일시", value: formatDate(details.reservationTime))
                                InfoRow(label: "인원", value: "성인 \(details.person)명")
                                InfoRow(label: "이메일", value: "snap@naver.com") // Update as necessary
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray5))
                        //.cornerRadius(5)
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        Divider()
                            .padding(.bottom)
                    }
                }
                
                Group {
                    SectionHeaderView(title: "가격정보")
                        .padding(.bottom, 20)
                    
                    if let details = myPageViewModel.reservationproductDetail {
                        VStack(alignment: .leading, spacing: 8) {
                            InfoRow(label: "기본", value: "\(details.basePrice)원")
                            InfoRow(label: "인원 \(details.person)명", value: "\(details.personPrice)원")
                            Divider()
                                .padding(.bottom)
                            
                            InfoRow(label: "최종 결제액", value: "\(details.totalPrice)원")
                                .bold()
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 40)
                    }
                }
                
                Button(action: {
                    // 버튼 액션
                    showSheet.toggle()
                }) {
                    Text("예약취소")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.black)
                        .cornerRadius(5)
                }
                .padding(.horizontal)
            }
            .onAppear(perform: {
                // 상품 상세 조회
                if let selectedId = myPageViewModel.selectedReservationId {
                    mypageInteractor?.fetchReservationDetail(request: MainPromotion.CheckReservationDetailProduct.Request(selectedReservationId: selectedId))
                }
            })

            .padding(.vertical)
        }
        
//        .sheet(isPresented: $showSheet) {
//            ReservationSheetView(selectedReason: $selectedReason, showSheet: $showSheet, showAlert: $showAlert)
//                .padding(.horizontal)
//                .presentationDetents([.small, .large])
//        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("예약정보")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        .overlay(
            ZStack {
                if showAlert {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    CustomAlertView(isPresented: $showAlert, message: "예약이 취소되었습니다.") {
                        showAlert = false
                    }
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
                    // 해당 View를 화면의 정중앙에 위치
                }
            }
        )
    }
    
    // 날짜 포맷팅 함수
    private func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoDate) else { return "날짜 없음" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return displayFormatter.string(from: date)
    }
}




//
//struct ReservationInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ReservationInfoView()
//    }
//}
