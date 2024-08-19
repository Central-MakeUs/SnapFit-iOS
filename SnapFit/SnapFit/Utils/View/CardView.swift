//
//  CardView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/18/24.
//

import SwiftUI



import SwiftUI
import Kingfisher

struct MiniCardView: View {
    @State private var isLiked: Bool
    var product: ProductInfo
    var mainPromotionInteractor: MainPromotionBusinessLogic?

    init(product: ProductInfo, mainPromotionInteractor: MainPromotionBusinessLogic?) {
        self.product = product
        self.mainPromotionInteractor = mainPromotionInteractor
        _isLiked = State(initialValue: product.like ?? false)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let imageUrl = product.thumbNail, let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 130, height: 130)
                    .clipped()
                    .overlay(
                        VStack {
                            if product.studio == true {
                                InOutLabel(text:"실내스냅")
                            }
                            Spacer()
                        },
                        alignment: .topLeading
                    )
                    .overlay(
                        Button(action: {
                            isLiked.toggle()
                            handleLikeAction()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 15)
                                .foregroundColor(.white)
                        }
                        .offset(x: 42, y: -42)
                    )
                    .padding(.bottom, 5)
            } else {
                Color.gray
                    .frame(width: 130, height: 130)
            }

            Group {
                Text(product.title ?? "Unknown")
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)

                Text(product.locations?.first ?? "Unknown Location")
                    .font(.caption)
                    .foregroundColor(.black)

                if let price = product.price {
                    Text("\(price)원")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.black)
                } else {
                    Text("가격 정보 없음")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
        }
        .background(Color.white)
        .frame(width: 130, height: 204)
    }

    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("MainPromotionInteractor가 설정되지 않았습니다.")
            return
        }
        
        let request = MainPromotion.Like.Request(postId: product.id)
        
        if isLiked {
            interactor.likePost(request: request)
        } else {
            interactor.unlikePost(request: request)
        }
    }
}

struct MiddleCardView: View {
    @State private var isLiked: Bool
    var product: ProductInfo
    var mainPromotionInteractor: ProductBusinessLogic?
    
    init(product: ProductInfo, mainPromotionInteractor: ProductBusinessLogic?) {
        self.product = product
        self.mainPromotionInteractor = mainPromotionInteractor
        _isLiked = State(initialValue: product.like ?? false)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let imageUrl = product.thumbNail, let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 175, height: 170)
                    .cornerRadius(5)
                    .clipped()
                    .overlay(
                        VStack {
                            if product.studio == true {
                                InOutLabel(text:"실내스냅") // InOutLabel 사용
                            }
                            Spacer()
                        },
                        alignment: .topLeading // 왼쪽 상단 정렬
                    )
                    .overlay(
                        Button(action: {
                            isLiked.toggle()
                            handleLikeAction()
                        }) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundColor(.white)
                        }
                        .offset(x: 62, y: -62)
                    )
                    .padding(.bottom, 5)
            } else {
                Color.gray
                    .frame(width: 175, height: 170)
            }

            Group {
                Text(product.locations?.first ?? "Unknown Location")
                    .font(.subheadline)
                    .foregroundColor(Color("LoginFontColor"))

                Text(product.title ?? "Unknown")
                    .font(.callout)
                    .lineLimit(2)

                HStack {
                    MoodsLabel(text: "시크")
                    MoodsLabel(text: "러블리")
                }

                if let price = product.price {
                    Text("\(price)원")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.black)
                } else {
                    Text("가격 정보 없음")
                        .font(.callout)
                        .foregroundColor(.gray)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
        }
        .background(Color.white)
        .frame(width: 175, height: 324) // 명시적으로 프레임 크기 설정
    }

    // 좋아요 또는 좋아요 취소를 처리하는 함수
    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("MainPromotionInteractor가 설정되지 않았습니다.")
            return
        }
        
        let request = MainPromotion.Like.Request(postId: product.id)
        
        if isLiked {
            interactor.likePost(request: request)
        } else {
            interactor.unlikePost(request: request)
        }
    }
}

struct DibsMiddleCardView: View {
    @State private var isLiked: Bool
    let productInfo: ReservationData
    var mainPromotionInteractor: MyPageBusinessLogic?
    
    init(product: ReservationData, mainPromotionInteractor: MyPageBusinessLogic?) {
        self.productInfo = product
        self.mainPromotionInteractor = mainPromotionInteractor
        _isLiked = State(initialValue: productInfo.post?.like ?? false)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let imageUrl = productInfo.post?.thumbNail, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 175, height: 170)
                        .cornerRadius(5)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(width: 175, height: 170)
                }
                .overlay(
                    VStack {
                        if productInfo.post?.studio == true {
                            InOutLabel(text:"실내스냅") // InOutLabel 사용
                        }
                        Spacer()
                    },
                    alignment: .topLeading // 왼쪽 상단 정렬
                )
                .overlay(
                    Button(action: {
                        isLiked.toggle()
                        handleLikeAction()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                    }
                    .offset(x: 62, y: -62)
                )
                .padding(.bottom, 5)
            } else {
                Color.gray
                    .frame(width: 175, height: 170)
            }

//            Group {
//                // locations 배열이 존재하는 경우
//                if let locations = productInfo.post?.locations {
//                    VStack(alignment: .leading, spacing: 5) {
//                        // 배열의 요소를 직접 처리
//                        if locations.isEmpty {
//                            Text("Unknown Location")
//                                .font(.subheadline)
//                                .foregroundColor(Color("LoginFontColor"))
//                        } else {
//                            ForEach(0..<locations.count, id: \.self) { index in
//                                Text(locations[index])
//                                    .font(.subheadline)
//                                    .foregroundColor(Color("LoginFontColor"))
//                            }
//                        }
//                    }
//                } else {
//                    Text("Unknown Location")
//                        .font(.subheadline)
//                        .foregroundColor(Color("LoginFontColor"))
//                }
//
//                // title이 Optional일 수 있으므로 기본값을 제공
//                Text(productInfo.post?.title ?? "Unknown")
//                    .font(.callout)
//                    .lineLimit(2)
//
//                // vibes 배열을 사용하여 HStack 내에 MoodsLabel을 동적으로 생성
//                HStack {
//                    // vibes 배열이 존재하는 경우
//                    if let vibes = productInfo.post?.vibes {
//                        // 배열의 요소를 직접 처리
//                        if vibes.isEmpty {
//                            Text("No vibes available")
//                                .font(.callout)
//                                .foregroundColor(.gray)
//                        } else {
//                            ForEach(vibes, id: \.self) { vibe in
//                                MoodsLabel(text: vibe)
//                            }
//                        }
//                    } else {
//                        Text("No vibes available")
//                            .font(.callout)
//                            .foregroundColor(.gray)
//                    }
//                }
//
//                // 가격 정보가 있는 경우와 없는 경우를 처리
//                if let price = productInfo.price {
//                    Text("\(price)원")
//                        .font(.callout)
//                        .bold()
//                        .foregroundColor(.black)
//                } else {
//                    Text("가격 정보 없음")
//                        .font(.callout)
//                        .foregroundColor(.gray)
//                }
//            }
//              .padding(EdgeInsets(top: 0, leading: 0, bottom: 5, trailing: 10))
        }
        .background(Color.white)
        .frame(width: 175, height: 324) // 명시적으로 프레임 크기 설정
    }

    // 좋아요 또는 좋아요 취소를 처리하는 함수
    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("MainPromotionInteractor가 설정되지 않았습니다.")
            return
        }
        
        let request = MainPromotion.Like.Request(postId: productInfo.post?.id ?? 0)
        
        if isLiked {
            interactor.likePost(request: request)
        } else {
            interactor.unlikePost(request: request)
        }
    }
}



struct BigCardView: View {
    @State private var isLiked = false

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Image("demo1")
                .resizable()
                .scaledToFill()
                .frame(width: 175, height: 200)
                .clipped()
//                .overlay {
//                    Button(action: {
//                        isLiked.toggle()
//                    }) {
//                        Image(systemName: isLiked ? "heart.fill" : "heart")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 16, height: 16)
//                            .foregroundColor(.white)
//                    }
//                    .offset(x: 70, y: -70)
//                }
//                .padding(.bottom, 5)

            VStack(alignment:.leading) {
                Text("추카랜드")
                    .font(.subheadline)
                    .lineLimit(2)

                HStack(spacing: 9) {
                    MoodsLabel(text: "시크")
                    MoodsLabel(text: "러블리")
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
        }
        .background(Color.white)
        //.cornerRadius(10)
        //.shadow(radius: 4)
        .frame(width: 175, height: 258) // Explicitly set frame size
    }
}



struct MainPromotionRandomCardView: View {
    @State private var isLiked: Bool
    var product: ProductInfo
    var mainPromotionInteractor: MainPromotionBusinessLogic?

    init(product: ProductInfo, mainPromotionInteractor: MainPromotionBusinessLogic? = nil) {
        self.product = product
        self.mainPromotionInteractor = mainPromotionInteractor
        _isLiked = State(initialValue: product.like ?? false)
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            if let imageUrl = product.thumbNail, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 358, height: 202)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(width: 358, height: 202)
                }
            } else {
                Color.gray
                    .frame(width: 358, height: 202)
            }

            // Overlay for "New" and like button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isLiked.toggle()
                        handleLikeAction()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                Spacer()
            }

            // Bottom Overlay with Text and Labels
            Rectangle()
                .fill(Color.black.opacity(0.7))
                .frame(height: 96)
                .overlay(
                    HStack(content: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.title ?? "Unknown Title")
                                .font(.subheadline)
                                .lineLimit(1)
                                .foregroundColor(.white)
                                .padding(.top, 8)

                            if let price = product.price {
                                Text("\(price)원")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            } else {
                                Text("가격 정보 없음")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            HStack(spacing: 8) {
                                if product.studio == true {
                                    DeteailInOutLabel(text: "실내스냅")
                                }
                                // Add other labels or tags here if needed
                                
                                // Display vibes as labels
                                if let vibes = product.vibes {
                                    ForEach(vibes, id: \.self) { vibe in
                                        MoodsLabel(text: vibe)
                                    }
                                }
                             
                            }
                            .padding(.bottom, 8)
                        }
                        
                        Spacer()
                    })
                   
                    .padding(.horizontal, 16)
                )
        }
        .frame(width: 358, height: 202)
    }

    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("MainPromotionInteractor가 설정되지 않았습니다.")
            return
        }
        
        let request = MainPromotion.Like.Request(postId: product.id)
        
        if isLiked {
            interactor.likePost(request: request)
        } else {
            interactor.unlikePost(request: request)
        }
    }
}







//#Preview{
//    MainPromotionRandomCardView()
//}

// Previews
//#Preview {
//    MiniCardView(product: ProductInfo(id: 1, maker: Optional(SnapFit.Maker(id: 5, nickName: Optional("yongha"))), title: Optional("test data"), thumbNail: Optional("https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg/250px-HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg"), vibes: Optional(["러블리"]), locations: Optional(["전체"]), price: Optional(10000), studio: Optional(true),  like:  Optional(true)))
//        .frame(width: 118, height: 244)
//}
//
//#Preview {
//    MiddleCardView(product: ProductInfo(id: 1, maker: Optional(SnapFit.Maker(id: 5, nickName: Optional("yongha"))), title: Optional("test data"), thumbNail: Optional("https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg/250px-HAN_SO_HEE_%28%ED%95%9C%EC%86%8C%ED%9D%AC%29_%E2%80%94_BOUCHERON_from_HIGH_JEWELRY_%E2%80%94_MARIE_CLAIRE_KOREA_%E2%80%94_2023.07.06.jpg"), vibes: Optional(["러블리"]), locations: Optional(["전체"]), price: Optional(10000), studio: Optional(true), like:  Optional(true)))
//        .frame(width: 174, height: 322)
//}

//#Preview {
//    BigCardView()
//        .frame(width: 175, height: 258)
//}
//
//#Preview {
//    MainPromotionRandomCardView()
//        .frame(width: 358, height: 202)
//}
