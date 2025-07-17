//
//  ReservationInfoView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/24/24.
//

import SwiftUI

struct ReservationInfoView: View {
    
    var productInteractor: ProductBusinessLogic?
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    @Binding var stack: NavigationPath
    
    @Environment(\.dismiss) var dismiss
    
    @State private var showSheet: Bool = false
    @State private var showAlert: Bool = false
    @State private var isMaker: Bool = false
    @State private var selectedReason: Reason? = nil
    @State private var cancelMessage: String = "" // 취소 메시지 저장
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                
                Group {
                    SectionHeaderView(title: "고객 연락처")
                        .padding(.bottom, 32)

                    if let details = mainPromotionViewModel.reservationproductDetail {
                        InfoRow(label: "이메일", value: details.email)
                            .padding(.horizontal)
                        InfoRow(label: "휴대폰 번호", value: details.phoneNumber)
                            .padding(.horizontal)
                    }
                    CustomDividerView()
                        .padding(.bottom)
                }
                
                Group {
                    SectionHeaderView(title: "주문상품")
                        .padding(.bottom, 20)
                    
                    if let reservationDetails = mainPromotionViewModel.reservationproductDetail {
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
                    
                    if let details = mainPromotionViewModel.reservationproductDetail {
                        VStack(alignment: .leading, spacing: 15) {
                            Group {
                                InfoRow(label: "옵션", value: "30분 스냅")
                                InfoRow(label: "위치", value: details.reservationLocation)
                                InfoRow(label: "예약일시", value: details.reservationTime)
                                    .fixedSize(horizontal: false, vertical: true) // 긴 텍스트 처리
                                InfoRow(label: "인원", value: "성인 \(details.person)명")
                            }
                            .padding()
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color(UIColor.systemGray5))
                        .padding(.horizontal)
                        .padding(.bottom)
                        
                        Divider()
                            .padding(.bottom)
                    }
                }
                
                Group {
                    SectionHeaderView(title: "가격정보")
                        .padding(.bottom, 20)
                    
                    if let details = mainPromotionViewModel.reservationproductDetail {
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
            .onAppear {
                if let selectedReservationId = mainPromotionViewModel.selectedReservationId {
                    DispatchQueue.main.async {
                        productInteractor?.fetchReservationDetail(request: MainPromotion.CheckReservationDetailProduct.Request(selectedReservationId: selectedReservationId))
                    }
                }
            }
            .padding(.bottom, 20)
        }
        
        .sheet(isPresented: $showSheet) {
            DeleteReservationSheetView(
                isPhotographer: false, 
                selectedReason: $selectedReason,
                showSheet: $showSheet,
                showAlert: $showAlert,
                onConfirm: { reason in
                    cancelMessage = reason
                    if let selectedId = mainPromotionViewModel.selectedReservationId {
                        productInteractor?.deleteReservation(request: MainPromotion.DeleteReservationProduct.Request(selectedReservationId: selectedId, message: cancelMessage))
                        showAlert = true
                    }
                }
            )
            .padding(.horizontal)
            .presentationDetents([.small, .large])
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                .hidden()
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
                        if !showAlert {
                            stack.removeLast()
                        }
                    }
                    .frame(width: 300)
                    .position(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 3)
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

// Sheet Size 더 작게 Custom
extension PresentationDetent {
    static let small = Self.height(348)
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color("LoginFontColor"))
            Spacer()
            Text(value)
                .foregroundColor(.black)
                .font(.subheadline)
                .bold()
        }
    }
}
