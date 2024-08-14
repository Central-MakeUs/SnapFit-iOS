//
//  MainPromotionPresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import Foundation

protocol MainPromotionPresentationLogic {
    func present(response: MainPromotion.LoadMainPromotion.Response)
}

final class MainPromotionPresenter {
    typealias Response = MainPromotion.LoadMainPromotion.Response
    typealias ViewModel = MainPromotion.LoadMainPromotion.ViewModel
    var view: MainPromotionDisplayLogic?
}

extension MainPromotionPresenter: MainPromotionPresentationLogic {
    func present(response: Response) {
    //    view?.display(viewModel: viewModel)
    }
}