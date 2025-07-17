//
//  CardView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/18/24.
//

import SwiftUI
import Kingfisher

struct MiniCardView: View {
    @Binding var isLiked: Bool // 여기서는 더 이상 @Binding을 사용하지 않음
    var product: ProductInfo
    var mainPromotionInteractor: MainPromotionBusinessLogic?

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
                                InOutLabel(text: "실내스냅")
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

                if let locations = product.locations {
                    Text(locations.joined(separator: " | "))
                        .font(.footnote)
                        .foregroundColor(Color("LoginFontColor"))
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
        .frame(width: 130, height: 204)
    }

    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("MainPromotionInteractor가 설정되지 않았습니다.")
            return
        }

        let request = MainPromotion.Like.Request(postId: product.id)

        if isLiked {
            interactor.unlikePost(request: request)
        } else {
            interactor.likePost(request: request)
        }
    }
}


struct MiddleCardView: View {
    @Binding var isLiked: Bool // @Binding -> @State로 변경
    var product: ProductInfo
    var mainPromotionInteractor: ProductBusinessLogic?
    
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
                                InOutLabel(text: "실내스냅")
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
                            .offset(x: 62, y: -62)
                    )
                    .padding(.bottom, 5)
            } else {
                Color.gray
                    .frame(width: 175, height: 170)
            }
            
            Group {
                if let locations = product.locations {
                    Text(locations.joined(separator: " | "))
                        .font(.footnote)
                        .foregroundColor(Color("LoginFontColor"))
                }
                
                Text(product.title ?? "Unknown")
                    .font(.callout)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 175, alignment: .leading)
                
                HStack {
                    if let vibes = product.vibes {
                        if vibes.isEmpty {
                            Text("No vibes available")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(vibes, id: \.self) { vibe in
                                MoodsLabel(text: vibe)
                            }
                        }
                    } else {
                        Text("No vibes available")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
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
        .frame(width: 175, height: 324)
    }
    
    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("ProductBusinessLogic이 설정되지 않았습니다.")
            return
        }
        
        let request = MainPromotion.Like.Request(postId: product.id)
        
        if isLiked {
            interactor.unlikePost(request: request)
        } else {
            interactor.likePost(request: request)
        }
    }
}

struct MyMiddleCardView: View {
    @Binding var isLiked: Bool // @Binding -> @State로 변경
    var product: ProductInfo
    var mainPromotionInteractor: MyPageBusinessLogic?
    
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
                                InOutLabel(text: "실내스냅")
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
                            .offset(x: 62, y: -62)
                    )
                    .padding(.bottom, 5)
            } else {
                Color.gray
                    .frame(width: 175, height: 170)
            }
            
            Group {
                if let locations = product.locations {
                    Text(locations.joined(separator: " | "))
                        .font(.footnote)
                        .foregroundColor(Color("LoginFontColor"))
                }
                
                Text(product.title ?? "Unknown")
                    .font(.callout)
                    .lineLimit(1)
                    .truncationMode(.tail)
                    .frame(width: 175, alignment: .leading)
                
                HStack {
                    if let vibes = product.vibes {
                        if vibes.isEmpty {
                            Text("No vibes available")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(vibes, id: \.self) { vibe in
                                MoodsLabel(text: vibe)
                            }
                        }
                    } else {
                        Text("No vibes available")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
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
        .frame(width: 175, height: 324)
    }
    
    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("ProductBusinessLogic이 설정되지 않았습니다.")
            return
        }
        
        let request = MainPromotion.Like.Request(postId: product.id)
        
        if isLiked {
            interactor.unlikePost(request: request)
        } else {
            interactor.likePost(request: request)
        }
    }
}



// 메이커 상품 카드 뷰
struct MakerMiddleCardView: View {
    @Binding var isLiked: Bool?
    var product: PostDetail
    var mypageInteractor: MyPageBusinessLogic?
    
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
                                InOutLabel(text: "실내스냅") // InOutLabel 사용
                            }
                            Spacer()
                        },
                        alignment: .topLeading // 왼쪽 상단 정렬
                    )
                //                    .overlay(
                //                        Button(action: {
                //                            isLiked?.toggle()
                //                            handleLikeAction()
                //                        }) {
                //                            Image(systemName: (isLiked ?? false) ? "heart.fill" : "heart")
                //                                .resizable()
                //                                .scaledToFit()
                //                                .frame(width: 16, height: 16)
                //                                .foregroundColor(.white)
                //                        }
                //                        .offset(x: 62, y: -62)
                //                    )
                    .padding(.bottom, 5)
            } else {
                Color.gray
                    .frame(width: 175, height: 170)
            }
            
            Group {
                
                if let locations = product.locations {
                    Text(locations.joined(separator: " | "))
                        .font(.footnote)
                        .foregroundColor(Color("LoginFontColor"))
                }
                
                Text(product.title ?? "Unknown")
                    .font(.callout)
                    .lineLimit(2)
                
                HStack {
                    if let vibes = product.vibes {
                        if vibes.isEmpty {
                            Text("No vibes available")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(vibes, id: \.self) { vibe in
                                MoodsLabel(text: vibe)
                            }
                        }
                    } else {
                        Text("No vibes available")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
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
        guard let interactor = mypageInteractor else {
            print("MyPageBusinessLogic이 설정되지 않았습니다.")
            return
        }
        
        let request = MainPromotion.Like.Request(postId: product.id ?? 0)
        
        
        if isLiked == true {
            // 좋아요 상태가 true -> 좋아요 취소 요청
            interactor.unlikePost(request: request)
        } else {
            // 좋아요 상태가 false -> 좋아요 요청
            interactor.likePost(request: request)
        }
    }
}







struct DibsMiddleCardView: View {
    @Binding var isLiked: Bool
    let productInfo: ProductInfo
    var mainPromotionInteractor: MyPageBusinessLogic?
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let imageUrl = productInfo.thumbNail, let url = URL(string: imageUrl) {
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
                        if productInfo.studio == true {
                            InOutLabel(text: "실내스냅") // InOutLabel 사용
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
                // locations 배열이 존재하는 경우
                if let locations = productInfo.locations {
                    Text(locations.joined(separator: " | "))
                        .font(.footnote)
                        .foregroundColor(Color("LoginFontColor"))
                }
                
                // title이 Optional일 수 있으므로 기본값을 제공
                Text(productInfo.title ?? "Unknown")
                    .font(.callout)
                    .lineLimit(2)
                
                // vibes 배열을 사용하여 HStack 내에 MoodsLabel을 동적으로 생성
                HStack {
                    if let vibes = productInfo.vibes {
                        if vibes.isEmpty {
                            Text("No vibes available")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(vibes, id: \.self) { vibe in
                                MoodsLabel(text: vibe)
                            }
                        }
                    } else {
                        Text("No vibes available")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                }
                
                // 가격 정보가 있는 경우와 없는 경우를 처리
                if let price = productInfo.price {
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
        
        let request = MainPromotion.Like.Request(postId: productInfo.id)
        
        
        if isLiked {
            interactor.unlikePost(request: request)
        } else {
            interactor.likePost(request: request)
        }
    }
}





struct BigCardView: View {
    @Binding var isLiked: Bool // @Binding에서 @State로 변경
    var product: ProductInfo
    var mainPromotionInteractor: MainPromotionBusinessLogic?

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            if let imageUrl = product.thumbNail, let url = URL(string: imageUrl) {
                KFImage(url)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 175, height: 200)
                    .clipped()
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
                        .offset(x: 62, y: -68)
                    )
                    .padding(.bottom, 5)
            } else {
                Color.gray
                    .frame(width: 175, height: 200)
            }

            VStack(alignment: .leading) {
                Text(product.title ?? "Unknown")
                    .font(.subheadline)
                    .bold()
                    .lineLimit(1)

                HStack {
                    if let vibes = product.vibes {
                        if vibes.isEmpty {
                            Text("No vibes available")
                                .font(.callout)
                                .foregroundColor(.gray)
                        } else {
                            ForEach(vibes, id: \.self) { vibe in
                                MoodsLabel(text: vibe)
                            }
                        }
                    } else {
                        Text("No vibes available")
                            .font(.callout)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 10))
        }
        .background(Color.white)
        .cornerRadius(5)
        .frame(width: 175, height: 256)
    }

    private func handleLikeAction() {
        guard let interactor = mainPromotionInteractor else {
            print("MainPromotionInteractor가 설정되지 않았습니다.")
            return
        }

        let request = MainPromotion.Like.Request(postId: product.id)

        if isLiked {
            interactor.unlikePost(request: request)
        } else {
            interactor.likePost(request: request)
        }
    }
}




struct MainPromotionRandomCardView: View {
    @Binding var isLiked: Bool
    var product: ProductInfo
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    
    
    
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
                interactor.unlikePost(request: request)
            } else {
                interactor.likePost(request: request)
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
