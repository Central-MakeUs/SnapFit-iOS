//
//  AuthorListView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI


// View가 Presenter로부터 받는 정보를 정의하는 프로토콜
protocol AuthorListDisplayLogic {
    func display(viewModel: MainPromotionUseCase.LoadMainPromotion.ViewModel)
    func displayDetail(viewModel: MainPromotionUseCase.LoadDetailProduct.ViewModel)
    func displayDetailProductsForMaker(viewModel: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel)
    func displayVibes(viewModel: MainPromotionUseCase.LoadMainPromotion.VibesPresentationViewModel)
    
    
    // MARK: - 상품 예약관련
    func displayReservationSuccess(viewModel: MainPromotionUseCase.ReservationProduct.ViewModel)
    func displayFetchUserReservation(viewModel: MainPromotionUseCase.CheckReservationProducts.ViewModel)
    func displayFetchUserReservationDetail(viewModel: MainPromotionUseCase.CheckReservationDetailProduct.ViewModel)
    func displayDeleteUserReservation(viewModel: MainPromotionUseCase.DeleteReservationProduct.ViewModel)
}

extension AuthorListView: AuthorListDisplayLogic {
    
    func display(viewModel: MainPromotionUseCase.LoadMainPromotion.ViewModel) {
        DispatchQueue.main.async {
            authorListViewModel.products = viewModel.products.data
            //print("viewModel.products.data \(viewModel.products.data)")
            print("authorListViewModel.products \( authorListViewModel.products)")
        }
    }
    
    func displayDetail(viewModel: MainPromotionUseCase.LoadDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            authorListViewModel.productDetail = viewModel.productDetail
            //print("authorListViewModel.productDetail \( authorListViewModel.productDetail)")
        }
    }
    
    func displayDetailProductsForMaker(viewModel: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel) {
        DispatchQueue.main.async {
            authorListViewModel.productDetailAuthorProducts = viewModel.products.data
            //print("authorListViewModel.productDetailAuthorProducts \( authorListViewModel.productDetailAuthorProducts)")
        }
    }
    
    
    // Presenter가 제공한 분위기 ViewModel을 기반으로 UI 업데이트
    func displayVibes(viewModel: MainPromotionUseCase.LoadMainPromotion.VibesPresentationViewModel) {
        DispatchQueue.main.async {
            // 분위기 상태 업데이트
            self.authorListViewModel.vibes = viewModel.vibes
            //print("authorListViewModel.vibes \(authorListViewModel.vibes)")
        }
    }
    
    
    // MARK: - 상품 예약관련
    
    // 예약이후 예약성공 상세화면에 값 전달
    func displayReservationSuccess(viewModel: MainPromotionUseCase.ReservationProduct.ViewModel) {
        DispatchQueue.main.async {
            self.authorListViewModel.reservationSuccess = viewModel.reservationSuccess
            self.authorListViewModel.reservationDetails = viewModel.reservationDetails
            print("authorListViewModel.reservationSuccess \(self.authorListViewModel.reservationSuccess)")
            print("authorListViewModel.reservationDetails \(self.authorListViewModel.reservationDetails)")
        }
    }
    
    
    // 유저 예약내역 리스트 조회
    func displayFetchUserReservation(viewModel: MainPromotionUseCase.CheckReservationProducts.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            authorListViewModel.reservationproducts = viewModel.reservationProducts?.data ?? []
            
            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("authorListViewModel.reservationproducts: \(authorListViewModel.reservationproducts)")
        }
    }
    
    // 유저 예약내역 단일 조회
    func displayFetchUserReservationDetail(viewModel: MainPromotionUseCase.CheckReservationDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            authorListViewModel.reservationproductDetail = viewModel.reservationDetail
            
            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("authorListViewModel.reservationproductDetail: \(authorListViewModel.reservationproductDetail)")
        }
    }
    
    // 유저 예약 삭제
    func displayDeleteUserReservation(viewModel: MainPromotionUseCase.DeleteReservationProduct.ViewModel) {
        DispatchQueue.main.async {
            authorListViewModel.deleteReservationSuccess = viewModel.deleteReservationSuccess
            print("authorListViewModel.deleteReservationSuccess \(authorListViewModel.deleteReservationSuccess)")
        }
    }
    
    
}



struct AuthorListView: View {
    @State private var selectedTab: Int = -1
    @State private var stack = NavigationPath()
    
    // 두 개의 열을 가진 그리드 설정
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8),
    ]
    
    @Environment(\.presentationMode) var presentationMode // 뷰를 닫기 위한 환경 변수
    
    var authorListInteractor: AuthorListBusinessLogic?
    @ObservedObject var authorListViewModel: MainPromotionViewModel
    
    var body: some View {
        NavigationStack(path: $stack) {
            GeometryReader { geometry in
                let spacing: CGFloat = geometry.size.width * 0.02 // 화면 크기에 따른 간격 계산
                let itemWidth: CGFloat = (geometry.size.width - (spacing * 3)) / 2 // 그리드의 카드 너비 계산
                
                VStack {
                    HStack {
                        Image("mainSnapFitLogo")
                            .resizable()
                            .frame(width: 91.18, height: 20)
                        Spacer()
                    }
                    .padding(.horizontal)
                    
                    CustomTopTabbar(selectedTab: $selectedTab, authorListInteractor: authorListInteractor, vibes:  Array(authorListViewModel.vibes.reversed()))
                        .padding(.bottom)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        LazyVGrid(columns: [
                            GridItem(.flexible(), spacing: spacing),
                            GridItem(.flexible(), spacing: spacing)
                        ], spacing: spacing) {
                            ForEach($authorListViewModel.products.sorted(by: { $0.id < $1.id })) { $product in
                                Button(action: {
                                    handleProductSelection(product)
                                }) {
                                    MiddleCardView(isLiked: Binding(
                                        get: { product.like ?? false },
                                        set: { newValue in
                                            if let index = authorListViewModel.products.firstIndex(where: { $0.id == product.id }) {
                                                authorListViewModel.products[index].like = newValue
                                            }
                                        }
                                    ), product: product, mainPromotionInteractor: authorListInteractor)
                                    
                                        .frame(width: itemWidth, height: itemWidth * 1.65) // 카드의 비율 조정
                                        .padding(2)
                                }
                                .buttonStyle(PlainButtonStyle())  // 기본 버튼 스타일 제거
                            }
                        }
                    }
                    .padding(.horizontal, spacing) // 좌우 패딩을 간격과 맞춰 조정
                    .padding(.bottom)
                }
                .onAppear {
                    loadInitialData()
                }
                .navigationDestination(for: String.self) { viewName in
                    navigateToView(viewName)
                }
            }
        }
    }
    // 상품 선택 처리
    private func handleProductSelection(_ product: ProductInfo) {
        DispatchQueue.main.async {
            authorListViewModel.selectedProductId = product.id
            stack.append("AuthorDetailView")
        }
    }
    
    // 초기 데이터 로딩
    private func loadInitialData() {
        authorListInteractor?.fetchVibes()
    }
    
    // 네비게이션 처리
    private func navigateToView(_ viewName: String) -> some View {
        switch viewName {
        case "AuthorDetailView":
            return AnyView(AuthorDetailView(mainPromotionViewModel: authorListViewModel, productInteractor: authorListInteractor, stack: $stack))
            
        case "AuthorReservationView":
            return AnyView(AuthorReservationView(mainPromotionViewModel: authorListViewModel, productInteractor: authorListInteractor, stack: $stack))
            
        case "AuthorReservationReceptionView":
            return AnyView(AuthorReservationReceptionView(stack: $stack, mainPromotionViewModel: authorListViewModel))
       
        case "ReservationView":
            return AnyView(ReservationView(productInteractor: authorListInteractor, mainPromotionViewModel: authorListViewModel, stack: $stack))
          
        case "ReservationInfoView":
            return AnyView(ReservationInfoView(productInteractor: authorListInteractor, mainPromotionViewModel: authorListViewModel, stack: $stack))
           
        default:
            return AnyView(EmptyView())
        }
    }
}


