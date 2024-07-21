//
//  MainPromotionConfigurator.swift
//  SnapFit
//
//  Created by 정정욱 on 7/17/24.
//  
//
import SwiftUI

extension MainPromotionView {
    func configureView() -> some View {
        var view = self
        let interactor = MainPromotionInteractor()
        let presenter = MainPromotionPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}
