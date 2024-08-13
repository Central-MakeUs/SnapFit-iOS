//
//  MyPageConfigurator.swift
//  SnapFit
//
//  Created by 정정욱 on 8/12/24.
//

import SwiftUI


extension MyPageView {
    func configureView() -> some View {
        var view = self
        let authWorker = AuthWorker() // AuthWorker를 초기화
        let interactor = MyPageInteractor(authWorker: authWorker) // 의존성 주입
        let presenter =  MyPagePresenter()
        view.myPageInteractor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}


