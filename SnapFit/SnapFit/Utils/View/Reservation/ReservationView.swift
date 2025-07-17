//
//  ReservationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI
import Kingfisher

struct ReservationView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.dismiss) var dismiss
    var productInteractor: ProductBusinessLogic?
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    @Binding var stack: NavigationPath
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 16) {
                    
                    // 예약된 상품 리스트를 id로 정렬하여 보여줍니다.
                    ForEach(mainPromotionViewModel.reservationproducts.sorted(by: {
                        ($0.id ?? Int.min) < ($1.id ?? Int.min)
                    })) { product in
                        Button(action: {
                            mainPromotionViewModel.selectedReservationId = product.id
                            print("ReservationView 지금 보려는 id \(product.id)")
                            stack.append("ReservationInfoView")
                        }) {
                            VStack(spacing: 0) {
                                ReservationInfoCardView(productInfo: product)
                                    .frame(width: 358, height: 130)
                                    .padding(.bottom, 22)
                                
                                Divider()
                                    .background(Color.gray.opacity(0.3))
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                }
        }
        .onAppear {
            // 예약 내역 불러오기
            DispatchQueue.main.async {
                productInteractor?.fetchUserReservations(request: MainPromotion.LoadMainPromotion.Request(limit: 30, offset: 0))
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
                .hidden()
            }
            
            ToolbarItem(placement: .principal) {
                Text("예약내역")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
    }
}

// 예약하기에서 보여줄 카드뷰
struct ReservationCardView: View {
    let productDetail: PostDetailResponse
    
    var body: some View {
        VStack {
            HStack(spacing: 34) {
                if let thumbnailUrlString = productDetail.thumbnail,
                   let thumbnailUrl = URL(string: thumbnailUrlString) {
                    KFImage(thumbnailUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(productDetail.title ?? "제목 없음")
                        .lineLimit(2)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .frame(height: 40, alignment: .leading) // 높이 고정
                    
                    if let locations = productDetail.locations, !locations.isEmpty {
                        Text(locations.joined(separator: " | "))
                            .font(.caption)
                            .foregroundColor(Color("LoginFontColor"))
                            .frame(maxWidth: .infinity, alignment: .leading) // 넓이 고정
                    }
                    
                    if let firstPrice = productDetail.prices?.first {
                        Text("\(firstPrice.price ?? 0)원")
                            .font(.callout)
                            .bold()
                            .foregroundColor(.black)
                    }
                    
                    HStack(spacing: 8){
                        if let vibes = productDetail.vibes {
                            ForEach(vibes, id: \.self) { vibe in
                                MoodsLabel(text: vibe)
                            }
                        }
                    }
                }
                .frame(height: 130, alignment: .leading) // 전체 높이 고정
            }
            .padding()
            .background(Color.white)
            .frame(width: 358, height: 130) // 전체 카드의 크기 고정
        }
    }
}


// 예약하기 리스트에서 상세 정보에서 보여줄 카드뷰
struct ReservationDetailCardView: View {
    let reservationDetails: ReservationDetailsResponse
    
    var body: some View {
        VStack {
            HStack(spacing: 32) {
                if let thumbnailUrlString = reservationDetails.post?.thumbNail,
                   let thumbnailUrl = URL(string: thumbnailUrlString) {
                    KFImage(thumbnailUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(reservationDetails.post?.title ?? "제목 없음")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    if let locations = reservationDetails.post?.locations, !locations.isEmpty {
                        Text(locations.joined(separator: " | "))
                            .font(.caption)
                            .foregroundColor(Color("LoginFontColor"))
                    }
                    
                    Text(reservationDetails.maker?.nickName ?? "제작자 없음")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    Text("\(reservationDetails.totalPrice)원")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("예약일시: \(reservationDetails.reservationTime ?? "") ")
                                           .font(.caption)
                                           .foregroundColor(.black)
                                           .fixedSize(horizontal: false, vertical: true) // 이 줄을 추가
                    
//                    Text("예약일시: \(formatDate(reservationDetails.reservationTime))")
//                        .font(.caption)
//                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.white)
            .frame(width: 358, height: 130)
        }
    }
    
    private func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoDate) else { return "날짜 없음" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return displayFormatter.string(from: date)
    }
}

// 예약 내역 조회 카드뷰
struct ReservationInfoCardView: View {
    let productInfo: ReservationData
    
    var body: some View {
        VStack {
            HStack(spacing: 32) {
                if let thumbnailUrlString = productInfo.post?.thumbNail,
                   let thumbnailUrl = URL(string: thumbnailUrlString) {
                    KFImage(thumbnailUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .overlay(
                            VStack {
                                // cancelMessage가 nil이 아니고, 비어있지 않을 때만 CancelLabel 표시
                                if let cancelMessage = productInfo.cancelMessage, !cancelMessage.isEmpty {
                                    CancelLabel(text: "예약취소") // InOutLabel 사용
                                }
                                Spacer()
                            },
                            alignment: .topLeading // 왼쪽 상단 정렬
                        )
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(productInfo.post?.title ?? "제목 없음")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    if let locations = productInfo.post?.locations, !locations.isEmpty {
                        Text(locations.joined(separator: " | "))
                            .font(.caption)
                            .foregroundColor(Color("LoginFontColor"))
                    }
                    
                    Text(productInfo.post?.maker?.nickName ?? "제작자 없음")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    Text("\(productInfo.totalPrice ?? 0)원")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.black)
                    
                    Text("예약일시: \(productInfo.reservationTime ?? "") ")
                                           .font(.caption)
                                           .foregroundColor(.black)
                                           .fixedSize(horizontal: false, vertical: true) // 이 줄을 추가
//                    Text("예약일시: \(formatDate(productInfo.reservationTime ?? ""))")
//                        .font(.caption)
//                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .background(Color.white)
            .frame(width: 358, height: 130)
        }
    }
    
    private func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoDate) else { return "날짜 없음" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return displayFormatter.string(from: date)
    }
}

// 예약 내역 카드뷰 미리보기
struct ReservationInfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleReservationData = ReservationData(
            id: 1,
            reservationTime: "2024-08-18T07:14:50.296Z",
            post: PostDetail(
                id: 1,
                maker: MakerDetail(
                    id: 1,
                    nickName: "Sample Maker"
                ),
                title: "Sample Title",
                thumbNail: "https://via.placeholder.com/150",
                vibes: ["Cozy", "Modern"],
                locations: ["New York", "Brooklyn"],
                price: 100,
                studio: true,
                like: false
            ),
            totalPrice: 200, cancelMessage: nil
        )
        
        return ReservationInfoCardView(productInfo: sampleReservationData)
            .padding()
    }
}
