//
//  ReservationConfirmView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct ReservationConfirmView: View {
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    @State private var showSheet: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertCancelAction: () -> Void = {}
    enum Reason {
        case contactIssue, wrongSelection
    }
    @State private var selectedReason: Reason? = nil
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                ReservationSection()
                OrderProductSection()
                ReservationDetailsSection()
                PriceInfoSection()
                    .padding(.bottom)
                CancelButton(showSheet: $showSheet)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showSheet) {
            ReservationConfirmSheetView(selectedReason: $selectedReason, showSheet: $showSheet, showAlert: $showAlert)
                .padding(.horizontal)
                .presentationDetents([.small, .large])
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
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
                }
            }
        )
    }
}

struct ReservationSection: View {
    var body: some View {
        Group {
            SectionHeaderView(title: "신청인")
                .padding(.bottom, 10)
            VStack(spacing: 10) {
                InfoRow(label: "이름", value: "냠냠냠")
                InfoRow(label: "이메일", value: "snap@naver.com")
                InfoRow(label: "예약날짜", value: "7월 8일 오후 3시")
            }
            .padding(.horizontal)
            CustomDividerView()
                .padding(.bottom)
        }
    }
}

struct OrderProductSection: View {
    var body: some View {
        Group {
            SectionHeaderView(title: "주문상품")
                .padding(.bottom, 10)
            //ReservationCardView()
            //    .frame(maxWidth: .infinity, minHeight: 130)
            //    .padding(.horizontal)
            CustomDividerView()
                .padding(.bottom)
        }
    }
}

struct ReservationDetailsSection: View {
    var body: some View {
        Group {
            SectionHeaderView(title: "예약내역")
                .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 15) {
                InfoRow(label: "옵션", value: "30분 스냅")
                InfoRow(label: "위치", value: "홍대")
                InfoRow(label: "예약일시", value: "24.02.22(목) 오후 5:00")
                InfoRow(label: "인원", value: "성인 1명")
            }
            .frame(maxWidth: .infinity, minHeight: 184)
            .padding(.horizontal)
            .background(Color(UIColor.systemGray5))
            .cornerRadius(5)
            .padding(.bottom)
            .padding(.horizontal)
        }
    }
}

struct PriceInfoSection: View {
    var body: some View {
        Group {
            SectionHeaderView(title: "가격정보")
                .padding(.bottom, 10)
            VStack(alignment: .leading, spacing: 8) {
                InfoRow(label: "기본", value: "32,400원")
                InfoRow(label: "인원 1명", value: "0원")
                Divider()
                    .padding(.bottom)
                InfoRow(label: "최종 결제액", value: "32,400원")
                    .bold()
            }
            .padding(.horizontal)
        }
    }
}

struct CancelButton: View {
    @Binding var showSheet: Bool
    
    var body: some View {
        Button(action: {
            showSheet.toggle()
        }) {
            Text("예약취소")
                .font(.subheadline)
                .bold()
                .foregroundColor(Color.white)
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 48)
                .background(Color.black)
                .cornerRadius(5)
        }
        .padding(.horizontal)
    }
}

#Preview {
    ReservationConfirmView()
}
