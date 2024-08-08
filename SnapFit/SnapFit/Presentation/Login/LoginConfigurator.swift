//
//  LoginConfigurator.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
//
import SwiftUI


extension LoginView {
    func configureView() -> some View {
        var view = self
        let authWorker = AuthWorker() // AuthWorker를 초기화
        let interactor = LoginInteractor(authWorker: authWorker) // 의존성 주입
        let presenter = LoginPresenter()
        view.interactor = interactor
        interactor.presenter = presenter
        presenter.view = view
        return view
    }
}
