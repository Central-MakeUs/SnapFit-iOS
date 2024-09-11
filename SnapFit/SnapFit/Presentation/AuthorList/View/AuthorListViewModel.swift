//
//  AuthorListViewModel.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//

import Foundation


class AuthorListViewModel: NSObject, ObservableObject {


    @Published var vibes: [Vibe] = []
    @Published var products: [ProductInfo] = []
    @Published var selectedProductId: Int?
    @Published var productDetail: PostDetailResponse?
}
