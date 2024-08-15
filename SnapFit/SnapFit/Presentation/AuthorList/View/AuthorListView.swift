//
//  AuthorListView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI

extension AuthorListView: MainPromotionDisplayLogic {
    
    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel) {
        DispatchQueue.main.async {
            authorListViewModel.products = viewModel.products.data
            //print("viewModel.products.data \(viewModel.products.data)")
            print("authorListViewModel.products \( authorListViewModel.products)")
        }
    }
    
    func displayDetail(viewModel: MainPromotion.LoadDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            authorListViewModel.productDetail = viewModel.productDetail
            print("authorListViewModel.productDetail \( authorListViewModel.productDetail)")
        }
    }
}


struct AuthorListView: View {
    @State private var selectedTab: Int = 0
    @State var stack = NavigationPath()

    // columns 의 갯수를 2개로 설정
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil),
    ]
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    @ObservedObject var authorListViewModel: MainPromotionViewModel
    
    var body: some View {
        NavigationStack(path: $stack) {
            VStack{
                HStack {
                    Image("mainSnapFitLogo")
                        .resizable()
                        .frame(width: 91.18, height: 20)
                    Spacer()
                }
                .padding(.horizontal)
                
                CustomTopTabbar()
                    .padding(.bottom)
                // 상품 탭의 내용
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(authorListViewModel.products) { product in
                            Button(action: {
                                authorListViewModel.selectedProductId = product.id
                                stack.append("AuthorDetailView")
                            }) {
                                MiddleCardView(product: product)
                                    .frame(width: 175, height: 324)
                                    .padding(EdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2))
                            }
                            .buttonStyle(PlainButtonStyle())  // 기본 스타일 제거
                            // NavigationLink를 사용할 때 텍스트 색상이 파란색으로 바뀌는 것을 방지
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom)
                
            }
            .onAppear {
                mainPromotionInteractor?.fetchProductAll(request : MainPromotion.LoadMainPromotion.Request(limit: 10, offset: 0))
                
                print(stack.count)
                stack = NavigationPath()
   
            }
            .navigationDestination(for: String.self) { viewName in
                switch viewName {
                case "AuthorDetailView":
                    AuthorDetailView(mainPromotionInteractor: mainPromotionInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(authorListViewModel)
                case "AuthorReservationView":
                    AuthorReservationView(stack: $stack)
                        .navigationBarBackButtonHidden(true)
                case "AuthorReservationReceptionView" :
                    AuthorReservationReceptionView(stack: $stack)
                        .navigationBarBackButtonHidden(true)
                default:
                    SnapFitTabView()
                }
            }
            
        }
    }
}

#Preview {
    AuthorListView(authorListViewModel: MainPromotionViewModel())
}
