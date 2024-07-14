//
//  LoginPresenter.swift
//  SnapFit
//
//  Created by 정정욱 on 7/14/24.
//  
//
import Foundation

protocol LoginPresentationLogic {
    func present(response: Login.LoadLogin.Response)
}

final class LoginPresenter {
    typealias Response = Login.LoadLogin.Response
    typealias ViewModel = Login.LoadLogin.ViewModel
    var view: LoginDisplayLogic?
}

extension LoginPresenter: LoginPresentationLogic {
    func present(response: Response) {
    //    view?.display(viewModel: viewModel)
    }
}