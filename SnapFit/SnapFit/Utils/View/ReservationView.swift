//
//  ReservationView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/21/24.
//

import SwiftUI

struct ReservationView: View {
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    @Environment(\.dismiss) var dismiss
    var productInteractor: ProductBusinessLogic?
    @EnvironmentObject var mainPromotionViewModel: MainPromotionViewModel
    @Binding var stack: NavigationPath
    
    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: columns,
                alignment: .center,
                spacing: 16) {
                    
                    // 예약된 상품 리스트를 보여줍니다.
                    ForEach(mainPromotionViewModel.reservationproducts) { product in
                        Button(action: {
                            mainPromotionViewModel.selectedReservationId = product.id
                            stack.append("ReservationInfoView")
                        }) {
                            VStack(spacing: 0) { // 카드뷰와 구분선 사이 간격 0
                                ReservationInfoCardView(productInfo: product)
                                    .frame(width: 358, height: 130)
                                    .padding(.bottom, 22)
                                
                                Divider() // 카드뷰 아래에 구분선 추가
                                    .background(Color.gray.opacity(0.3)) // 구분선 색상
                            }
                        }
                        .buttonStyle(PlainButtonStyle())  // 기본 스타일 제거
                        // NavigationLink를 사용할 때 텍스트 색상이 파란색으로 바뀌는 것을 방지
                    }
                    
                
            }
            //.padding() // ScrollView에 여백 추가
        }
        .onAppear(perform: {
            // 예약 내역 불러오기
            productInteractor?.fetchUserReservations(request: MainPromotion.LoadMainPromotion.Request(limit: 10, offset: 0))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
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
                    AsyncImage(url: thumbnailUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 130, height: 130)
                    }
                } else {
                    // Placeholder if no URL is available
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
                    
                    if let locations = productDetail.locations, !locations.isEmpty {
                        Text(locations.joined(separator: " | "))
                            .font(.caption)
                            .foregroundColor(Color("LoginFontColor"))
                    }
                    
                    // 예시로 가격을 첫 번째 가격으로 설정했습니다.
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
            }
        }
    }
}


// 예약하기 리스트에서 상세 정보에서 보여줄 카드뷰
struct ReservationDetailCardView: View {
    let reservationDetails: ReservationDetailsResponse
    
    var body: some View {
        VStack {
            HStack(spacing: 32) {
                // 이미지 설정
                if let thumbnailUrlString = reservationDetails.post?.thumbNail,
                   let thumbnailUrl = URL(string: thumbnailUrlString) {
                    AsyncImage(url: thumbnailUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 130, height: 130)
                    }
                } else {
                    // Placeholder for missing image
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // 상품 제목
                    Text(reservationDetails.post?.title ?? "제목 없음")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    // 위치 정보
                    if let locations = reservationDetails.post?.locations, !locations.isEmpty {
                        Text(locations.joined(separator: " | "))
                            .font(.caption)
                            .foregroundColor(Color("LoginFontColor"))
                    }
                    
                    // 제작자 닉네임
                    Text(reservationDetails.maker?.nickName ?? "제작자 없음")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    // 총 결제 금액
                    Text("\(reservationDetails.totalPrice)원")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.black)
                    
                    // 예약 일시
                    Text("예약일시: \(formatDate(reservationDetails.reservationTime))")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // 텍스트 영역 최대 너비 설정
            }
            .padding() // 카드 내부 패딩
            .background(Color.white) // 배경색
            //.clipShape(RoundedRectangle(cornerRadius: 10)) // 모서리 둥글기
            //.shadow(radius: 5) // 그림자 효과
            .frame(width: 358, height: 130) // 카드 전체 크기 설정
        }
    }
    
    // 날짜 포맷팅 함수
    private func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoDate) else { return "날짜 없음" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return displayFormatter.string(from: date)
    }
}


//예약 내역 조회 카드뷰
struct ReservationInfoCardView: View {
    let productInfo: ReservationData
    
    var body: some View {
        VStack {
            HStack(spacing: 32) {
                // 이미지 설정
                if let thumbnailUrlString = productInfo.post?.thumbNail,
                   let thumbnailUrl = URL(string: thumbnailUrlString) {
                    AsyncImage(url: thumbnailUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 130, height: 130)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } placeholder: {
                        ProgressView()
                            .frame(width: 130, height: 130)
                    }
                } else {
                    // Placeholder for missing image
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 130, height: 130)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    // 상품 제목과 위치 정보
                    Text(productInfo.post?.title ?? "제목 없음")
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .lineLimit(2)
                    
                    if let locations = productInfo.post?.locations, !locations.isEmpty {
                        Text(locations.joined(separator: " | "))
                            .font(.caption)
                            .foregroundColor(Color("LoginFontColor"))
                    }
                    
                    // 제작자 닉네임
                    Text(productInfo.post?.maker?.nickName ?? "제작자 없음")
                        .font(.caption)
                        .foregroundColor(.black)
                    
                    // 예약 가격
                    Text("\(productInfo.totalPrice ?? 0)원")
                        .font(.callout)
                        .bold()
                        .foregroundColor(.black)
                    
                    // 예약 일시
                    Text("예약일시: \(formatDate(productInfo.reservationTime ?? ""))")
                        .font(.caption)
                        .foregroundColor(.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading) // 텍스트 영역 최대 너비 설정
            }
            .padding() // 카드 내부 패딩
            .background(Color.white) // 배경색
            //.clipShape(RoundedRectangle(cornerRadius: 10)) // 모서리 둥글기
            //.shadow(radius: 5) // 그림자 효과
            .frame(width: 358, height: 130) // 카드 전체 크기 설정
            
        }
    }
    
    // 날짜 포맷팅 함수
    private func formatDate(_ isoDate: String) -> String {
        let isoFormatter = ISO8601DateFormatter()
        guard let date = isoFormatter.date(from: isoDate) else { return "날짜 없음" }
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "yyyy.MM.dd HH:mm"
        return displayFormatter.string(from: date)
    }
}



//#Preview {
//    let path = NavigationPath()
//    
//    return ReservationView(stack: .constant(path))
//        .environmentObject(AuthorDetailView.sampleViewModel)
//}

struct ReservationInfoCardView_Previews: PreviewProvider {
    static var previews: some View {
        // 샘플 데이터 생성
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
            totalPrice: 200
        )
        
        return ReservationInfoCardView(productInfo: sampleReservationData)
            //.previewLayout(.sizeThatFits)
            .padding()
    }
}

