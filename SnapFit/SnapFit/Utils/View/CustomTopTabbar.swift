//
//  CustomTopTabbar.swift
//  SnapFit
//
//  Created by 정정욱 on 8/2/24.
//

import SwiftUI

struct CustomTopTabbar: View {
    @Binding var selectedTab: Int
    var authorListInteractor: AuthorListBusinessLogic?
    var vibes: [Vibe]
    
    init(selectedTab: Binding<Int>, authorListInteractor: AuthorListBusinessLogic?, vibes: [Vibe]) {
        _selectedTab = selectedTab
        self.authorListInteractor = authorListInteractor
        self.vibes = vibes
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                // "전체" 버튼 추가
                Button(action: {
                    handleTabChange(to: -1)
                }) {
                    VStack(spacing: 0) {
                        Text("전체")
                            .padding()
                            .font(.subheadline)
                            .frame(minWidth: 50)
                            .foregroundColor(selectedTab == -1 ? .black : .gray)
                            .background(Color.white)
                        
                        // 하단 바
                        Rectangle()
                            .frame(height: 8)
                            .foregroundColor(selectedTab == -1 ? .black : Color(.systemGray6))
                    }
                    .frame(width: 78, height: 49)
                }
                
                ForEach(vibes.indices, id: \.self) { index in
                    Button(action: {
                        handleTabChange(to: index)
                    }) {
                        VStack(spacing: 0) {
                            Text(vibes[index].name ?? "")
                                .padding()
                                .font(.subheadline)
                                .frame(minWidth: 50)
                                .foregroundColor(selectedTab == index ? .black : .gray)
                                .background(Color.white)
                            
                            // 하단 바
                            Rectangle()
                                .frame(height: 8)
                                .foregroundColor(selectedTab == index ? .black : Color(.systemGray6))
                        }
                        .frame(width: 78, height: 49)
                    }
                }
            }
            .frame(height: 49)
        }
        .background(Color.white)
        .onAppear {
            // "전체" 제품을 로드
            if selectedTab == -1 {
                fetchAllProducts()
            }
        }
    }
    
    private func handleTabChange(to index: Int) {
        withAnimation {
            selectedTab = index
            if index == -1 {
                fetchAllProducts()
            } else {
                let selectedVibe = vibes[index].name ?? ""
                fetchProducts(for: selectedVibe)
            }
        }
    }
    
    private func fetchProducts(for vibe: String) {
        authorListInteractor?.fetchProductsFromServerWithFilter(request: MainPromotionUseCase.LoadMainPromotion.VibesRequest(vibes: vibe))
    }
    
    private func fetchAllProducts() {
        authorListInteractor?.fetchProductAll(request: MainPromotionUseCase.LoadMainPromotion.Request(limit: 30, offset: 0))
    }
}


#Preview {
    CustomTopTabbar(selectedTab: .constant(-1), authorListInteractor: nil, vibes: [
        SnapFit.Vibe(id: 1, name: "러블리"),
        SnapFit.Vibe(id: 2, name: "시크"),
        SnapFit.Vibe(id: 3, name: "차분함")
    ])
}
