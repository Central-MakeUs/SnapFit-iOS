//
//  MainPromotionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//
import SwiftUI

protocol MainPromotionDisplayLogic {
    
    
    // MARK: - 사용자 조회관련
    func displayUserDetails(viewModel: LoadUserDetails.ViewModel)
    
    
    // MARK: - 상품 조회관련
    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel) // 유즈케이스 수정필요
    func displayDetail(viewModel: MainPromotion.LoadDetailProduct.ViewModel) // 유즈케이스 수정필요
    func displayDetailProductsForMaker(viewModel: MainPromotion.LoadDetailProduct.ProductsForMakerViewModel)
    func displayVibes(viewModel: MainPromotion.LoadMainPromotion.VibesPresentationViewModel)
    
    // MARK: - 상품 예약관련
    func displayReservationSuccess(viewModel: MainPromotion.ReservationProduct.ViewModel)
    func displayFetchUserReservation(viewModel: MainPromotion.CheckReservationProducts.ViewModel)
    func displayFetchUserReservationDetail(viewModel: MainPromotion.CheckReservationDetailProduct.ViewModel)
    func displayDeleteUserReservation(viewModel: MainPromotion.DeleteReservationProduct.ViewModel)
    
}

extension MainPromotionView: MainPromotionDisplayLogic {
    
    func displayUserDetails(viewModel: LoadUserDetails.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.userDetails = viewModel.userDetails
            print("mainPromotionViewModel.userDetails \( mainPromotionViewModel.userDetails)")
        }
    }

    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.products = viewModel.products.data
            print("viewModel.products.data \(viewModel.products.data)")
            //print("mainPromotionViewModel.products \( mainPromotionViewModel.products)")
        }
    }
    
    // 상품 들어가고 나서 보여지는 정보
    func displayDetail(viewModel: MainPromotion.LoadDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.productDetail = viewModel.productDetail
            //print("mainPromotionViewModel.productDetail \( mainPromotionViewModel.productDetail)")
        }
    }
    
    func displayDetailProductsForMaker(viewModel: MainPromotion.LoadDetailProduct.ProductsForMakerViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.productDetailAuthorProducts = viewModel.products.data
            print("작가가 등록한 상품 \( mainPromotionViewModel.productDetailAuthorProducts)")
        }
    }
    
    func displayVibes(viewModel: MainPromotion.LoadMainPromotion.VibesPresentationViewModel) {
        print()
    }
    
    // MARK: - 상품 예약관련
    
    // 예약이후 예약성공 상세화면에 값 전달
    func displayReservationSuccess(viewModel: MainPromotion.ReservationProduct.ViewModel) {
        DispatchQueue.main.async {
            self.mainPromotionViewModel.reservationSuccess = viewModel.reservationSuccess
            self.mainPromotionViewModel.reservationDetails = viewModel.reservationDetails
            //print("mainPromotionViewModel.reservationSuccess \(self.mainPromotionViewModel.reservationSuccess)")
            //print("mainPromotionViewModel.reservationDetails \(self.mainPromotionViewModel.reservationDetails)")
        }
    }
    
    
    // 유저 예약내역 리스트 조회
    func displayFetchUserReservation(viewModel: MainPromotion.CheckReservationProducts.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화 후 id로 정렬
            mainPromotionViewModel.reservationproducts = (viewModel.reservationProducts?.data ?? []).sorted(by: {
                ($0.id ?? Int.min) < ($1.id ?? Int.min)
            })

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("mainPromotionViewModel.reservationproducts: \(mainPromotionViewModel.reservationproducts)")
        }
    }

    
    
    func displayFetchUserReservationDetail(viewModel: MainPromotion.CheckReservationDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            // 옵셔널 처리: data가 nil일 경우 빈 배열로 초기화
            mainPromotionViewModel.reservationproductDetail = viewModel.reservationDetail

            // 디버그 로그: 업데이트된 reservationproducts를 출력
            print("mainPromotionViewModel.reservationproductDetail: \(mainPromotionViewModel.reservationproductDetail)")
        }
    }
    
    // 유저 예약 삭제
    func displayDeleteUserReservation(viewModel: MainPromotion.DeleteReservationProduct.ViewModel) {
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
                    
                    SectionHeaderView(title: "이런 사진은 어때요?")
                    
                    if let randomProduct = randomProduct {
                        Button(action: {
                            mainPromotionViewModel.selectedProductId = randomProduct.id
                            isLiked = randomProduct.like ?? false // 좋아요 상태 업데이트
                            DispatchQueue.main.async {
                                stack.append("AuthorDetailView")
                            }
                        }) {
                            MainPromotionRandomCardView(isLiked: Binding($isLiked), product: randomProduct, mainPromotionInteractor: mainPromotionInteractor)

                                .padding(.vertical, 16)
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.vertical, 16)
                    }
                    
                    SectionMiniCardsView(mainPromotionInteractor: mainPromotionInteractor, stack: $stack)
                        .padding(.bottom, 40)
                }
                .environmentObject(mainPromotionViewModel)
            }
            .navigationBarBackButtonHidden(true)
            .navigationDestination(for: String.self) { viewName in
                switch viewName {
                case "AuthorDetailView":
                    AuthorDetailView(productInteractor: mainPromotionInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(mainPromotionViewModel)
                case "AuthorReservationView":
                    AuthorReservationView(productInteractor: mainPromotionInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(mainPromotionViewModel)
                case "AuthorReservationReceptionView" :
                    AuthorReservationReceptionView(stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(mainPromotionViewModel)
                case "ReservationView" :
                    ReservationView(productInteractor: mainPromotionInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(mainPromotionViewModel)
                    
                case "ReservationInfoView" :
                    ReservationInfoView(productInteractor: mainPromotionInteractor, stack: $stack)
                        .navigationBarBackButtonHidden(true)
                        .environmentObject(mainPromotionViewModel)
                default:
                    SnapFitTabView()
                }
            }
            .onAppear {
                // 뷰가 나타난 후 비동기적으로 호출
                DispatchQueue.main.async {
                    mainPromotionInteractor?.fetchUserDetails()
                    mainPromotionInteractor?.fetchProductAll(request: MainPromotion.LoadMainPromotion.Request(limit: 30, offset: 0))
                    mainPromotionViewModel.resetAllDetails() // 예약하고 돌아온 사용자 데이터 초기화
                    if stack.isEmpty {
                        stack = NavigationPath()
                    }
                }
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
    @EnvironmentObject var mainPromotionViewModel: MainPromotionViewModel
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    @Binding var stack: NavigationPath

    let layout: [GridItem] = [GridItem(.fixed(130))] // Fixed size layout

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: layout, spacing: 8) {
                ForEach($mainPromotionViewModel.products.sorted(by: { $0.id < $1.id })) { $product in
                    Button(action: {
                        mainPromotionViewModel.selectedProductId = product.id
                        DispatchQueue.main.async {
                            stack.append("AuthorDetailView")
                        }
                    }) {
                        MiniCardView(isLiked: $product.like, product: product, mainPromotionInteractor: mainPromotionInteractor)
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
    //@EnvironmentObject var navigationModel: NavigationModel // NavigationModel을 환경 객체로 사용
    @Binding var stack : NavigationPath
    
    let columns: [GridItem] = [
        GridItem(.fixed(175), spacing: 10), // 고정된 크기 설정
        GridItem(.fixed(175), spacing: 10)
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<10, id: \.self) { item in
                    NavigationLink(value: "AuthorDetailView"){
                    
                        BigCardView()
                            .frame(width: 175, height: 288)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    // Preview를 위한 NavigationPath 초기화
    let path = NavigationPath()
    
    return MainPromotionView(mainPromotionViewModel: MainPromotionViewModel())
}
