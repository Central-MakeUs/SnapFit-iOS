//
//  MainPromotionPresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import Foundation

protocol MainPromotionPresentationLogic {

    func presentFetchProductAllSuccess(response : MainPromotion.LoadMainPromotion.Response)
    func presentFetchProductAllFailure(error: ApiError)
    
    func presentFetchPostDetailByIdSuccess(response: MainPromotion.LoadDetailProduct.Response)
    func presentFetchPostDetailByIdFailure(error: ApiError)
    
    func presentVibes(_ vibes: [Vibe])
    func presentVibesFetchFailure(_ error: Error)
}



class MainPromotionPresenter: MainPromotionPresentationLogic {
  
 
    var view: MainPromotionDisplayLogic?
    
    func presentFetchProductAllSuccess(response : MainPromotion.LoadMainPromotion.Response) {
        // Response를 ViewModel로 변환
                let viewModel = MainPromotion.LoadMainPromotion.ViewModel(products: response.products)
                // View에 전달
                view?.display(viewModel: viewModel)
    }
    
    func presentFetchProductAllFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    
    func presentFetchPostDetailByIdSuccess(response: MainPromotion.LoadDetailProduct.Response) {
        let viewModel = MainPromotion.LoadDetailProduct.ViewModel(productDetail: response.productDetail)
        // View에 전달
        view?.displayDetail(viewModel: viewModel)
    }
    
    func presentFetchPostDetailByIdFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    // 분위기 정보를 View에 전달
    func presentVibes(_ vibes: [Vibe]) {
        let viewModel = MainPromotion.LoadMainPromotion.VibesPresentationViewModel(vibes: vibes)
        view?.displayVibes(viewModel: viewModel)
    }
    
    // 분위기 정보를 가져오는 데 실패했을 때 View에 에러를 전달
    func presentVibesFetchFailure(_ error: Error) {
        print("Error fetching vibes: \(error)")  // 실제 앱에서는 UI에 에러를 표시해야 함
    }

    // 전달 로직
}

