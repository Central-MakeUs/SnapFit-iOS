//
//  ReservationInfoView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/24/24.
//

import SwiftUI

struct ReservationInfoView: View {
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    @State private var showSheet: Bool = false
    @State private var showAlert: Bool = false
    
    enum Reason {
        case contactIssue, wrongSelection
    }
    @State private var selectedReason: Reason? = nil
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("연락처")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                
                InfoRow(label: "이메일", value: "snap@naver.com")
                
                CustomDividerView()
                    .padding(.bottom)
                
                Text("주문상품")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                ReservationCardView()
                    .frame(width: 358, height: 130)
                
                CustomDividerView()
                    .padding(.bottom)
                
                Text("예약내역")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 15) {
                    Group {
                        InfoRow(label: "옵션", value: "30분 스냅")
                        InfoRow(label: "위치", value: "홍대")
                        InfoRow(label: "예약일시", value: "24.02.22(목) 오후 5:00")
                        InfoRow(label: "인원", value: "성인 1명")
                    }
                    .padding(.horizontal)
                }
                .frame(width: 358, height: 184)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(5)
                .padding(.bottom)
                
                Divider()
                    .padding(.bottom)
                
                Text("가격정보")
                    .font(.title3)
                    .bold()
                    .padding(.bottom)
                
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(label: "기본", value: "32,400원")
                    InfoRow(label: "인원 1명", value: "0원")
                    Divider()
                        .padding(.bottom)
                    
                    InfoRow(label: "최종 결제액", value: "32,400원")
                        .bold()
                }
                .padding(.bottom)
                
                Button(action: {
                    // 버튼 액션
                    showSheet.toggle()
                }) {
                    Text("예약취소")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(Color.white)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 65)
                        .background(Color.black)
                        .cornerRadius(5)
                }
             
                
            }
            .padding()
        }
        
        .sheet(isPresented: $showSheet) {
            
            ReservationSheetView(selectedReason: $selectedReason, showSheet: $showSheet, showAlert: $showAlert)
            .padding(.horizontal)
            // iOS 16 Custom Size
            // 처음 small
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
                    // 해당 View를 화면의 정중앙에 위치
                }
            }
        )
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
                .font(.callout)
            Spacer()
            Text(value)
                .foregroundColor(.black)
                .font(.callout)
                .bold()
        }
    }
}

struct CustomDividerView: View {
    var body: some View {
        Rectangle()
            .fill(Color(UIColor.systemGray6))
            .frame(height: 5)
            .edgesIgnoringSafeArea(.horizontal)
    }
}



struct ReservationInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ReservationInfoView()
    }
}
