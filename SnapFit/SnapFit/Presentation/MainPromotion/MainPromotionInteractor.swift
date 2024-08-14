//
//  MainPromotionInteractor.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import Foundation

protocol MainPromotionBusinessLogic {
    func load(request: MainPromotion.LoadMainPromotion.Request)
}

final class MainPromotionInteractor {
    typealias Request = MainPromotion.LoadMainPromotion.Request
    typealias Response = MainPromotion.LoadMainPromotion.Response
    var presenter: MainPromotionPresentationLogic?
}

extension MainPromotionInteractor: MainPromotionBusinessLogic {
    func load(request: Request) {
        // presenter?.present(response:  Response)
    }
}
