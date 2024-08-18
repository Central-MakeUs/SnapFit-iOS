//
//  CardView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/18/24.
//

import SwiftUI



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
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipped()
                } placeholder: {
                    ProgressView()
                        .frame(width: 130, height: 130)
                }
                .overlay(
                    VStack {
                        if product.studio == true {
                            InOutLabel(text:"실내스냅") // InOutLabel 사용
                        }
                        Spacer()
                    },
                    alignment: .topLeading // 왼쪽 상단 정렬
                )
                .overlay {
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
                }
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
        .frame(width: 130, height: 204) // 명시적으로 프레임 크기 설정
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
    @State private var isLiked = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Background Image
            Image("demo5")
                .resizable()
                .scaledToFill()
                .frame(width: 358, height: 202)
                .clipped()
                //.cornerRadius(10)

            // Overlay for "New" and like button
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isLiked.toggle()
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
                    VStack(alignment: .leading, spacing: 8) {
                        Text("대체불가! 성수 컨셉스냅 전문 인기 포토그래퍼, 데이트 스냅...")
                            .font(.subheadline)
                            .lineLimit(1)
                            .foregroundColor(.white)
                        
                        Text("32,400원")
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 8) {
                            DeteailInOutLabel(text: "야외스냅")
                            MoodsLabel(text: "시크")
                            MoodsLabel(text: "러블리")
                        }
                        .padding(.bottom, 8) // 피그마 12인데 글자 크기 때문에 못함
                    }
                    .padding(.horizontal, 16)
                )
                //.cornerRadius(10)
        }
        .frame(width: 358, height: 202) // Explicitly set frame size
    }
}

#Preview{
    MainPromotionRandomCardView()
}

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

#Preview {
    BigCardView()
        .frame(width: 175, height: 258)
}

#Preview {
    MainPromotionRandomCardView()
        .frame(width: 358, height: 202)
}
