//
//  MainPromotionConfigurator.swift
//  SnapFit
//
//  Created by 정정욱 on 8/14/24.
//  
//
import SwiftUI

extension MainPromotionView {
    func configureView() -> some View {
          var view = self
          let productWorker = ProductWorker() // AuthWorker를 초기화
          let interactor = MainPromotionInteractor(productWorker: productWorker)
          let presenter = MainPromotionPresenter()
          view.mainPromotionInteractor = interactor
          interactor.presenter = presenter
          presenter.view = view // view를 MainPromotionDisplayLogic으로 캐스팅
        
          return view
    }
}


