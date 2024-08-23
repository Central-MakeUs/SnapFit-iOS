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
    
    @Environment(\.dismiss) var dismiss  // dismiss 환경 변수를 사용
    
    var body: some View {
        VStack {
            // 상품 탭의 내용
            GeometryReader { geometry in
                let spacing: CGFloat = geometry.size.width * 0.02 // 화면 크기에 따른 간격 계산
                let itemWidth: CGFloat = (geometry.size.width - (spacing * 3)) / 2 // 그리드의 카드 너비 계산

                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: [
                        GridItem(.flexible(), spacing: spacing),
                        GridItem(.flexible(), spacing: spacing)
                    ], spacing: spacing) {
                        ForEach(myPageViewModel.likeProducts) { product in
                            Button(action: {
                                myPageViewModel.selectedProductId = product.id
                                stack.append("MyPageAuthorDetailView")
                            }) {
                                VStack(spacing: 0) {
                                    DibsMiddleCardView(product: product, mainPromotionInteractor: mypageInteractor)
                                        .frame(width: itemWidth, height: itemWidth * 1.85) // 카드의 비율 조정
                                        .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                                }
                            }
                            .buttonStyle(PlainButtonStyle())  // 기본 스타일 제거
                        }
                    }
                    .padding(.horizontal, spacing) // 좌우 패딩을 간격과 맞춰 조정
                    .padding(.bottom)
                }
            }
        }
    
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
