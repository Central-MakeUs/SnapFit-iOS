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
        
        // 기본적으로 "전체" 버튼이 선택되도록 초기화
        _selectedTab.wrappedValue = -1
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
                // "전체" 버튼 추가
                Button(action: {
                    withAnimation {
                        selectedTab = -1 // "전체" 버튼의 인덱스를 -1로 설정
                        fetchAllProducts()
                    }
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
                            .animation(.easeInOut(duration: 0.4), value: selectedTab)
                    }
                    .frame(width: 78, height: 49)
                }
                
                ForEach(vibes.indices, id: \.self) { index in
                    Button(action: {
                        withAnimation {
                            selectedTab = index
                            let selectedVibe = vibes[index].name ?? ""
                            fetchProducts(for: selectedVibe)
                        }
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
                                .animation(.easeInOut(duration: 0.4), value: selectedTab)
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
    
    private func fetchProducts(for vibe: String) {
        // Assuming the request requires the vibe to be a comma-separated string
        authorListInteractor?.fetchProductsFromServerWithFilter(request: MainPromotion.LoadMainPromotion.VibesRequest(vibes: vibe))
    }
    
    private func fetchAllProducts() {
        // 호출할 메서드
        authorListInteractor?.fetchProductAll(request: MainPromotion.LoadMainPromotion.Request(limit: 10, offset: 0))
    }
}

#Preview {
    CustomTopTabbar(selectedTab: .constant(-1), authorListInteractor: nil, vibes: [
        SnapFit.Vibe(id: 1, name: "러블리"),
        SnapFit.Vibe(id: 2, name: "시크"),
        SnapFit.Vibe(id: 3, name: "차분함")
    ])
}
