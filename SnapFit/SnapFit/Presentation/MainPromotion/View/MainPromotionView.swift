//
//  MainPromotionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//
import SwiftUI

protocol MainPromotionDisplayLogic {
    
    
    // MARK: - 사용자 조회관련
    func displayUserDetails(viewModel: LoadUserUseCase.ViewModel)
    
    
    // MARK: - 상품 조회관련
    func display(viewModel: MainPromotionUseCase.LoadMainPromotion.ViewModel) // 유즈케이스 수정필요
    func displayDetail(viewModel: MainPromotionUseCase.LoadDetailProduct.ViewModel) // 유즈케이스 수정필요
    func displayDetailProductsForMaker(viewModel: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel)
    func displayVibes(viewModel: MainPromotionUseCase.LoadMainPromotion.VibesPresentationViewModel)
    
    // MARK: - 상품 예약관련
    func displayReservationSuccess(viewModel: MainPromotionUseCase.ReservationProduct.ViewModel)
    func displayFetchUserReservation(viewModel: MainPromotionUseCase.CheckReservationProducts.ViewModel)
    func displayFetchUserReservationDetail(viewModel: MainPromotionUseCase.CheckReservationDetailProduct.ViewModel)
    func displayDeleteUserReservation(viewModel: MainPromotionUseCase.DeleteReservationProduct.ViewModel)
    
}

extension MainPromotionView: MainPromotionDisplayLogic {
    
    func displayUserDetails(viewModel: LoadUserUseCase.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.userDetails = viewModel.userDetails
            print("mainPromotionViewModel.userDetails \( mainPromotionViewModel.userDetails)")
        }
    }

    func display(viewModel: MainPromotionUseCase.LoadMainPromotion.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.products = viewModel.products.data
            print("viewModel.products.data \(viewModel.products.data)")
            //print("mainPromotionViewModel.products \( mainPromotionViewModel.products)")
        }
    }
    
    // 상품 들어가고 나서 보여지는 정보
    func displayDetail(viewModel: MainPromotionUseCase.LoadDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.productDetail = viewModel.productDetail
            //print("mainPromotionViewModel.productDetail \( mainPromotionViewModel.productDetail)")
        }
    }
    
    func displayDetailProductsForMaker(viewModel: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.productDetailAuthorProducts = viewModel.products.data
            print("작가가 등록한 상품 \( mainPromotionViewModel.productDetailAuthorProducts)")
        }
    }
    
    func displayVibes(viewModel: MainPromotionUseCase.LoadMainPromotion.VibesPresentationViewModel) {
        print()
    }
    
    // MARK: - 상품 예약관련
    
    // 예약이후 예약성공 상세화면에 값 전달
    func displayReservationSuccess(viewModel: MainPromotionUseCase.ReservationProduct.ViewModel) {
        DispatchQueue.main.async {
            self.mainPromotionViewModel.reservationSuccess = viewModel.reservationSuccess
            self.mainPromotionViewModel.reservationDetails = viewModel.reservationDetails
            //print("mainPromotionViewModel.reservationSuccess \(self.mainPromotionViewModel.reservationSuccess)")
            //print("mainPromotionViewModel.reservationDetails \(self.mainPromotionViewModel.reservationDetails)")
        }
    }
    
    
    // 유저 예약내역 리스트 조회
    func displayFetchUserReservation(viewModel: MainPromotionUseCase.CheckReservationProducts.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화 후 id로 정렬
            mainPromotionViewModel.reservationproducts = (viewModel.reservationProducts?.data ?? []).sorted(by: {
                ($0.id ?? Int.min) < ($1.id ?? Int.min)
            })

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("mainPromotionViewModel.reservationproducts: \(mainPromotionViewModel.reservationproducts)")
        }
    }

    
    
    func displayFetchUserReservationDetail(viewModel: MainPromotionUseCase.CheckReservationDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            mainPromotionViewModel.reservationproductDetail = viewModel.reservationDetail

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("mainPromotionViewModel.reservationproductDetail: \(mainPromotionViewModel.reservationproductDetail)")
        }
    }
    
    // 유저 예약 삭제
    func displayDeleteUserReservation(viewModel: MainPromotionUseCase.DeleteReservationProduct.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.deleteReservationSuccess = viewModel.deleteReservationSuccess
            print("mainPromotionViewModel.deleteReservationSuccess \(mainPromotionViewModel.deleteReservationSuccess)")
        }
    }
    
    
    
}


struct MainPromotionView: View {
    @State var stack = NavigationPath()
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    
    @State private var isLiked: Bool = false // 좋아요 상태를 관리할 변수 추가
    @State private var hasDataLoaded: Bool = false // 데이터 로드 여부를 추적하는 변수 추가
    
    var randomProduct: ProductInfo? {
        guard !mainPromotionViewModel.products.isEmpty else { return nil }
        return mainPromotionViewModel.products.randomElement()
    }

    var body: some View {
        NavigationStack(path: $stack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    HeaderView(mainPromotionViewModel: mainPromotionViewModel)
                        .padding(.bottom, 30)
                    
                    HStack {
                        SectionHeaderView(title: "이런 사진은 어때요?")
                        
                        Spacer()
                        
                        Image("mainHeaderIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding(.trailing, 16)
                    }
                    .padding(.bottom, 16)
                    
                    if let randomProduct = randomProduct {
                        Button(action: {
                            mainPromotionViewModel.selectedProductId = randomProduct.id
                            isLiked = randomProduct.like ?? false // 좋아요 상태 업데이트
                            DispatchQueue.main.async {
                                stack.append("AuthorDetailView")
                            }
                        }) {
                            MainPromotionRandomCardView(isLiked: Binding(
                                get: { randomProduct.like ?? false },
                                set: { newValue in
                                    if let index = mainPromotionViewModel.products.firstIndex(where: { $0.id == randomProduct.id }) {
                                        mainPromotionViewModel.products[index].like = newValue
                                    }
                                }
                            ), product: randomProduct, mainPromotionInteractor: mainPromotionInteractor)
                                .padding(.bottom, 16)
                        }
                        .buttonStyle(PlainButtonStyle())
                       
                    }
                    
                    SectionMiniCardsView(mainPromotionViewModel: mainPromotionViewModel, mainPromotionInteractor: mainPromotionInteractor, stack: $stack)
                        .padding(.bottom, 40)
                    
                    SectionHeaderView(title: "메이커와 소중한 추억을 만들어보세요")
                        .padding(.bottom, 16)
                    
                    SectionBigCardsView(mainPromotionViewModel: mainPromotionViewModel, stack: $stack)
                        .padding(.bottom, 40)
                }
                .environmentObject(mainPromotionViewModel)
            }
            .onAppear {
                // 데이터를 한 번만 로드하도록 방어
                if !hasDataLoaded {
                    performDataFetch()
                    hasDataLoaded = true
                }
            }
            .refreshable {
                // 스크롤 당겨서 새로고침 시 호출되는 메서드
                performDataFetch()
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: String.self) { viewName in
                switch viewName {
                case "AuthorDetailView":
                    AuthorDetailView(mainPromotionViewModel: mainPromotionViewModel, productInteractor: mainPromotionInteractor, stack: $stack)
                  
              
                case "AuthorReservationView":
                    AuthorReservationView(mainPromotionViewModel: mainPromotionViewModel, productInteractor: mainPromotionInteractor, stack: $stack)
                  
                case "AuthorReservationReceptionView":
                    AuthorReservationReceptionView(stack: $stack, mainPromotionViewModel: mainPromotionViewModel)
                   
                       
                case "ReservationView":
                    ReservationView(productInteractor: mainPromotionInteractor, mainPromotionViewModel: mainPromotionViewModel, stack: $stack)
                       
                       
                case "ReservationInfoView":
                    ReservationInfoView(productInteractor: mainPromotionInteractor, mainPromotionViewModel: mainPromotionViewModel, stack: $stack)
                      
                       
                default:
                    //SnapFitTabView()
                    EmptyView()
                }
            }
            
        }
    }

    func performDataFetch() {
        DispatchQueue.main.async {
            mainPromotionInteractor?.fetchUserDetails()
            mainPromotionInteractor?.fetchProductAll(request: MainPromotionUseCase.LoadMainPromotion.Request(limit: 30, offset: 0))
            mainPromotionViewModel.resetAllDetails() // 예약하고 돌아온 사용자 데이터 초기화
            if stack.isEmpty {
                stack = NavigationPath()
            }
        }
    }
}



struct HeaderView: View {
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            HStack {
                Image("mainSnapFitLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 20)
                Spacer()
            }
            .padding(.bottom, 24)
            
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 7) {
                    if let nickName = mainPromotionViewModel.userDetails?.nickName {
                        Text("안녕하세요, \(nickName)님")
                            .font(.title2)
                            .bold()
                        Text("스냅핏에서는 원하는\n분위기의 사진을 찾아 보세요!")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                            .padding(.bottom)
                    } else {
                        Text("안녕하세요!")
                            .font(.title2)
                            .bold()
                        Text("스냅핏에서는 원하는\n분위기의 사진을 찾아 보세요!")
                            .font(.subheadline)
                            .foregroundColor(Color(.systemGray))
                            .padding(.bottom)
                    }
                }
                Spacer()
                
                if let profileUrl = mainPromotionViewModel.userDetails?.profile, !profileUrl.isEmpty {
                    // 프로필 이미지가 있을 때
                    AsyncImage(url: URL(string: profileUrl)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle()) // 동그란 모양으로 자르기
                    } placeholder: {
                        // 로딩 중일 때 기본 로고 표시
                        Image("SnapFitProfileLogo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }
                } else {
                    // 프로필 이미지가 없을 때
                    Image("SnapFitProfileLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
            }
        }
        .padding(.horizontal, 16)
    }
}


struct SectionMiniCardsView: View {
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    @Binding var stack: NavigationPath

    let layout: [GridItem] = [GridItem(.fixed(130))]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: layout, spacing: 8) {
                ForEach(Array(mainPromotionViewModel.products.prefix(10))) { product in
                    Button(action: {
                        mainPromotionViewModel.selectedProductId = product.id
                        DispatchQueue.main.async {
                            stack.append("AuthorDetailView")
                        }
                    }) {
                        MiniCardView( isLiked: Binding(
                                get: { product.like ?? false },
                                set: { newValue in
                                    if let index = mainPromotionViewModel.products.firstIndex(where: { $0.id == product.id }) {
                                        mainPromotionViewModel.products[index].like = newValue
                                    }
                                }
                            ), // 초기 좋아요 상태를 전달
                            product: product,
                            mainPromotionInteractor: mainPromotionInteractor
                        )
                        .onChange(of: product.like) { newValue in
                            if let index = mainPromotionViewModel.products.firstIndex(where: { $0.id == product.id }) {
                                mainPromotionViewModel.products[index].like = newValue
                            }
                        }
                        .frame(width: 130, height: 204)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0))
        }
    }
}




struct SectionBigCardsView: View {
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    @Binding var stack: NavigationPath

    let columns: [GridItem] = [
        GridItem(.fixed(175), spacing: 10),
        GridItem(.fixed(175), spacing: 10)
    ]

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 8) {
                // 10번째 이후의 상품만 가져오기
                ForEach(Array(mainPromotionViewModel.products.dropFirst(10))) { product in
                    Button(action: {
                        mainPromotionViewModel.selectedProductId = product.id
                        DispatchQueue.main.async {
                            stack.append("AuthorDetailView")
                        }
                    }) {
                        BigCardView(isLiked: Binding(
                                get: { product.like ?? false },
                                set: { newValue in
                                    if let index = mainPromotionViewModel.products.firstIndex(where: { $0.id == product.id }) {
                                        mainPromotionViewModel.products[index].like = newValue
                                    }
                                }
                            ), // 초기 좋아요 상태 전달
                            product: product,
                            mainPromotionInteractor: mainPromotionInteractor
                        )
                        .onChange(of: product.like) { newValue in
                            if let index = mainPromotionViewModel.products.firstIndex(where: { $0.id == product.id }) {
                                mainPromotionViewModel.products[index].like = newValue
                            }
                        }
                        .frame(width: 175, height: 256)
                        .padding(.bottom, 32)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
        }
    }
}
