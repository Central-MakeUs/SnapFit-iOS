//
//  MyPageAuthorDetailView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/23/24.
//

import SwiftUI
import MessageUI
import Kingfisher

struct MyPageAuthorDetailView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var myPageViewModel: MyPageViewModel
    var myPageInteractor: MyPageBusinessLogic? // 공통 프로토콜 타입으로 변경
    
    @Binding var stack: NavigationPath
    @State private var isShowingMailView = false
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
                            if let detail = myPageViewModel.productDetail {
                                MyMainContentView(myPageInteractor: myPageInteractor, myPageViewModel: myPageViewModel, productDetail: detail, stack: $stack)
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
                        MyNextButton(stack: $stack)
                            .hidden()
                    }
                }
            }
            .onAppear {
                loadProductDetails() // 데이터 로드 함수 호출
                if let likeStatus = myPageViewModel.productDetail?.like {
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
                Text("Mail services are not available")
            }
        }
    }
    
    private func loadProductDetails() {
        guard let productId = myPageViewModel.selectedProductId else { return }
        
        Task {
            isLoadingProducts = true
            await fetchProductDetails(productId: productId)
            isLoadingProducts = false
        }
    }
    
    @MainActor
    private func fetchProductDetails(productId: Int) async {
        // 첫 번째 API 호출: 제품 상세 정보를 가져옵니다.
        await myPageInteractor?.fetchPostDetailById(
            request: MainPromotionUseCase.LoadDetailProduct.Request(id: productId)
        )
        
        // 제품 상세 정보가 로드될 때까지 대기하되, 최대 5초 대기 (타임아웃 메커니즘 추가)
        let timeout: TimeInterval = 5
        let startTime = Date()
        
        // 제품 상세 정보가 로드될 때까지 대기합니다.
        while myPageViewModel.productDetail == nil {
            await Task.yield()
            
            if Date().timeIntervalSince(startTime) > timeout {
                print("Timeout: Product detail loading took too long.")
                break
            }
        }
        
        // 두 번째 API 호출: Maker의 제품 목록을 가져옵니다.
        if let makerId = myPageViewModel.productDetail?.maker?.id {
            await myPageInteractor?.fetchProductsForMaker(
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
        guard let interactor = myPageInteractor else {
            print("ProductInteractor가 설정되지 않았습니다.")
            return
        }
        
        guard let productId = myPageViewModel.productDetail?.id else {
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
struct MyMainContentView: View {
    var myPageInteractor: MyPageBusinessLogic? // 공통 프로토콜 타입으로 변경
    @ObservedObject var myPageViewModel: MyPageViewModel
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
            Text("\(minPrice) - \(price)")
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
                .font(.subheadline)
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
        
        if myPageViewModel.productDetailAuthorProducts.isEmpty {
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
                    ForEach(myPageViewModel.productDetailAuthorProducts) { product in
                        Button(action: {
                            myPageViewModel.selectedProductId = product.id
                            stack.append("MyPageAuthorDetailView")
                        }) {
                            MyMiddleCardView(isLiked: Binding(
                                get: { product.like ?? false },
                                set: { newValue in
                                    if let index = myPageViewModel.likeProducts.firstIndex(where: { $0.id == product.id }) {
                                        myPageViewModel.likeProducts[index].like = newValue
                                    }
                                }
                            ), product: product, mainPromotionInteractor: myPageInteractor)
                            .frame(width: 175, height: 324)
                        }
                    }
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



// 다음 버튼 뷰
struct MyNextButton: View {
    @Binding var stack : NavigationPath
    var body: some View {
        NavigationLink(value: "ReservationView"){
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
