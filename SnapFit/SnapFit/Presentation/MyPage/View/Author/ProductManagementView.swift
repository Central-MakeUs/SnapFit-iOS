//
//  ProductManagementView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/25/24.
//

import SwiftUI

struct ProductManagementView: View {
    
    
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
    
    var body: some View {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("등록된 상품")
                            .font(.title3)
                            .bold()
                            .padding(.bottom)
                        
                        // 상품 목록을 그리드로 표시
                        LazyVGrid(columns: columns, spacing: 20) {
                            if let products = myPageViewModel.makerProductlist?.data {
                                ForEach(products.sorted(by: { $0.id ?? 0 < $1.id ?? 0 })) { product in
                                    Button(action: {
                                        handleProductSelection(product)
                                    }) {
                                        MakerMiddleCardView(product: product, mypageInteractor: mypageInteractor)
                                            .frame(width: 175, height: 324)
                                            .padding(2)
                                    }
                                    .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일 제거
                                }
                            } else {
                                // 데이터를 로딩 중일 때나 빈 데이터일 때의 Placeholder
                                Text("등록된 상품이 없습니다.")
                                    .font(.body)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.bottom)
                    }
                    .padding(.horizontal) // 좌우 여백을 추가하여 전체 뷰의 여백을 조정
                }
            
            // Save Button as footer
            Button(action: {
                //myPageViewModel.selectedReservationId = product.id
                stack.append("ProductRegistrationView")
            }) {
                Text("상품 등록하기")
                    .font(.headline)
                    .bold()
                    .foregroundColor(Color.white)
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: 48)
                    .background(Color.black)
                    .cornerRadius(5)
                    .padding(.horizontal)
                    .padding(.bottom, 20) // 추가 여백
            }
            .buttonStyle(PlainButtonStyle())  // 기본 스타일 제거
        }
        .onAppear(perform: {
            // 예약 내역 불러오기
            DispatchQueue.main.async {
                mypageInteractor?.fetchMakerPosts(request: MakerUseCases.LoadProducts.ProductsForMakerRequest(makerid: myPageViewModel.userDetails?.id ?? 0, limit: 30, offset: 0))
            }
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    stack.removeLast()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("상품관리")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
    
    // 상품 선택 처리
    private func handleProductSelection(_ product: PostDetail) {
        DispatchQueue.main.async {
            myPageViewModel.selectedProductId = product.id
            //stack.append("AuthorDetailView")
        }
    }

    
}

//#Preview {
//    ProductManagementView()
//}
