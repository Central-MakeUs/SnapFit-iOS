//
//  AuthorDetailView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//
import SwiftUI
import MessageUI
import Kingfisher
import WebKit

struct AuthorDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    var productInteractor: ProductUseCase? // 공통 프로토콜 타입으로 변경
    
    @Binding var stack: NavigationPath
    @State private var isShowingMailView = false
    @State private var isShowingWebView = false
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    
    @State private var isLoadingProducts = true // 로딩 상태 추가
    @State private var isLiked: Bool = false // 좋아요 상태 초기화
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if isLoadingProducts {
                    // 로딩 중일 때 ProgressView를 표시
                    VStack {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5) // 크기를 키울 수 있음
                            .padding()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // 데이터 로딩이 완료되면 실제 콘텐츠를 표시
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .leading) {
                            if let detail = mainPromotionViewModel.productDetail {
                                MainContentView(productInteractor: productInteractor, mainPromotionViewModel: mainPromotionViewModel, productDetail: detail, stack: $stack)
                            } else {
                                ProgressView() // 여전히 데이터가 없는 경우를 대비해 ProgressView 추가
                                    .padding()
                            }
                            
                            Spacer().frame(height: 100) // 예약 버튼에 대한 공간 추가
                        }
                        .padding(.bottom)
                    }
                    
                    // 고정된 NextButton
                    VStack {
                        Spacer()
                        NextButton(stack: $stack)
                    }
                }
            }
            .onAppear {
                loadProductDetails() // 데이터 로드 함수 호출
                if let likeStatus = mainPromotionViewModel.productDetail?.like {
                    isLiked = likeStatus // 좋아요 상태 초기화
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                    .hidden()
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            isLiked.toggle()
                            handleLikeAction()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .foregroundColor(.black)
                        }
                        .hidden()
                        
                        Menu {
                            Button(action: {
                                isShowingMailView = true
                            }) {
                                Label("신고하기", systemImage: "exclamationmark.bubble")
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingMailView) {
            if MFMailComposeViewController.canSendMail() {
                MailView(result: $mailResult)
            } else {
                VStack {
                    Text("메일 서비스가 설정되어 있지 않습니다.")
                        .font(.headline)
                        .padding()
                    Text("메일 앱을 설치하시면 바로 신고가 가능합니다.")
                        .foregroundColor(.gray)
                        .padding()
                    WebView(url: URL(string: "https://docs.google.com/forms/d/e/1FAIpQLSekyp-tBMhi2GDOX49X7DWpaXCu7MLNFGQ5scuL_en5AhBSnQ/viewform")!)
                        .edgesIgnoringSafeArea(.all) // 웹뷰가 안전 영역을 넘어 확장되도록 설정
                  
                    Button {
                        isShowingMailView = false
                    } label: {
                        Spacer()
                        Text("확인")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding()
                    .frame(height: 48)
                    .background(Color.black)
                    .cornerRadius(5)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
                }
            }
        }
    }
    
    private func loadProductDetails() {
        guard let productId = mainPromotionViewModel.selectedProductId else { return }
        
        Task {
            isLoadingProducts = true
            await fetchProductDetails(productId: productId)
            isLoadingProducts = false
        }
    }
    
    @MainActor
    private func fetchProductDetails(productId: Int) async {
        // 첫 번째 API 호출: 제품 상세 정보를 가져옵니다.
        await productInteractor?.fetchPostDetailById(
            request: MainPromotionUseCase.LoadDetailProduct.Request(id: productId)
        )
        
        // 제품 상세 정보가 로드될 때까지 대기하되, 최대 5초 대기 (타임아웃 메커니즘 추가)
        let timeout: TimeInterval = 5
        let startTime = Date()
        
        // 제품 상세 정보가 로드될 때까지 대기합니다.
        while mainPromotionViewModel.productDetail == nil {
            await Task.yield()
            
            if Date().timeIntervalSince(startTime) > timeout {
                print("Timeout: Product detail loading took too long.")
                break
            }
        }
        
        // 두 번째 API 호출: Maker의 제품 목록을 가져옵니다.
        if let makerId = mainPromotionViewModel.productDetail?.maker?.id {
            await productInteractor?.fetchProductsForMaker(
                request: MainPromotionUseCase.LoadDetailProduct.ProductsForMakerRequest(
                    makerid: makerId,
                    limit: 30,
                    offset: 0
                )
            )
        }
    }
    
    // 좋아요 또는 좋아요 취소를 처리하는 함수
    private func handleLikeAction() {
        guard let interactor = productInteractor else {
            print("ProductInteractor가 설정되지 않았습니다.")
            return
        }
        
        guard let productId = mainPromotionViewModel.productDetail?.id else {
            print("상품 ID가 없습니다.")
            return
        }
        
        let request = MainPromotionUseCase.Like.Request(postId: productId)
        
        if isLiked {
            interactor.likePost(request: request)
        } else {
            interactor.unlikePost(request: request)
        }
    }
}
// 주요 콘텐츠 뷰
struct MainContentView: View {
    var productInteractor: ProductUseCase? // 공통 프로토콜 타입으로 변경
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    let productDetail: PostDetailResponse
    let layout: [GridItem] = [GridItem(.flexible())]
    @Binding var stack: NavigationPath
    
    var body: some View {
        
        // 이미지 슬라이더
        if let imageUrls = productDetail.images, !imageUrls.isEmpty {
            ImageSliderView(images: imageUrls)
                .frame(maxWidth: .infinity) // 너비를 최대화하여 사용
                .aspectRatio(contentMode: .fit) // 비율 유지
                .padding(.bottom)
        } else {
            Text("이미지가 없습니다.")
                .hidden()
        }
        
        // 무드와 위치
        HStack(spacing: 16) {
            
            if let studio = productDetail.studio, studio == true {
                DeteailInOutLabel(text: "실내스냅")
            }
            
            
            if let vibes = productDetail.vibes {
                ForEach(vibes, id: \.self) { vibe in
                    MoodsLabel(text: vibe)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 16)
        
        // 제목
        Text(productDetail.title ?? "제목 없음")
            .lineLimit(2)
            .font(.title3)
            .bold()
            .padding(.horizontal)
        
        HStack(spacing: 8) {
            Image("point")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            if let locations = productDetail.locations {
                Text(locations.joined(separator: " | "))
                    .font(.footnote)
                    .foregroundColor(Color("LoginFontColor"))
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 24)
        
        // 가격
        if let prices = productDetail.prices, let minPrice = prices.first?.min, let price = prices.first?.price {
            Text("\(minPrice)분 - \(price)원")
                .font(.system(size: 24))
                .bold()
                .padding(.horizontal)
        } else {
            PriceView(price: "가격 정보 없음")
        }
        
        DividerAndRegulationView()
        
        Spacer().frame(height: 32)
        
        // 작가의 설명
        VStack(alignment: .leading, spacing: 12) {
            Text("작가의 설명")
                .font(.callout)
                .bold()
                .padding(.horizontal)
            
            Text(productDetail.desc ?? "설명이 없습니다.")
                .font(.callout)
                .foregroundColor(Color(.systemGray))
                .padding(.horizontal)
                .padding(.bottom, 40)
        }
        
        CustomDividerView()
            .padding(.bottom, 32)
        
        // 등록된 상품
        Text("작가의 등록된 상품")
            .font(.callout)
            .bold()
            .padding(.horizontal)
        
        if mainPromotionViewModel.productDetailAuthorProducts.isEmpty {
            HStack {
                Spacer()
                ProductEmptyView()
                Spacer()
            }
            .padding(.top, 12)
            .padding(.bottom, 32)
        } else {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: layout, spacing: 8) {
                    ForEach(mainPromotionViewModel.productDetailAuthorProducts) { product in
                        Button(action: {
                            mainPromotionViewModel.selectedProductId = product.id
                            stack.append("AuthorDetailView")
                        }) {
                            
                            MiddleCardView(isLiked: Binding(
                                get: { product.like ?? false },
                                set: { newValue in
                                    if let index = mainPromotionViewModel.products.firstIndex(where: { $0.id == product.id }) {
                                        mainPromotionViewModel.products[index].like = newValue
                                    }
                                }
                            ), product: product, mainPromotionInteractor: productInteractor)
                            .frame(width: 175, height: 324)
                        }
                    }
                    .padding(.leading, 6)
                }
            }
            .padding(.horizontal)
        }
        
        CustomDividerView()
            .padding(.bottom, 32)
        
        VStack(alignment: .leading, spacing: 12) {
            Text("취소 규정")
                .font(.body)
                .bold()
                .padding(.horizontal)
                .padding(.bottom, 12)
            
            Text("""
                가. 기본 환불 규정
                1. 전문가와 의뢰인의 상호 협의하에 청약 철회 및 환불이 가능합니다.\n
                2. 섭외, 대여 등 사전 준비 도중 청약 철회 시, 해당 비용을 공제한 금액을 환불 가능합니다.\n
                3. 촬영 또는 편집 작업 착수 이후 청약 철회 시, 진행된 작업량 또는 작업 일수를 산정한 금액을 공제한 금액을 환불 가능합니다.
                """)
            .font(.subheadline)
            .foregroundColor(Color(.systemGray))
            .padding(.horizontal)
            .padding(.bottom, 16)
        }
    }
}

// 하단의 로고와 규정 뷰
struct DividerAndRegulationView: View {
    var body: some View {
        Group {
            CustomDividerView()
            
            HStack(spacing: 8) {
                Image("starMidleLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 27, height: 27)
                
                Text("추카랜드")
            }
            .padding(16)
            
            CustomDividerView()
        }
    }
}

// 다음 버튼 뷰
struct NextButton: View {
    @Binding var stack : NavigationPath
    var body: some View {
        NavigationLink(value: "AuthorReservationView"){
            HStack(spacing: 20) {
                Spacer()
                Text("예약하기")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.white)
                Spacer()
            }
            .padding()
            .frame(height: 48)
            .background(Color.black)
            .cornerRadius(5)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 20))
        }
    }
}

// 가격 뷰
struct PriceView: View {
    let price: String
    
    var body: some View {
        HStack {
            Text(price)
                .foregroundColor(.black)
                .padding(.leading, 10)
            Spacer()
        }
        .frame(height: 52)
        .background(Color(.systemGray5))
        .cornerRadius(8)
        .padding()
    }
}



//
//extension AuthorDetailView {
//    // PostDetailResponse 구조체에 맞는 더미 데이터
//    static let sampleDetail = PostDetailResponse(
//        id: 1,
//        maker: Maker(id: 1, nickName: "작가 닉네임"),
//        createAt: "2024-08-15",
//        thumbnail: "https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg/250px-HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg",
//        images: ["https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg/250px-HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg"],
//        desc: "사진에서는 빛과 색감의 조화가 돋보이며, 피사체에 대한 깊이 있는 관찰력이 드러납니다. 사진에서는 빛과 색감의 조화가 돋보이며, 피사체에 대한 깊이 있는 관찰력이 드러납니다.",
//        title: "스냅사진｜넘치지 않는 아름다움을 담아드려요 - 개인, 커플, 우정스냅사진",
//        vibes: ["러블리", "유니크"],
//        locations: ["서울", "부산"],
//        prices: [Price(min: 10000, price: 20000)],
//        personPrice: 50000
//    )
//
//    static let sampleViewModel = MainPromotionViewModel(productDetail: sampleDetail)
//}
//
//// 프리뷰
//#Preview {
//    let path = NavigationPath()
//
//    return AuthorDetailView(stack: .constant(path))
//        .environmentObject(AuthorDetailView.sampleViewModel)
//}
