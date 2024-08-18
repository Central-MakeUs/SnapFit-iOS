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
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @Binding var stack: NavigationPath
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 16) {
                    
                    // 예약된 상품 리스트를 보여줍니다.
                    ForEach(myPageViewModel.reservationproducts) { product in
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
                        // NavigationLink를 사용할 때 텍스트 색상이 파란색으로 바뀌는 것을 방지
                    }
                    
                
            }
            //.padding() // ScrollView에 여백 추가
        }
        .onAppear(perform: {
            // 예약 내역 불러오기
            mypageInteractor?.fetchUserReservations(request: MainPromotion.LoadMainPromotion.Request(limit: 10, offset: 0))
        })
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
                Text("예약내역")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}





