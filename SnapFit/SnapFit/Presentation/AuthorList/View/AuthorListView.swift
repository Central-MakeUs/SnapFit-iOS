//
//  AuthorListView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI


// View가 Presenter로부터 받는 정보를 정의하는 프로토콜
protocol AuthorListDisplayLogic {
    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel)
    func displayDetail(viewModel: MainPromotion.LoadDetailProduct.ViewModel)
    func displayDetailProductsForMaker(viewModel: MainPromotion.LoadDetailProduct.ProductsForMakerViewModel)
    func displayVibes(viewModel: MainPromotion.LoadMainPromotion.VibesPresentationViewModel)


    // MARK: - 상품 예약관련
    func displayReservationSuccess(viewModel: MainPromotion.ReservationProduct.ViewModel)
    func displayFetchUserReservation(viewModel: MainPromotion.CheckReservationProducts.ViewModel)
    func displayFetchUserReservationDetail(viewModel: MainPromotion.CheckReservationDetailProduct.ViewModel) 
    
}

extension AuthorListView: AuthorListDisplayLogic {

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
            //print("authorListViewModel.productDetail \( authorListViewModel.productDetail)")
        }
    }
    
    func displayDetailProductsForMaker(viewModel: MainPromotion.LoadDetailProduct.ProductsForMakerViewModel) {
        DispatchQueue.main.async {
            authorListViewModel.productDetailAuthorProducts = viewModel.products.data
            //print("authorListViewModel.productDetailAuthorProducts \( authorListViewModel.productDetailAuthorProducts)")
        }
    }
    
    
    // Presenter가 제공한 분위기 ViewModel을 기반으로 UI 업데이트
    func displayVibes(viewModel: MainPromotion.LoadMainPromotion.VibesPresentationViewModel) {
        DispatchQueue.main.async {
            // 분위기 상태 업데이트
            self.authorListViewModel.vibes = viewModel.vibes
            //print("authorListViewModel.vibes \(authorListViewModel.vibes)")
        }
    }
    
    
    // MARK: - 상품 예약관련
    
    // 예약이후 예약성공 상세화면에 값 전달
    func displayReservationSuccess(viewModel: MainPromotion.ReservationProduct.ViewModel) {
        DispatchQueue.main.async {
            self.authorListViewModel.reservationSuccess = viewModel.reservationSuccess
            self.authorListViewModel.reservationDetails = viewModel.reservationDetails
            print("authorListViewModel.reservationSuccess \(self.authorListViewModel.reservationSuccess)")
            print("authorListViewModel.reservationDetails \(self.authorListViewModel.reservationDetails)")
        }
    }
    
    
    // 유저 예약내역 리스트 조회
    func displayFetchUserReservation(viewModel: MainPromotion.CheckReservationProducts.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            authorListViewModel.reservationproducts = viewModel.reservationProducts?.data ?? []

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("authorListViewModel.reservationproducts: \(authorListViewModel.reservationproducts)")
        }
    }
    
    // 유저 예약내역 단일 조회
    func displayFetchUserReservationDetail(viewModel: MainPromotion.CheckReservationDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            authorListViewModel.reservationproductDetail = viewModel.reservationDetail

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("authorListViewModel.reservationproductDetail: \(authorListViewModel.reservationproductDetail)")
        }
    }
    
}


struct AuthorListView: View {
    @State private var selectedTab: Int = -1
    @State var stack = NavigationPath()

    // columns 의 갯수를 2개로 설정
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8, alignment: nil),
        GridItem(.flexible(), spacing: 8, alignment: nil),
    ]
    
    @Environment(\.presentationMode) var presentationMode // Environment variable to dismiss the view
    
    var authorListInteractor: AuthorListBusinessLogic?
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
                
                // CustomTopTabbar 사용
                CustomTopTabbar(selectedTab: $selectedTab, authorListInteractor: authorListInteractor, vibes: authorListViewModel.vibes)
                               .padding(.bottom)
                // 상품 탭의 내용
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(authorListViewModel.products) { product in
                            Button(action: {
                                DispatchQueue.main.async {
                                    authorListViewModel.selectedProductId = product.id
                                    stack.append("AuthorDetailView")
                                }
                            }) {
                                MiddleCardView(product: product, mainPromotionInteractor: authorListInteractor)
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
                // 💁 해당 전체 호출코드 필터값에서 전체 누를때만 분기 처리 필요 지금 서버에서 전체 값이 없음
                //authorListInteractor?.fetchProductAll(request : MainPromotion.LoadMainPromotion.Request(limit: 10, offset: 0))
                
                print(stack.count)
                stack = NavigationPath()
                
                authorListInteractor?.fetchVibes()
                
            }
            .navigationDestination(for: String.self) { viewName in
                switch viewName {
                case "AuthorDetailView":
                    AuthorDetailView(productInteractor: authorListInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(authorListViewModel)
                case "AuthorReservationView":
                    AuthorReservationView(productInteractor: authorListInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(authorListViewModel)
                case "AuthorReservationReceptionView" :
                    AuthorReservationReceptionView(stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(authorListViewModel)
                case "ReservationView" :
                    ReservationView(productInteractor: authorListInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(authorListViewModel)
                    
                case "ReservationInfoView" :
                    ReservationInfoView(productInteractor: authorListInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(authorListViewModel)
                    
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
