//
//  MyPageReservationView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/18/24.
//
import SwiftUI

struct MyPageReservationView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.dismiss) var dismiss
    var mypageInteractor: MyPageBusinessLogic?
    @ObservedObject var myPageViewModel: MyPageViewModel
    @Binding var stack: NavigationPath
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 16) {
                    
                    // 예약된 상품 리스트를 id로 정렬하여 보여줍니다.
                    ForEach(myPageViewModel.reservationproducts.sorted(by: {
                        ($0.id ?? Int.min) < ($1.id ?? Int.min)
                    })) { product in
                        Button(action: {
                            myPageViewModel.selectedReservationId = product.id
                            stack.append("ReservationInfoView")
                        }) {
                            VStack(spacing: 0) { // 카드뷰와 구분선 사이 간격 0
                                ReservationInfoCardView(productInfo: product)
                                    .frame(width: 358, height: 130)
                                    .padding(.bottom, 22)
                                
                                Divider() // 카드뷰 아래에 구분선 추가
                                    .background(Color.gray.opacity(0.3)) // 구분선 색상
                            }
                        }
                        .buttonStyle(PlainButtonStyle())  // 기본 스타일 제거
                    }
                    
                
            }
        }
        .onAppear(perform: {
            // 예약 내역 불러오기
            mypageInteractor?.fetchUserReservations(request: MainPromotionUseCase.LoadMainPromotion.Request(limit: 30, offset: 0))
        })
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
                Text("예약내역")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}
