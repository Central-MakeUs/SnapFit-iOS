//
//  MainPromotionView.swift
//  SnapFit
//
//  Created by 정정욱 on 7/31/24.
//
import SwiftUI

protocol MainPromotionDisplayLogic {
    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel) // 유즈케이스 수정필요
    func displayDetail(viewModel: MainPromotion.LoadDetailProduct.ViewModel) // 유즈케이스 수정필요
    func displayDetailProductsForMaker(viewModel: MainPromotion.LoadDetailProduct.ProductsForMakerViewModel)
    func displayVibes(viewModel: MainPromotion.LoadMainPromotion.VibesPresentationViewModel)
}

extension MainPromotionView: MainPromotionDisplayLogic {
    
    func display(viewModel: MainPromotion.LoadMainPromotion.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.products = viewModel.products.data
            //print("viewModel.products.data \(viewModel.products.data)")
            print("mainPromotionViewModel.products \( mainPromotionViewModel.products)")
        }
    }
    
    func displayDetail(viewModel: MainPromotion.LoadDetailProduct.ViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.productDetail = viewModel.productDetail
            print("mainPromotionViewModel.productDetail \( mainPromotionViewModel.productDetail)")
        }
    }
    
    func displayDetailProductsForMaker(viewModel: MainPromotion.LoadDetailProduct.ProductsForMakerViewModel) {
        DispatchQueue.main.async {
            mainPromotionViewModel.productDetailAuthorProducts = viewModel.products.data
            print("mainPromotionViewModel.productDetailAuthorProducts \( mainPromotionViewModel.productDetailAuthorProducts)")
        }
    }
    
    func displayVibes(viewModel: MainPromotion.LoadMainPromotion.VibesPresentationViewModel) {
        print()
    }
    
}


struct MainPromotionView: View {
    @State var stack = NavigationPath()
    var mainPromotionInteractor: MainPromotionBusinessLogic?
    
    @ObservedObject var mainPromotionViewModel: MainPromotionViewModel
    
    var body: some View {
        NavigationStack(path: $stack) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // 상단 로고 및 인사말
                    HeaderView()
                        .padding(.bottom, 30)
                    
                    // 섹션 1: 추천 사진
                    SectionHeaderView(title: "이런 사진은 어때요?")
                    
                    NavigationLink(value: "AuthorDetailView"){
                        MainPromotionRandomCardView()
                            .padding(.vertical, 16)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // 섹션 2: 미니 카드 뷰
                    SectionMiniCardsView(stack: $stack)
                        .padding(.bottom, 40)
                    
                    // 섹션 3: 메이커와 추억 만들기
                    SectionHeaderView(title: "메이커와 소중한 추억을 만들어보세요")
                    SectionBigCardsView(stack: $stack)
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
                    AuthorReservationView(stack: $stack)
                        .navigationBarBackButtonHidden(true)
                case "AuthorReservationReceptionView" :
                    AuthorReservationReceptionView(stack: $stack)
                        .navigationBarBackButtonHidden(true)
                default:
                    SnapFitTabView()
                }
            }
            .onAppear {
                
                mainPromotionInteractor?.fetchProductAll(request : MainPromotion.LoadMainPromotion.Request(limit: 10, offset: 0))
                
                print(stack.count)
                stack = NavigationPath()
            
                
            }
        }// 스택 블럭 안에 .navigationDestination 가 있어야함
        
    }
    
}

struct HeaderView: View {
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
                    Text("안녕하세요, 한소희님")
                        .font(.title2)
                        .bold()
                    Text("스냅핏에서는 원하는\n분위기의 사진을 찾을 수 있어요.")
                        .font(.subheadline)
                        .foregroundColor(Color(.systemGray))
                        .padding(.bottom)
                }
                Spacer()
                Image("SnapFitProfileLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SectionMiniCardsView: View {
    @EnvironmentObject var mainPromotionViewModel: MainPromotionViewModel
    @Binding var stack: NavigationPath

    let layout: [GridItem] = [GridItem(.fixed(130))] // Fixed size layout

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: layout, spacing: 8) {
                ForEach(mainPromotionViewModel.products) { product in
                    Button(action: {
                        mainPromotionViewModel.selectedProductId = product.id
                        stack.append("AuthorDetailView")
                    }) {
                        MiniCardView(product: product)
                            .frame(width: 130, height: 202)
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
