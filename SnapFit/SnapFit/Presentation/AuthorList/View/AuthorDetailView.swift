//
//  AuthorDetailView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//
import SwiftUI

struct AuthorDetailView: View {

    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var mainPromotionViewModel: MainPromotionViewModel
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    
    @Binding var stack : NavigationPath
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading) {
                        if let detail = mainPromotionViewModel.productDetail {
                            MainContentView(productDetail: detail)
                        } else {
                            ProgressView()
                                .padding()
                        }
                        DividerAndRegulationView()
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
            .onAppear {
                
                if let productId = mainPromotionViewModel.selectedProductId {
                    mainPromotionInteractor?.fetchPostDetailById(
                        request: MainPromotion.LoadDetailProduct.Request(id: productId))
                }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack {
                        Button(action: {
                            // Action for heart button
                        }) {
                            Image(systemName: "heart")
                                .foregroundColor(.black)
                        }
                        Menu {
                            Button(action: {
                                // 공유하기 액션
                                print("공유하기")
                            }) {
                                Label("공유하기", systemImage: "square.and.arrow.up")
                            }
                            
                            Button(action: {
                                // 신고하기 액션
                                print("신고하기")
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
//        .navigationDestination(for: String.self) { viewName in
//            switch viewName {
//            case "AuthorReservationView":
//                AuthorReservationView(stack: $stack)
//                    .navigationBarBackButtonHidden(true)
//            default:
//                MainPromotionView()
//            }
//        }
    }
}

// 주요 콘텐츠 뷰
struct MainContentView: View {
    let productDetail: PostDetailResponse
    let layout: [GridItem] = [GridItem(.flexible())]

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
            
            // 제목
            Text(productDetail.title ?? "제목 없음")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            
            // 무드와 위치
            HStack {
                if let vibes = productDetail.vibes {
                    ForEach(vibes, id: \.self) { vibe in
                        MoodsLabel(text: vibe)
                    }
                }
                
                if let locations = productDetail.locations {
                    ForEach(locations, id: \.self) { location in
                        InOutLabel(text: location)
                    }
                }
            }
            .padding(.horizontal)
            
            // 가격
            if let prices = productDetail.prices, let minPrice = prices.first?.min, let price = prices.first?.price {
                PriceView(price: "\(minPrice) - \(price)")
            } else {
                PriceView(price: "가격 정보 없음")
            }
            
            SectionHeaderView(title: "위치")
            
            HStack(spacing: 8) {
                if let locations = productDetail.locations {
                    ForEach(locations, id: \.self) { location in
                        StarImageLabel(text: location)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
            
            // 작가의 설명
            HStack(spacing: 8) {
                Image("AuthorDec")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("작가의 설명")
            }
            .padding(.horizontal)
            
            Text(productDetail.desc ?? "설명이 없습니다.")
                .font(.caption)
                .foregroundColor(Color(.systemGray))
                .padding(.horizontal)
                .padding(.bottom, 40)
            
            // 등록된 상품
            SectionHeaderView(title: "등록된 상품")
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: layout, spacing: 8) {
                    ForEach(0..<10, id: \.self) { item in
                        MiddleCardView(product:  ProductInfo(id: 1, maker: Optional(SnapFit.Maker(id: 5, nickName: Optional("yongha"))), title: Optional("test data"), thumbNail: Optional("https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg/250px-HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg"), vibes: Optional(["러블리"]), locations: Optional(["전체"]), price: Optional(10000), studio: Optional(true)))
                            .frame(width: 175, height: 270) // 적절한 크기 설정
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
        
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
            
            SectionHeaderView(title: "취소 규정")
                .padding(.bottom, 16)
            
            Text("""
                가. 기본 환불 규정
                1. 전문가와 의뢰인의 상호 협의하에 청약 철회 및 환불이 가능합니다.
                2. 섭외, 대여 등 사전 준비 도중 청약 철회 시, 해당 비용을 공제한 금액을 환불 가능합니다.
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


#Preview {
    // Preview를 위한 NavigationPath 초기화
    let path = NavigationPath()
    
    return AuthorDetailView(stack: .constant(path))
}
