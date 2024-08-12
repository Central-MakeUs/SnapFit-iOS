//
//  AuthorDetailView.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//
import SwiftUI

struct AuthorDetailView: View {
    @State private var selectedTab: Int = 0
    @EnvironmentObject var navigationModel: NavigationModel // EnvironmentObject로 NavigationModel을 사용

    var body: some View {
        ZStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading) {
                    MainContentView()
                    DividerAndRegulationView()
                    Spacer().frame(height: 100) // 예약 버튼에 대한 공간 추가
                }
                .padding(.bottom)
            }

            // 고정된 NextButton
            VStack {
                Spacer()
                NextButton()
            }
            .edgesIgnoringSafeArea(.bottom) // NextButton이 항상 화면 하단에 고정되도록 설정
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    // 뒤로 가기 버튼을 사용하여 네비게이션 경로를 관리
                    navigationModel.navigationPath.removeLast()
                }) {
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
}

// 주요 콘텐츠 뷰
struct MainContentView: View {
    let layout: [GridItem] = [GridItem(.flexible())]

    var body: some View {
        Group {
            ImageSliderView(images: ["demo1", "demo2", "demo3"])
                .frame(width: .infinity)
                .padding(.bottom)
            
            Text("나의 첫 스냅사진 감성을 담은 스냅사진")
                .font(.title3)
                .bold()
                .padding(.horizontal)
            
            HStack {
                MoodsLabel(text: "시크")
                InOutLabel(text: "야외스냅")
            }
            .padding(.horizontal)
            
            PriceView(price: "32,400원")
            
            SectionHeaderView(title: "위치")
            
            HStack(spacing: 8) {
                StarImageLabel(text: "서울 용산구")
                StarImageLabel(text: "서울 중구")
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
            
            HStack(spacing: 8) {
                Image("AuthorDec")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text("작가의 설명")
            }
            .padding(.horizontal)
            
            Text("사진에서는 빛과 색감의 조화가 돋보이며, 피사체에 대한 깊이 있는 관찰력이 드러납니다. 사진에서는 빛과 색감의 조화가 돋보이며, 피사체에 대한 깊이 있는 관찰력이 드러납니다.")
                .font(.caption)
                .foregroundColor(Color(.systemGray))
                .padding(.horizontal)
                .padding(.bottom, 40)
            
            SectionHeaderView(title: "등록된 상품")
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: layout, spacing: 8) {
                    ForEach(0..<10, id: \.self) { item in
                        MiddleCardView()
                            .frame(width: 175, height: 270)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 40)
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
    @EnvironmentObject var navigationModel: NavigationModel // EnvironmentObject로 NavigationModel을 사용
    
    var body: some View {
        Button(action: {
            navigationModel.navigationPath.append("AuthorReservation")
        }) {
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
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 32, trailing: 16))
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
    AuthorDetailView()
}
