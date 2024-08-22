//
//  DibsView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct DibsView: View {
    
    var mypageInteractor: MyPageBusinessLogic?
    @EnvironmentObject var myPageViewModel: MyPageViewModel
    @Binding var stack: NavigationPath
    
    
    
    // columns 의 갯수를 2개로 설정
    let columns: [GridItem] = [
        //GridItem을 담을 수 있는 배열 생성
        // .flexible : 크기를 화면 프레임에 유연하게 늘렸다 줄었다 할 수 있게 설정
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.dismiss) var dismiss  // dismiss 환경 변수를 사용
    
    var body: some View {
        VStack{
            
            
            
            // 상품 탭의 내용
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(myPageViewModel.likeProducts) { product in
                        Button(action: {
                            myPageViewModel.selectedReservationId = product.id
                            stack.append("ReservationInfoView")
                        }) {
                            VStack(spacing: 0) { // 카드뷰와 구분선 사이 간격 0
                                DibsMiddleCardView(product: product, mainPromotionInteractor: mypageInteractor)
                                    .frame(width: 174, height: 322)
                                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())  // 기본 스타일 제거
                    }
                }
            
                
                
            }
            .padding(.horizontal)
            .padding(.bottom)
            
        }
        .onAppear(perform: {
            // 예약 내역 불러오기
            mypageInteractor?.fetchUserLikes(request: MainPromotion.Like.LikeListRequest(limit: 30, offset: 0))
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()  // 뒤로가기 버튼 클릭 시 dismiss 호출
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("찜한내역")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}

struct DibsEmptyView: View {
    var body: some View {
        VStack(alignment: .center ,spacing: 15){
            
            Image("EmptyLogo")
                .resizable()
                .frame(width: 30, height: 47)
            
            Text("상품을 찜해보세요!")
                .bold()
            
            Text("찜한 상품이 없습니다.")
                .foregroundStyle(Color(.systemGray))
        }
    }
}

//#Preview {
//    DibsView()
//}

#Preview {
    DibsEmptyView()
}
