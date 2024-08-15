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
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 0) {
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
    }
    
    private func fetchProducts(for vibe: String) {
        // Assuming the request requires the vibe to be a comma-separated string
        authorListInteractor?.fetchProductsFromServerWithFilter(request: MainPromotion.LoadMainPromotion.VibesRequest(vibes: vibe))
    }
}

#Preview {
    CustomTopTabbar(selectedTab: .constant(0), authorListInteractor: nil, vibes: [
        SnapFit.Vibe(id: 1, name: "러블리"),
        SnapFit.Vibe(id: 2, name: "시크"),
        SnapFit.Vibe(id: 3, name: "차분함")
    ])
}
