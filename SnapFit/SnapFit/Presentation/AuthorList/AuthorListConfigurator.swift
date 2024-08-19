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
        let interactor = AuthorListInteractor(productWorker: productWorker)
        let presenter =  AuthorListPresenter()
        view.authorListInteractor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}




