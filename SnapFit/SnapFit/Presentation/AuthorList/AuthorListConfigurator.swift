//
//  AuthorListConfigurator.swift
//  SnapFit
//
//  Created by 정정욱 on 8/15/24.
//  
//
import SwiftUI

extension AuthorListView {
    func configureView() -> some View {
        var view = self
        let productWorker = ProductWorker() // AuthWorker를 초기화
        let interactor = MainPromotionInteractor(productWorker: productWorker)
        let presenter =  MainPromotionPresenter()
        view.mainPromotionInteractor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}

