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
}

final class MainPromotionPresenter {
    typealias Response = MainPromotion.LoadMainPromotion.Response
    typealias ViewModel = MainPromotion.LoadMainPromotion.ViewModel
    var view: MainPromotionDisplayLogic?
}

extension MainPromotionPresenter: MainPromotionPresentationLogic {
    
    func presentFetchProductAllSuccess(response : MainPromotion.LoadMainPromotion.Response) {
        // Response를 ViewModel로 변환
                let viewModel = MainPromotion.LoadMainPromotion.ViewModel(products: response.products)
                // View에 전달
                view?.display(viewModel: viewModel)
    }
    
    func presentFetchProductAllFailure(error: ApiError) {
        print("Error occurred: \(error)")
    }
    
    
    // 전달 로직 
}

